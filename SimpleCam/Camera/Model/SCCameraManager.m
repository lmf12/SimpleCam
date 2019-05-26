//
//  SCCameraManager.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFileHelper.h"

#import "SCCameraManager.h"

static SCCameraManager *_cameraManager;

@interface SCCameraManager ()

@property (nonatomic, strong, readwrite) GPUImageStillCamera *camera;
@property (nonatomic, weak) GPUImageView *outputView;
@property (nonatomic, strong, readwrite) SCFilterHandler *currentFilterHandler; 
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, copy) NSString *currentTmpVideoPath;

@end

@implementation SCCameraManager

+ (SCCameraManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cameraManager = [[SCCameraManager alloc] init];
    });
    return _cameraManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupFilterHandler];
    }
    return self;
}

#pragma mark - Public

- (void)takePhotoWtihCompletion:(TakePhotoResult)completion {
    GPUImageFilter *lastFilter = self.currentFilterHandler.lastFilter;
    [self.camera capturePhotoAsJPEGProcessedUpToFilter:lastFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        if (error && completion) {
            completion(nil, error);
            return;
        }
        UIImage *image = [UIImage imageWithData:processedJPEG];
        if (completion) {
            completion(image, nil);
        }
    }];
}

- (void)recordVideo {
    [self setupMovieWriter];
    [self.movieWriter startRecording];
}

- (void)stopRecordVideoWithCompletion:(RecordVideoResult)completion {
    @weakify(self);
    [self.movieWriter finishRecordingWithCompletionHandler:^{
        @strongify(self);
        [self removeMovieWriter];
        if (completion) {
            completion(self.currentTmpVideoPath);
        }
    }];
}

- (void)addOutputView:(GPUImageView *)outputView {
    self.outputView = outputView;
}

- (void)startCapturing {
    if (!self.outputView) {
        NSAssert(NO, @"output 未被赋值");
        return;
    }
    [self setupCamera];
    
    [self.camera addTarget:self.currentFilterHandler.firstFilter];
    [self.currentFilterHandler.lastFilter addTarget:self.outputView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.camera startCameraCapture];
    });
}

- (void)rotateCamera {
    [self.camera rotateCamera];
    // 切换摄像头，同步一下闪光灯
    [self syncFlashState];
}

- (void)closeFlashIfNeed {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasFlash] && device.torchMode == AVCaptureTorchModeOn) {
        [device lockForConfiguration:nil];
        device.torchMode = AVCaptureTorchModeOff;
        device.flashMode = AVCaptureFlashModeOff;
        [device unlockForConfiguration];
    }
}

- (void)updateFlash {
    [self syncFlashState];
}

#pragma mark - Custom Accessor

- (void)setFlashMode:(SCCameraFlashMode)flashMode {
    _flashMode = flashMode;
    
    [self syncFlashState];
}

#pragma mark - Private

/**
 初始化相机
 */
- (void)setupCamera {
    self.camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
    [self.camera addAudioInputsAndOutputs];
    
    self.currentFilterHandler.source = self.camera;
}

/**
 初始化 MovieWriter
 */
- (void)setupMovieWriter {
    NSString *videoPath = [SCFileHelper randomFilePathInTmpWithSuffix:@".m4v"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize videoSize = CGSizeMake(self.outputView.frame.size.width * screenScale,
                                  self.outputView.frame.size.height * screenScale);
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:videoURL
                                                                size:videoSize];
    
    GPUImageFilter *lastFilter = self.currentFilterHandler.lastFilter;
    [lastFilter addTarget:self.movieWriter];
    self.camera.audioEncodingTarget = self.movieWriter;
    self.movieWriter.shouldPassthroughAudio = YES;
    
    self.currentTmpVideoPath = videoPath;
}

/**
 移除 MovieWriter
 */
- (void)removeMovieWriter {
    if (!self.movieWriter) {
        return;
    }
    [self.currentFilterHandler.lastFilter removeTarget:self.movieWriter];
    self.camera.audioEncodingTarget = nil;
    self.movieWriter = nil;
}

/**
 初始化 FilterHandler
 */
- (void)setupFilterHandler {
    self.currentFilterHandler = [[SCFilterHandler alloc] init];
    [self.currentFilterHandler setBeautifyFilter:nil];
    [self.currentFilterHandler setDefaultFilter:nil];
}

/**
 将 flashMode 的值同步到设备
 */
- (void)syncFlashState {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasFlash] || self.camera.cameraPosition == AVCaptureDevicePositionFront) {
        [self closeFlashIfNeed];
        return;
    }
    
    [device lockForConfiguration:nil];
    
    switch (self.flashMode) {
        case SCCameraFlashModeOff:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOff;
            break;
        case SCCameraFlashModeOn:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOn;
            break;
        case SCCameraFlashModeAuto:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeAuto;
            break;
        case SCCameraFlashModeTorch:
            device.torchMode = AVCaptureTorchModeOn;
            device.flashMode = AVCaptureFlashModeOff;
            break;
        default:
            break;
    }
    
    [device unlockForConfiguration];
}

@end
