//
//  SCFaceDetectorManager.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/9.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#include "stasm_lib.h"
#include <opencv2/face.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/imgcodecs/ios.h>
#include <opencv2/imgproc/imgproc.hpp>

#import "MGFacepp.h"
#import "MGFaceLicenseHandle.h"

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
                      isMirror:(BOOL)isMirror {
    float *facePoints = nil;
    if (self.faceDetectMode == SCFaceDetectModeOpenCV) {
        facePoints = [self detectInOpenCVWithSampleBuffer:sampleBuffer
                                                 isMirror:isMirror];
    } else {
        facePoints = [self detectInFaceppWithSampleBuffer:sampleBuffer
                                                 isMirror:isMirror];
    }
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

- (int)facePointCount {
    if (self.faceDetectMode == SCFaceDetectModeOpenCV) {
        return stasm_NLANDMARKS;
    } else {
        return kFaceppPointCount;
    }
}

#pragma mark - Private

// 通用初始化
- (void)commonInit {
    self.sampleBufferSize = CGSizeMake(720, 1280);
    self.faceDetectMode = SCFaceDetectModeOpenCV;
}


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

// 用 OpenCV 人脸识别
- (float *)detectInOpenCVWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
                                 isMirror:(BOOL)isMirror {
    cv::Mat cvImage = [self grayMatWithSampleBuffer:sampleBuffer];
    int resultWidth = 150;
    int resultHeight = resultWidth * 1.0 / cvImage.rows * cvImage.cols;
    cvImage = [self resizeMat:cvImage toWidth:resultHeight]; // 此时还没旋转，所以传入高度
    cvImage = [self correctMat:cvImage isMirror:isMirror];
    const char *imgData = (const char *)cvImage.data;
    
    // 是否找到人脸
    int foundface;
    // stasm_NLANDMARKS 表示人脸关键点数，乘 2 表示要分别存储 x， y
    int len = 2 * stasm_NLANDMARKS;
    float *landmarks = (float *)malloc(len * sizeof(float));
    
    // 获取宽高
    int imgCols = cvImage.cols;
    int imgRows = cvImage.rows;
    
    // 训练库的目录，直接传 [NSBundle mainBundle].bundlePath 就可以，会自动找到所有文件
    const char *xmlPath = [[NSBundle mainBundle].bundlePath UTF8String];
    
    // 返回 0 表示出错
    int stasmActionError = stasm_search_single(&foundface,
                                               landmarks,
                                               imgData,
                                               imgCols,
                                               imgRows,
                                               "",
                                               xmlPath);
    // 打印错误信息
    if (!stasmActionError) {
        printf("Error in stasm_search_single: %s\n", stasm_lasterr());
    }
    
    // 释放cv::Mat
    cvImage.release();
    
    // 识别到人脸
    if (foundface) {
        // 转换坐标
        for (int index = 0; index < len; ++index) {
            if (index % 2 == 0) {
                landmarks[index] = landmarks[index] / imgCols * 2 - 1;
            } else {
                landmarks[index] = landmarks[index] / imgRows * 2 - 1;
            }
        }
        return landmarks;
    } else {
        free(landmarks);
        return nil;
    }
}

// 用 Face++ 人脸识别
- (float *)detectInFaceppWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
                                 isMirror:(BOOL)isMirror {
    if (!self.markManager) {
        return nil;
    }

    MGImageData *imageData = [[MGImageData alloc] initWithSampleBuffer:sampleBuffer];
    [self.markManager beginDetectionFrame];
    NSArray *faceArray = [self.markManager detectWithImageData:imageData];
    
    int len = 2 * kFaceppPointCount;
    float *landmarks = (float *)malloc(len * sizeof(float));
    
    for (MGFaceInfo *faceInfo in faceArray) {
        [self.markManager GetGetLandmark:faceInfo isSmooth:YES pointsNumber:kFaceppPointCount];
        [faceInfo.points enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL *stop) {
            float x = value.CGPointValue.y / self.sampleBufferSize.width;
            x = (isMirror ? x : (1 - x))  * 2 - 1;
            float y = value.CGPointValue.x / self.sampleBufferSize.height * 2 - 1;
            landmarks[idx * 2] = x;
            landmarks[idx * 2 + 1] = y;
        }];
    }
    [self.markManager endDetectionFrame];
    
    if (faceArray.count) {
        return landmarks;
    } else {
        free(landmarks);
        return nil;
    }
}

// 生成灰度图矩阵
- (cv::Mat)grayMatWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    OSType format = CVPixelBufferGetPixelFormatType(pixelBuffer);
    // 检查是否 YUV 编码
    if (format != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
        NSLog(@"Only YUV is supported");
        return cv::Mat();
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *baseaddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    CGFloat width = CVPixelBufferGetWidth(pixelBuffer);
    CGFloat colCount = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
    if (width != colCount) {
        width = colCount;
    }
    CGFloat height = CVPixelBufferGetHeight(pixelBuffer);
    // CV_8UC1 表示单通道矩阵，转换为单通道灰度图后，可以使识别的计算速度提高
    cv::Mat mat(height, width, CV_8UC1, baseaddress, 0);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return mat;
}

// 矩阵缩放
- (cv::Mat)resizeMat:(cv::Mat)mat toWidth:(CGFloat)width {
    CGFloat orginWidth = mat.cols;
    CGFloat orginHeight = mat.rows;
    int reCols = width;
    int reRows = (int)((CGFloat)reCols * orginHeight) / orginWidth;
    cv::Size reSize = cv::Size(reCols, reRows);
    resize(mat, mat, reSize);
    
    return mat;
}

// 矫正图像
- (cv::Mat)correctMat:(cv::Mat)mat isMirror:(BOOL)isMirror {
    if (!isMirror) {
        cv::flip(mat, mat, 0);  // > 0: 沿 y 轴翻转, 0: 沿 x 轴翻转, <0: x、y 轴同时翻转
    }
    // transpose 会旋转 90 度的同时，进行镜像变换，所以后置的时候反而需要先镜像一次
    cv::transpose(mat, mat);
    return mat;
}

@end
