//
//  SCFaceDetectorManager.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/9.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>

@interface SCFaceDetectorManager : NSObject

/// 获取人脸点，前置是镜像
+ (float *)detectWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
                      isMirror:(BOOL)isMirror;

/// 人脸点个数
+ (int)facePointCount;

@end
