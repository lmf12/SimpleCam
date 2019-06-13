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

 - SCFaceDetectModeOpenCV: OpenCV
 - SCFaceDetectModeFacepp: Face++
 */
typedef NS_ENUM(NSUInteger, SCFaceDetectMode) {
    SCFaceDetectModeOpenCV,
    SCFaceDetectModeFacepp,
};

@interface SCFaceDetectorManager : NSObject

/// 预览尺寸，默认 (720, 1280)
@property (nonatomic, assign) CGSize sampleBufferSize;

/// 人脸识别引擎，默认 SCFaceDetectModeOpenCV
@property (nonatomic, assign) SCFaceDetectMode faceDetectMode;

/// 获取单例
+ (SCFaceDetectorManager *)shareManager;

/// Face++ 联网授权，成功后会进行初始化
- (void)licenseFacepp;

/// 获取人脸点，前置是镜像
- (float *)detectWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
                      isMirror:(BOOL)isMirror;

/// 人脸点个数
- (int)facePointCount;

@end
