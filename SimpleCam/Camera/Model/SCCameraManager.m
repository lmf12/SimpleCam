//
//  SCCameraManager.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraManager.h"

static SCCameraManager *_cameraManager;

@interface SCCameraManager ()

@property (nonatomic, strong, readwrite) GPUImageStillCamera *camera;
@property (nonatomic, weak) GPUImageView *outputView;
@property (nonatomic, weak) GPUImageOutput<GPUImageInput> *currentFilters;

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
    if (self.currentFilters) {
        [self.currentFilters removeTarget:self.outputView];
        [self.camera removeTarget:self.currentFilters];
    }
    
    self.currentFilters = filters;
    
    if (filters) {
        [self.camera addTarget:self.currentFilters];
        [self.currentFilters addTarget:self.outputView];
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

@end
