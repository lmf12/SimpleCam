//
//  SCCameraTopView.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/15.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCCameraTopView;

@protocol SCCameraTopViewDelegate <NSObject>

- (void)cameraTopViewDidClickRotateButton:(SCCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickFlashButton:(SCCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickRatioButton:(SCCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickCloseButton:(SCCameraTopView *)cameraTopView;
- (void)cameraTopViewDidClickSettingButton:(SCCameraTopView *)cameraTopView;

@end

@interface SCCameraTopView : UIView

@property (nonatomic, strong, readonly) UIButton *rotateButton;  // 切换前后置按钮
@property (nonatomic, strong, readonly) UIButton *flashButton;  // 闪光灯按钮
@property (nonatomic, strong, readonly) UIButton *ratioButton;  // 比例按钮
@property (nonatomic, strong, readonly) UIButton *closeButton;  // 关闭按钮
@property (nonatomic, strong, readonly) UIButton *settingButton;  // 设置按钮

@property (nonatomic, weak) id <SCCameraTopViewDelegate> delegate;

@end
