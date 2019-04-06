//
//  SCCameraManager.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <GPUImage.h>

typedef void (^TakePhotoResult)(UIImage *resultImage, NSError *error);

@interface SCCameraManager : NSObject

/// 相机
@property (nonatomic, strong, readonly) GPUImageStillCamera *camera;

/**
 获取实例
 */
+ (SCCameraManager *)shareManager;

/**
 拍照

 @param filters 拍照添加的滤镜效果
 @param completion 完成回调
 */
- (void)takePhotoWtihFilters:(GPUImageOutput<GPUImageInput> *)filters
                  completion:(TakePhotoResult)completion;

/**
 添加图像输出的控件，不会被持有
 */
- (void)addOutputView:(GPUImageView *)outputView;

/**
 添加相机预览的滤镜，不会被持有
 */
- (void)setCameraFilters:(GPUImageOutput<GPUImageInput> *)filters;

/**
 开启相机，开启前请确保已经设置 outputView
 */
- (void)startCapturing;

@end
