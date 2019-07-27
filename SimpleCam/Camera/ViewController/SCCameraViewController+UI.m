//
//  SCCameraViewController+UI.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraViewController+Private.h"

#import "SCCameraViewController+UI.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma clang diagnostic ignored "-Wundeclared-selector"

static CGFloat const kFilterBarViewHeight = 200.0f;  // 滤镜栏高度

@implementation SCCameraViewController (UI)

#pragma mark - Setup

- (void)setupUI {
    [self setupToast];
    
    [self setupCameraView];
    [self setupCapturingButton];
    [self setupFilterButton];
    [self setupNextButton];
    [self setupCameraTopView];
    [self setupModeSwitchView];
    [self setupCameraFocusView];
    [self setupRatioBlurView];
    [self setupVideoTimeLabel];
}

- (void)setupCameraView {
    self.cameraView = [[GPUImageView alloc] init];
    [self.view addSubview:self.cameraView];
    [self refreshCameraViewWithRatio:[SCCameraManager shareManager].ratio];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraViewTapAction:)];
    [self.cameraView addGestureRecognizer:tap];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(cameraViewPinchAction:)];
    [self.cameraView addGestureRecognizer:pinch];
}

- (void)setupCapturingButton {
    self.capturingButton = [[SCCapturingButton alloc] init];
    self.capturingButton.delegate = self;
    [self.view addSubview:self.capturingButton];
    [self.capturingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        }
    }];
}

- (void)setupFilterButton {
    self.filterButton = [[UIButton alloc] init];
    [self.filterButton setEnableDarkWithImageName:@"btn_filter"];
    [self.filterButton addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.filterButton];
    
    UIView *layoutGuide = [[UIView alloc] init];
    layoutGuide.userInteractionEnabled = NO;
    [self.view addSubview:layoutGuide];
    [layoutGuide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.capturingButton.mas_left);
    }];
    
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(self.capturingButton);
        make.centerX.equalTo(layoutGuide);
    }];
}

- (void)setupNextButton {
    self.nextButton = [[UIButton alloc] init];
    self.nextButton.alpha = 0;
    [self.nextButton setEnableDarkWithImageName:@"btn_next"];
    [self.nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    UIView *layoutGuide = [[UIView alloc] init];
    layoutGuide.userInteractionEnabled = NO;
    [self.view addSubview:layoutGuide];
    [layoutGuide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.capturingButton.mas_right);
        make.right.equalTo(self.view);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(self.capturingButton);
        make.centerX.equalTo(layoutGuide);
    }];
}

- (void)setupFilterBarView {
    self.filterBarView = [[SCFilterBarView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0)];
    self.filterBarView.delegate = self;
    self.filterBarView.showing = NO;
    [self.view addSubview:self.filterBarView];
    [self.filterBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    [self.filterBarView layoutIfNeeded];
}

- (void)setupCameraTopView {
    self.cameraTopView = [[SCCameraTopView alloc] init];
    self.cameraTopView.delegate = self;
    [self.view addSubview:self.cameraTopView];
    [self.cameraTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.view.mas_top);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
}

- (void)setupModeSwitchView {
    self.modeSwitchView = [[SCCapturingModeSwitchView alloc] init];
    self.modeSwitchView.delegate = self;
    [self.view addSubview:self.modeSwitchView];
    [self.modeSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.capturingButton);
        make.top.equalTo(self.capturingButton.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

- (void)setupCameraFocusView {
    self.cameraFocusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.cameraFocusView.alpha = 0;
    [self.cameraView addSubview:self.cameraFocusView];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.cameraFocusView.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.cameraFocusView.bounds];
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = path.CGPath;
    [self.cameraFocusView.layer addSublayer:layer];
}

- (void)setupRatioBlurView {
    self.ratioBlurView = [[SCVisualEffectView alloc] init];
    self.ratioBlurView.blurRadius = 50;
    self.ratioBlurView.hidden = YES;
    [self.view insertSubview:self.ratioBlurView aboveSubview:self.cameraView];
    [self.ratioBlurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.cameraView);
    }];
}

- (void)setupVideoTimeLabel {
    self.videoTimeLabel = [[SCCameraVideoTimeLabel alloc] init];
    self.videoTimeLabel.alpha = 0;
    [self.view addSubview:self.videoTimeLabel];
    [self.videoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.modeSwitchView);
    }];
}

- (void)setupToast {
    [CSToastManager setDefaultPosition:CSToastPositionCenter];
    [CSToastManager setDefaultDuration:1];
}

#pragma mark - Update

- (void)setFilterBarViewHidden:(BOOL)hidden
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion {
    if (!hidden && self.filterBarView == nil) {
        [self setupFilterBarView];
    }
    
    void (^updateBlock)(void) = ^ {
        [self.filterBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            if (hidden) {
                make.top.mas_equalTo(self.view.mas_bottom).offset(0);
            } else {
                if (@available(iOS 11.0, *)) {
                    make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-kFilterBarViewHeight);
                } else {
                    make.top.mas_equalTo(self.view.mas_bottom).offset(-kFilterBarViewHeight);
                }
            }
        }];
    };
    
    self.filterBarView.showing = !hidden;
    
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            updateBlock();
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    } else {
        updateBlock();
        if (completion) {
            completion();
        }
    }
}

- (void)refreshUIWhenRecordVideo {
    [self refreshCloseButton];
    [self refreshFlashButton];
    [self refreshRatioButton];
    [self refreshRotateButton];
    [self refreshSettingButton];
    [self refreshNextButton];
    [self refreshModeSwitchView];
    [self refreshVideoTimeLabel];
}

- (void)refreshUIWhenFilterBarShowOrHide {
    [self refreshCapturingButton];
    [self refreshModeSwitchView];
    [self refreshFilterButton];
    [self refreshNextButton];
    [self refreshVideoTimeLabel];
}

- (void)updateFlashButtonWithFlashMode:(SCCameraFlashMode)mode {
    switch (mode) {
        case SCCameraFlashModeOff:
            [self.cameraTopView.flashButton setEnableDarkWithImageName:@"btn_flash_off"];
            break;
        case SCCameraFlashModeOn:
            [self.cameraTopView.flashButton setEnableDarkWithImageName:@"btn_flash_on"];
            break;
        case SCCameraFlashModeAuto:
            [self.cameraTopView.flashButton setEnableDarkWithImageName:@"btn_flash_auto"];
            break;
        case SCCameraFlashModeTorch:
            [self.cameraTopView.flashButton setEnableDarkWithImageName:@"btn_flash_torch"];
            break;
        default:
            break;
    }
}

- (void)updateRatioButtonWithRatio:(SCCameraRatio)ratio {
    switch (ratio) {
        case SCCameraRatio1v1:
            [self.cameraTopView.ratioButton setEnableDarkWithImageName:@"btn_ratio_1v1"];
            break;
        case SCCameraRatio4v3:
            [self.cameraTopView.ratioButton setEnableDarkWithImageName:@"btn_ratio_3v4"];
            break;
        case SCCameraRatio16v9:
            [self.cameraTopView.ratioButton setEnableDarkWithImageName:@"btn_ratio_9v16"];
            break;
        case SCCameraRatioFull:
            [self.cameraTopView.ratioButton setEnableDarkWithImageName:@"btn_ratio_full"];
            break;
        default:
            break;
    }
}

- (void)updateDarkOrNormalModeWithRatio:(SCCameraRatio)ratio {
    BOOL isIphoneX = [UIDevice is_iPhoneX_Series];
    BOOL isTopBarDark = ratio == SCCameraRatio1v1 ||
                        (isIphoneX && ratio != SCCameraRatioFull);
    [self.cameraTopView.flashButton setIsDarkMode:isTopBarDark];
    [self.cameraTopView.ratioButton setIsDarkMode:isTopBarDark];
    [self.cameraTopView.rotateButton setIsDarkMode:isTopBarDark];
    [self.cameraTopView.closeButton setIsDarkMode:isTopBarDark];
    [self.cameraTopView.settingButton setIsDarkMode:isTopBarDark];
    
    BOOL isBottomBarDark = ratio == SCCameraRatio1v1 || ratio == SCCameraRatio4v3;
    [self.filterButton setIsDarkMode:isBottomBarDark];
    [self.nextButton setIsDarkMode:isBottomBarDark];
    [self.modeSwitchView setIsDarkMode:isBottomBarDark];
    [self.videoTimeLabel setIsDarkMode:isBottomBarDark];
}

- (void)showFocusViewAtLocation:(CGPoint)location {
    self.cameraFocusView.center = location;
    self.cameraFocusView.transform = CGAffineTransformMakeScale(1.6, 1.6);
    [self.cameraFocusView setHidden:NO animated:YES completion:NULL];
    [UIView animateWithDuration:0.15 animations:^{
        self.cameraFocusView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.2 delay:0.8 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            self.cameraFocusView.alpha = 0;
        } completion:NULL];
    }];
}

- (void)changeViewToRatio:(SCCameraRatio)ratio
                 animated:(BOOL)animated
               completion:(void (^)(void))completion {
    SCCameraManager *manager = [SCCameraManager shareManager];
    if (manager.ratio == ratio) {
        if (completion) {
            completion();
            return;
        }
        return;
    }
    
    void (^block)(void) = ^ {
        [self refreshCameraViewWithRatio:ratio];
    };
    
    if (!animated) {
        block();
        if (completion) {
            completion();
        }
        return;
    }
    
    self.ratioBlurView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        block();
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.ratioBlurView.hidden = YES;
            self.isChangingRatio = NO;
        });
        if (completion) {
            completion();
        }
    }];
}


#pragma mark - Private

/// 刷新下一步按钮
- (void)refreshNextButton {
    BOOL hidden = self.videos.count == 0 ||
                  self.isRecordingVideo ||
                  self.filterBarView.showing;
    [self.nextButton setHidden:hidden
                      animated:YES
                    completion:NULL];
}

/// 刷新闪光灯按钮
- (void)refreshFlashButton {
    BOOL hidden = self.videos.count > 0 || self.isRecordingVideo;
    [self.cameraTopView.flashButton setHidden:hidden
                                     animated:YES
                                   completion:NULL];
}

/// 刷新比例按钮
- (void)refreshRatioButton {
    BOOL hidden = self.videos.count > 0 || self.isRecordingVideo;
    [self.cameraTopView.ratioButton setHidden:hidden
                                     animated:YES
                                   completion:NULL];
}

/// 刷新旋转按钮
- (void)refreshRotateButton {
    BOOL hidden = self.videos.count > 0 || self.isRecordingVideo;
    [self.cameraTopView.rotateButton setHidden:hidden
                                      animated:YES
                                    completion:NULL];
}

/// 刷新设置
- (void)refreshSettingButton {
    BOOL hidden = self.videos.count > 0 || self.isRecordingVideo;
    [self.cameraTopView.settingButton setHidden:hidden
                                       animated:YES
                                     completion:NULL];
}

/// 刷新关闭按钮
- (void)refreshCloseButton {
    BOOL hidden = self.videos.count == 0 || self.isRecordingVideo;
    [self.cameraTopView.closeButton setHidden:hidden
                                     animated:YES
                                   completion:NULL];
}

/// 刷新模式切换控件
- (void)refreshModeSwitchView {
    BOOL hidden = self.videos.count > 0 ||
                  self.isRecordingVideo ||
                  self.filterBarView.showing;
    [self.modeSwitchView setHidden:hidden
                          animated:YES
                        completion:NULL];
}

/// 刷新拍照按钮
- (void)refreshCapturingButton {
    [self.capturingButton setHidden:self.filterBarView.showing
                           animated:YES
                         completion:NULL];
}

/// 刷新滤镜按钮
- (void)refreshFilterButton {
    [self.filterButton setHidden:self.filterBarView.showing
                        animated:YES
                      completion:NULL];
}

/// 刷新视频时间控件
- (void)refreshVideoTimeLabel {
    BOOL hidden = (self.videos.count == 0 &&
                  !self.isRecordingVideo) ||
                  self.filterBarView.showing;
    [self.videoTimeLabel setHidden:hidden
                          animated:YES
                        completion:NULL];
}

/// 通过比例，获取相机预览界面的高度
- (CGFloat)cameraViewHeightWithRatio:(SCCameraRatio)ratio {
    CGFloat videoWidth = SCREEN_WIDTH;
    CGFloat height = 0;
    switch (ratio) {
        case SCCameraRatio1v1:
            height = videoWidth;
            break;
        case SCCameraRatio4v3:
            height = videoWidth / 3.0 * 4.0;
            break;
        case SCCameraRatio16v9:
            height = videoWidth / 9.0 * 16.0;
            break;
        case SCCameraRatioFull:
            height = SCREEN_HEIGHT;
            break;
        default:
            break;
    }
    return height;
}

/// 通过比例，对相机预览控件重新布局
- (void)refreshCameraViewWithRatio:(SCCameraRatio)ratio {
    CGFloat cameraHeight = [self cameraViewHeightWithRatio:ratio];
    BOOL isIPhoneX = [UIDevice is_iPhoneX_Series];
    [self.cameraView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (ratio == SCCameraRatioFull) {
            make.top.mas_equalTo(self.view);
        } else {
            CGFloat topOffset = isIPhoneX || ratio == SCCameraRatio1v1 ? 60 : 0;
            if (@available(iOS 11.0, *)) {
                make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(topOffset);
            } else {
                make.top.mas_equalTo(self.view.mas_top).offset(topOffset);
            }
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(cameraHeight);
    }];
}

@end

#pragma clang diagnostic pop
