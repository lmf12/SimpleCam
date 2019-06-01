//
//  SCCameraViewController+Private.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <GPUImage.h>
#import "SCCapturingButton.h"
#import "SCFilterBarView.h"
#import "SCCameraTopView.h"
#import "SCCapturingModeSwitchView.h"
#import "SCVisualEffectView.h"

#import "SCCameraManager.h"
#import "SCFilterManager.h"
#import "SCFilterHandler.h"

#import "SCVideoModel.h"
#import "GPUImageBeautifyFilter.h"

#import "SCVideoResultViewController.h"
#import "SCPhotoResultViewController.h"

#import "SCCameraViewController.h"

@interface SCCameraViewController () <
    SCCapturingButtonDelegate,
    SCFilterBarViewDelegate,
    SCCameraTopViewDelegate,
    SCCapturingModeSwitchViewDelegate,
    UIGestureRecognizerDelegate>

@property (nonatomic, strong) GPUImageView *cameraView;

@property (nonatomic, strong) SCCapturingButton *capturingButton;
@property (nonatomic, strong) SCFilterBarView *filterBarView;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) SCCameraTopView *cameraTopView;
@property (nonatomic, strong) SCCapturingModeSwitchView *modeSwitchView;
@property (nonatomic, strong) UIView *cameraFocusView;  // 聚焦框
@property (nonatomic, strong) SCVisualEffectView *ratioBlurView;  // 切换比例的时候的模糊蒙层

@property (nonatomic, assign) BOOL isRecordingVideo;  // 是否正在录制视频
@property (nonatomic, assign) BOOL isChangingRatio;  // 是否正在改变比例

@property (nonatomic, strong) NSMutableArray <SCVideoModel *>*videos;

@property (nonatomic, assign) CGFloat currentVideoScale;  // 当前预览屏的缩放倍数，默认1

@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;

#pragma mark - UI

- (void)setupUI;

/// 设置滤镜栏显示或隐藏
- (void)setFilterBarViewHidden:(BOOL)hidden
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion;

/// 刷新下一步按钮的显示状态
- (void)refreshNextButton;

/// 刷新闪光灯按钮
- (void)updateFlashButtonWithFlashMode:(SCCameraFlashMode)mode;

/// 显示聚焦框
- (void)showFocusViewAtLocation:(CGPoint)location;

/// 修改控件的比例
- (void)changeViewToRatio:(SCCameraRatio)ratio
                 animated:(BOOL)animated
               completion:(void (^)(void))completion;

#pragma mark - Action

- (void)filterAction:(id)sender;

#pragma mark - Filter

/// 添加美颜滤镜
- (void)addBeautifyFilter;

/// 移除美颜滤镜
- (void)removeBeautifyFilter;

#pragma mark - TakePhoto

- (void)takePhoto;

#pragma mark - RecordVideo

- (void)startRecordVideo;

- (void)stopRecordVideo;

#pragma mark - Forward

/**
 跳转到图片拍后
 */
- (void)forwardToPhotoResultWith:(UIImage *)image;

/**
 跳转到视频拍后
 */
- (void)forwardToVideoResult;

@end
