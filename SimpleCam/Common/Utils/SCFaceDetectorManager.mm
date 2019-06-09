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

#import "SCFaceDetectorManager.h"

@implementation SCFaceDetectorManager

+ (float *)detectWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
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
        return 0;
    }
}

+ (int)facePointCount {
    return stasm_NLANDMARKS;
}

#pragma mark - Private

// 生成灰度图矩阵
+(cv::Mat)grayMatWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
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
+ (cv::Mat)resizeMat:(cv::Mat)mat toWidth:(CGFloat)width {
    CGFloat orginWidth = mat.cols;
    CGFloat orginHeight = mat.rows;
    int reCols = width;
    int reRows = (int)((CGFloat)reCols * orginHeight) / orginWidth;
    cv::Size reSize = cv::Size(reCols, reRows);
    resize(mat, mat, reSize);
    
    return mat;
}

// 矫正图像
+ (cv::Mat)correctMat:(cv::Mat)mat isMirror:(BOOL)isMirror {
    if (!isMirror) {
        cv::flip(mat, mat, 0);  // > 0: 沿 y 轴翻转, 0: 沿 x 轴翻转, <0: x、y 轴同时翻转
    }
    // transpose 会旋转 90 度的同时，进行镜像变换，所以后置的时候反而需要先镜像一次
    cv::transpose(mat, mat);
    return mat;
}

@end
