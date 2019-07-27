//
//  SCCameraTopView.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/15.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraTopView.h"

@interface SCCameraTopView ()

@property (nonatomic, strong, readwrite) UIButton *rotateButton;
@property (nonatomic, strong, readwrite) UIButton *flashButton;
@property (nonatomic, strong, readwrite) UIButton *ratioButton;
@property (nonatomic, strong, readwrite) UIButton *closeButton;
@property (nonatomic, strong, readwrite) UIButton *settingButton;

@property (nonatomic, assign) BOOL isRotating;  // 正在旋转中

@end

@implementation SCCameraTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private

- (void)commonInit {
    [self setupRotateButton];
    [self setupFlashButton];
    [self setupRatioButton];
    [self setupCloseButton];
    [self setupSettingButton];
}

- (void)setupRotateButton {
    self.rotateButton = [[UIButton alloc] init];
    [self addSubview:self.rotateButton];
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).multipliedBy(1.75);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.rotateButton addTarget:self
                          action:@selector(rotateAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.rotateButton setEnableDarkWithImageName:@"btn_rotato"];
}

- (void)setupFlashButton {
    self.flashButton = [[UIButton alloc] init];
    [self addSubview:self.flashButton];
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).multipliedBy(0.75);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.flashButton addTarget:self
                         action:@selector(flashAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.flashButton setEnableDarkWithImageName:@"btn_flash_off"];
}

- (void)setupRatioButton {
    self.ratioButton = [[UIButton alloc] init];
    [self addSubview:self.ratioButton];
    [self.ratioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).multipliedBy(1.25);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.ratioButton addTarget:self
                         action:@selector(ratioAction:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.ratioButton setEnableDarkWithImageName:@"btn_ratio_9v16"];
}

- (void)setupCloseButton {
    self.closeButton = [[UIButton alloc] init];
    self.closeButton.alpha = 0;
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).multipliedBy(0.25);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.closeButton addTarget:self
                         action:@selector(closeAction:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setEnableDarkWithImageName:@"btn_close"];
}

- (void)setupSettingButton {
    self.settingButton = [[UIButton alloc] init];
    [self addSubview:self.settingButton];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).multipliedBy(0.25);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.settingButton addTarget:self
                           action:@selector(settingAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.settingButton setEnableDarkWithImageName:@"btn_setting"];
}

#pragma mark - Action

- (void)rotateAction:(UIButton *)button {
    if (self.isRotating) {
        return;
    }
    self.isRotating = YES;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.rotateButton.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    } completion:^(BOOL finished) {
        self.rotateButton.transform = CGAffineTransformIdentity;
        self.isRotating = NO;
    }];
    
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickRotateButton:)]) {
        [self.delegate cameraTopViewDidClickRotateButton:self];
    }
}

- (void)flashAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickFlashButton:)]) {
        [self.delegate cameraTopViewDidClickFlashButton:self];
    }
}

- (void)ratioAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickRatioButton:)]) {
        [self.delegate cameraTopViewDidClickRatioButton:self];
    }
}

- (void)closeAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickCloseButton:)]) {
        [self.delegate cameraTopViewDidClickCloseButton:self];
    }
}

- (void)settingAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickSettingButton:)]) {
        [self.delegate cameraTopViewDidClickSettingButton:self];
    }
}

@end
