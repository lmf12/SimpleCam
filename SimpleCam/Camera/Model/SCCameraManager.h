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

/**
 闪光灯模式

 - SCCameraFlashModeOff: 关闭
 - SCCameraFlashModeOn: 打开
 - SCCameraFlashModeAuto: 自动
 - SCCameraFlashModeTorch: 长亮
 */
typedef NS_ENUM(NSUInteger, SCCameraFlashMode) {
    SCCameraFlashModeOff,
    SCCameraFlashModeOn,
    SCCameraFlashModeAuto,
    SCCameraFlashModeTorch
};

/**
 相机比例

 - SCCameraRatio1v1:  1 : 1
 - SCCameraRatio4v3: 4 : 3
 - SCCameraRatio16v9: 16 : 9
 - SCCameraRatioFull: 全屏 (iPhoneX 才有)
 */
typedef NS_ENUM(NSUInteger, SCCameraRatio) {
    SCCameraRatio1v1,
    SCCameraRatio4v3,
    SCCameraRatio16v9,
    SCCameraRatioFull
};

@interface SCCameraManager : NSObject

/// 相机
@property (nonatomic, strong, readonly) GPUImageStillCamera *camera;

/// 滤镜
@property (nonatomic, strong, readonly) SCFilterHandler *currentFilterHandler;

/// 闪光灯模式，后置摄像头才有效，默认 SCCameraFlashModeOff
@property (nonatomic, assign) SCCameraFlashMode flashMode;

/// 相机比例，默认 SCCameraRatio16v9
@property (nonatomic, assign) SCCameraRatio ratio;

/// 对焦点
@property (nonatomic, assign) CGPoint focusPoint;

/// 通过调整焦距来实现视图放大缩小效果，最小是1
@property (nonatomic, assign) CGFloat videoScale;

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

/**
 如果是常亮，则会关闭闪光灯，但不会修改 flashMode
 */
- (void)closeFlashIfNeed;

/**
 刷新闪光灯
 */
- (void)updateFlash;

/**
 将缩放倍数转化到可用的范围
 */
- (CGFloat)availableVideoScaleWithScale:(CGFloat)scale;

/**
 正在录制中的视频的时长
 */
- (NSTimeInterval)currentDuration;

/**
 当前是否前置
 */
- (BOOL)isPositionFront;

@end
