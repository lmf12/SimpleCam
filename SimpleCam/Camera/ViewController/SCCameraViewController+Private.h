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
#import "SCCameraVideoTimeLabel.h"

#import "SCCameraManager.h"
#import "SCFilterManager.h"
#import "SCFilterHandler.h"

#import "SCVideoModel.h"
#import "LFGPUImageBeautyFilter.h"

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
@property (nonatomic, strong) SCCameraVideoTimeLabel *videoTimeLabel;
@property (nonatomic, strong) UIView *cameraFocusView;  // 聚焦框
@property (nonatomic, strong) SCVisualEffectView *ratioBlurView;  // 切换比例的时候的模糊蒙层

@property (nonatomic, assign) BOOL isRecordingVideo;  // 是否正在录制视频
@property (nonatomic, assign) BOOL isChangingRatio;  // 是否正在改变比例

@property (nonatomic, strong) NSMutableArray <SCVideoModel *>*videos;

@property (nonatomic, assign) CGFloat currentVideoScale;  // 当前预览屏的缩放倍数，默认1

@property (nonatomic, strong) NSTimer *videoTimer;  // 用于刷新录制中视频的时间

@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *tikTokFilterMaterials;

#pragma mark - UI

- (void)setupUI;

/// 设置滤镜栏显示或隐藏
- (void)setFilterBarViewHidden:(BOOL)hidden
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion;

/// 在录制视频的时候，刷新UI
- (void)refreshUIWhenRecordVideo;

/// 在滤镜栏显示或隐藏的时候，刷新UI
- (void)refreshUIWhenFilterBarShowOrHide;

/// 刷新闪光灯按钮
- (void)updateFlashButtonWithFlashMode:(SCCameraFlashMode)mode;

/// 刷新比例按钮
- (void)updateRatioButtonWithRatio:(SCCameraRatio)ratio;

/// 刷新黑暗模式或正常模式
- (void)updateDarkOrNormalModeWithRatio:(SCCameraRatio)ratio;

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

/// 根据分类索引，获取滤镜列表
- (NSArray<SCFilterMaterialModel *> *)filtersWithCategoryIndex:(NSInteger)index;

#pragma mark - TakePhoto

- (void)takePhoto;

#pragma mark - RecordVideo

- (void)startRecordVideo;

- (void)stopRecordVideo;

- (void)startVideoTimer;

- (void)endVideoTimer;

#pragma mark - Notification

/**
 添加监听
 */
- (void)addObserver;

/**
 移除监听
 */
- (void)removeObserver;

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
