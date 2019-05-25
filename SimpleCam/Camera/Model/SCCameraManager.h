//
//  SCCameraManager.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterHandler.h"

typedef void (^TakePhotoResult)(UIImage *resultImage, NSError *error);

typedef void (^RecordVideoResult)(NSString *videoPath);

@interface SCCameraManager : NSObject

/// 相机
@property (nonatomic, strong, readonly) GPUImageStillCamera *camera;

/// 滤镜
@property (nonatomic, strong, readonly) SCFilterHandler *currentFilterHandler;

/**
 获取实例
 */
+ (SCCameraManager *)shareManager;

/**
 拍照
 */
- (void)takePhotoWtihCompletion:(TakePhotoResult)completion;

/**
 录制
 */
- (void)recordVideo;

/**
 结束录制视频
 
 @param completion 完成回调
 */
- (void)stopRecordVideoWithCompletion:(RecordVideoResult)completion;

/**
 添加图像输出的控件，不会被持有
 */
- (void)addOutputView:(GPUImageView *)outputView;

/**
 开启相机，开启前请确保已经设置 outputView
 */
- (void)startCapturing;

/**
 切换摄像头
 */
- (void)rotateCamera;

@end
