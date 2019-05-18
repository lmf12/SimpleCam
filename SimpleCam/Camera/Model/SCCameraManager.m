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
@property (nonatomic, weak) GPUImageOutput <GPUImageInput> *currentFilters;  // 预览的滤镜
@property (nonatomic, strong) GPUImageOutput <GPUImageInput> *movieWriterFilters;  // movieWriter的滤镜
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

#pragma mark - Public

- (void)takePhotoWtihFilters:(GPUImageOutput<GPUImageInput> *)filters
                  completion:(TakePhotoResult)completion {
    [self.camera capturePhotoAsJPEGProcessedUpToFilter:filters withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
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

- (void)recordVideoWithFilters:(GPUImageOutput<GPUImageInput> *)filters {
    if (filters) {
        self.movieWriterFilters = filters;
        [self.camera addTarget:filters];
    }
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
    
    GPUImageOutput *output = self.camera;
    if (self.currentFilters) {
        [self.camera addTarget:self.currentFilters];
        output = self.currentFilters;
    }
    [output addTarget:self.outputView];
    
    [self.camera startCameraCapture];
}

- (void)setCameraFilters:(GPUImageOutput<GPUImageInput> *)filters {
    NSArray *targets = nil;
    if (self.currentFilters) {
        targets = self.currentFilters.targets;
        [self.currentFilters removeAllTargets];
        [self.camera removeTarget:self.currentFilters];
    }
    
    self.currentFilters = filters;
    
    if (filters) {
        [self.camera addTarget:self.currentFilters];
        for (id <GPUImageInput>input in targets) {
            [self.currentFilters addTarget:input];
        }
    }
}

- (void)rotateCamera {
    [self.camera rotateCamera];
}

#pragma mark - Private

/**
 初始化相机
 */
- (void)setupCamera {
    self.camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
}

/**
 初始化 MovieWriter
 */
- (void)setupMovieWriter {
    NSString *videoPath = [SCFileHelper randomFilePathInTmp];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize videoSize = CGSizeMake(self.outputView.frame.size.width * screenScale,
                                  self.outputView.frame.size.height * screenScale);
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:videoURL
                                                                size:videoSize];
    GPUImageOutput *output = self.movieWriterFilters ? self.movieWriterFilters : self.camera;
    [output addTarget:self.movieWriter];
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
    [self.camera removeTarget:self.movieWriter];
    [self.movieWriterFilters removeTarget:self.movieWriter];
    self.camera.audioEncodingTarget = nil;
    self.movieWriter = nil;
    
    if (self.movieWriterFilters != self.currentFilters) {
        [self.camera removeTarget:self.movieWriterFilters];
        self.movieWriterFilters = nil;
    }
}

@end
