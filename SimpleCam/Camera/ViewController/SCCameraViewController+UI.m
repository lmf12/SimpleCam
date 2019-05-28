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
    [self setupCameraView];
    [self setupCapturingButton];
    [self setupFilterButton];
    [self setupNextButton];
    [self setupCameraTopView];
    [self setupModeSwitchView];
    [self setupCameraFocusView];
}

- (void)setupCameraView {
    self.cameraView = [[GPUImageView alloc] init];
    [self.view addSubview:self.cameraView];
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height);
    }];
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
    [self.filterButton setImage:[UIImage imageNamed:@"btn_filter"]
                       forState:UIControlStateNormal];
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
    [self.nextButton setImage:[UIImage imageNamed:@"btn_next"]
                     forState:UIControlStateNormal];
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
    
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            updateBlock();
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.filterBarView.showing = !hidden;
            if (completion) {
                completion();
            }
        }];
    } else {
        updateBlock();
        self.filterBarView.showing = !hidden;
        if (completion) {
            completion();
        }
    }
}

- (void)refreshNextButton {
    [self.nextButton setHidden:self.videos.count == 0 || self.isRecordingVideo
                      animated:YES
                    completion:NULL];
}

- (void)updateFlashButtonWithFlashMode:(SCCameraFlashMode)mode {
    switch (mode) {
        case SCCameraFlashModeOff:
            [self.cameraTopView.flashButton setImage:[UIImage imageNamed:@"btn_flash_off"]
                                            forState:UIControlStateNormal];
            break;
        case SCCameraFlashModeOn:
            [self.cameraTopView.flashButton setImage:[UIImage imageNamed:@"btn_flash_on"]
                                            forState:UIControlStateNormal];
            break;
        case SCCameraFlashModeAuto:
            [self.cameraTopView.flashButton setImage:[UIImage imageNamed:@"btn_flash_auto"]
                                            forState:UIControlStateNormal];
            break;
        case SCCameraFlashModeTorch:
            [self.cameraTopView.flashButton setImage:[UIImage imageNamed:@"btn_flash_torch"]
                                            forState:UIControlStateNormal];
            break;
        default:
            break;
    }
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

@end

#pragma clang diagnostic pop
