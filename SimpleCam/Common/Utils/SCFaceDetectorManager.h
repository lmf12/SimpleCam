//
//  SCFaceDetectorManager.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/9.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>

/**
 人脸识别引擎

 - SCFaceDetectModeNone: 不使用
 - SCFaceDetectModeFacepp: Face++
 */
typedef NS_ENUM(NSUInteger, SCFaceDetectMode) {
    SCFaceDetectModeNone,
    SCFaceDetectModeFacepp,
};

@interface SCFaceDetectorManager : NSObject

/// 预览尺寸，默认 (720, 1280)，由于人脸识别是基于 (720, 1280)来进行，所以需要根据比例尺寸来计算正确的人脸点位置
@property (nonatomic, assign) CGSize videoSize;
/// 顶部距离偏移，默认0，用来计算人脸点位置
@property (nonatomic, assign) CGFloat sampleBufferTopOffset;
/// 左部距离偏移，默认0，用来计算人脸点位置
@property (nonatomic, assign) CGFloat sampleBufferLeftOffset;

/// 人脸识别引擎，默认 SCFaceDetectModeFacepp
@property (nonatomic, assign) SCFaceDetectMode faceDetectMode;

/// 获取单例
+ (SCFaceDetectorManager *)shareManager;

/// Face++ 联网授权，成功后会进行初始化
- (void)licenseFacepp;

/// 获取人脸点，前置是镜像
- (float *)detectWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
                   facePointCount:(int *)facePointCount
                         isMirror:(BOOL)isMirror;

@end
