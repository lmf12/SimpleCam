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

#import "SCCameraManager.h"
#import "SCFilterManager.h"

#import "SCVideoModel.h"

#import "UIView+Extention.h"

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

@property (nonatomic, assign) BOOL isRecordingVideo;  // 是否正在录制视频
@property (nonatomic, strong) NSMutableArray <SCVideoModel *>*videos;

@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *currentFilters;

@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;

#pragma mark - UI

- (void)setupUI;

/// 设置滤镜栏显示或隐藏
- (void)setFilterBarViewHidden:(BOOL)hidden
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion;

/// 刷新下一步按钮的显示状态
- (void)refreshNextButton;

#pragma mark - Action

- (void)filterAction:(id)sender;

#pragma mark - Filter

- (void)setupFilters;

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
