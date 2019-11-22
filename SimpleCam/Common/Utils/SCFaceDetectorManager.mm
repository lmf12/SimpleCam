//
//  SCFaceDetectorManager.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/9.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "MGFacepp.h"
#import "MGFaceLicenseHandle.h"

#import "SCAppSetting.h"

#import "SCFaceDetectorManager.h"

#define kFaceppPointCount 106  // Face++ 的人脸点数

static SCFaceDetectorManager *_faceDetectorManager;

@interface SCFaceDetectorManager ()

@property (nonatomic, strong) MGFacepp *markManager;

@end

@implementation SCFaceDetectorManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (SCFaceDetectorManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _faceDetectorManager = [[SCFaceDetectorManager alloc] init];
    });
    return _faceDetectorManager;
}

#pragma mark - Public

- (float *)detectWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
                   facePointCount:(int *)facePointCount
                         isMirror:(BOOL)isMirror {
    float *facePoints = [self detectInFaceppWithSampleBuffer:sampleBuffer
                                              facePointCount:(int *)facePointCount
                                                    isMirror:isMirror];
    return facePoints;
}

- (void)licenseFacepp {
    @weakify(self);
    [MGFaceLicenseHandle licenseForNetwokrFinish:^(bool License, NSDate *sdkDate) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (License) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"Face++ 授权成功！"];
                [self setupFacepp];
            } else {
                [[UIApplication sharedApplication].keyWindow makeToast:@"Face++ 授权失败！"];
            }
        });
    }];
}

#pragma mark - Custom Accessor

- (void)setFaceDetectMode:(SCFaceDetectMode)faceDetectMode {
    _faceDetectMode = faceDetectMode;
    
    [SCAppSetting setUsingFaceppEngine:faceDetectMode == SCFaceDetectModeFacepp];
}

#pragma mark - Private

// 通用初始化
- (void)commonInit {
    self.videoSize = CGSizeMake(720, 1280);
    self.sampleBufferTopOffset = 0;
    self.sampleBufferLeftOffset = 0;
    
    SCFaceDetectMode mode = SCFaceDetectModeNone;
    if (![SCAppSetting hasSaveFaceDetectEngine]) {  // 第一次安装启动
        mode = SCFaceDetectModeFacepp;
    } else if ([SCAppSetting isUsingFaceppEngine]) {
        mode = SCFaceDetectModeFacepp;
    }
    self.faceDetectMode = mode;
}

#pragma mark Face++

// 初始化 Face++
- (void)setupFacepp {
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:KMGFACEMODELNAME
                                                          ofType:@""];
    NSData *modelData = [NSData dataWithContentsOfFile:modelPath];
    self.markManager = [[MGFacepp alloc] initWithModel:modelData
                                         faceppSetting:^(MGFaceppConfig *config) {
                                             config.detectionMode = MGFppDetectionModeTrackingRobust;
                                             config.pixelFormatType = PixelFormatTypeNV21;
                                             config.orientation = 90;
                                         }];
}

// 用 Face++ 人脸识别
- (float *)detectInFaceppWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
                           facePointCount:(int *)facePointCount
                                 isMirror:(BOOL)isMirror {
    if (!self.markManager) {
        return nil;
    }

    MGImageData *imageData = [[MGImageData alloc] initWithSampleBuffer:sampleBuffer];
    [self.markManager beginDetectionFrame];
    NSArray *faceArray = [self.markManager detectWithImageData:imageData];
    
    // 人脸个数
    NSInteger faceCount = [faceArray count];
    
    int singleFaceLen = 2 * kFaceppPointCount;
    int len = singleFaceLen * (int)faceCount;
    float *landmarks = (float *)malloc(len * sizeof(float));
    
    for (MGFaceInfo *faceInfo in faceArray) {
        NSInteger faceIndex = [faceArray indexOfObject:faceInfo];
        [self.markManager GetGetLandmark:faceInfo isSmooth:YES pointsNumber:kFaceppPointCount];
        [faceInfo.points enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL *stop) {
            float x = (value.CGPointValue.y - self.sampleBufferLeftOffset) / self.videoSize.width;
            x = (isMirror ? x : (1 - x))  * 2 - 1;
            float y = (value.CGPointValue.x - self.sampleBufferTopOffset) / self.videoSize.height * 2 - 1;
            landmarks[singleFaceLen * faceIndex + idx * 2] = x;
            landmarks[singleFaceLen * faceIndex + idx * 2 + 1] = y;
        }];
    }
    [self.markManager endDetectionFrame];

    if (faceArray.count) {
        *facePointCount = kFaceppPointCount * (int)faceCount;
        return landmarks;
    } else {
        free(landmarks);
        return nil;
    }
}

@end
