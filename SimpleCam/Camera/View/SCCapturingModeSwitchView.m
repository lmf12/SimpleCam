//
//  SCCapturingModeSwitchView.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCapturingModeSwitchView.h"

@interface SCCapturingModeSwitchView ()

@property (nonatomic, assign, readwrite) SCCapturingModeSwitchType type;

@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) UILabel *videoLabel;

@end

@implementation SCCapturingModeSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma maek - Custom Accessor

- (void)setIsDarkMode:(BOOL)isDarkMode {
    _isDarkMode = isDarkMode;
    
    [self updateDarkMode];
}

#pragma mark - Private

- (void)commonInit {
    [self setupImageLabel];
    [self setupVideoLabel];
    [self updateDarkMode];
}

- (void)setupImageLabel {
    self.imageLabel = [[UILabel alloc] init];
    self.imageLabel.text = @"拍照";
    self.imageLabel.textAlignment = NSTextAlignmentCenter;
    self.imageLabel.userInteractionEnabled = YES;
    self.imageLabel.textColor = [UIColor whiteColor];
    self.imageLabel.font = [UIFont boldSystemFontOfSize:12];
    [self addSubview:self.imageLabel];
    [self.imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAciton)];
    [self.imageLabel addGestureRecognizer:imageTap];
}

- (void)setupVideoLabel {
    self.videoLabel = [[UILabel alloc] init];
    self.videoLabel.text = @"录制";
    self.videoLabel.textAlignment = NSTextAlignmentCenter;
    self.videoLabel.userInteractionEnabled = YES;
    self.videoLabel.textColor = RGBA(255, 255, 255, 0.6);
    self.videoLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.videoLabel];
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    
    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTapAction)];
    [self.videoLabel addGestureRecognizer:videoTap];
}

- (void)selectType:(SCCapturingModeSwitchType)type {
    if (self.type == type) {
        return;
    }
    self.type = type;
    UILabel *selectedLabel = nil;
    UILabel *normalLabel = nil;
    if (self.type == SCCapturingModeSwitchTypeImage) {
        selectedLabel = self.imageLabel;
        normalLabel = self.videoLabel;
    } else {
        selectedLabel = self.videoLabel;
        normalLabel = self.imageLabel;
    }
    selectedLabel.font = [UIFont boldSystemFontOfSize:12];
    normalLabel.font = [UIFont systemFontOfSize:12];
    
    [self updateDarkMode];
    
    [self.delegate capturingModeSwitchView:self didChangeToType:self.type];
}

- (void)updateDarkMode {
    UILabel *selectedLabel = nil;
    UILabel *normalLabel = nil;
    if (self.type == SCCapturingModeSwitchTypeImage) {
        selectedLabel = self.imageLabel;
        normalLabel = self.videoLabel;
    } else {
        selectedLabel = self.videoLabel;
        normalLabel = self.imageLabel;
    }
    selectedLabel.textColor = self.isDarkMode ? [UIColor blackColor] : [UIColor whiteColor];
    normalLabel.textColor = self.isDarkMode ? RGBA(0, 0, 0, 0.6) : RGBA(255, 255, 255, 0.6);
    
    if (self.isDarkMode) {
        [self clearShadow];
    } else {
        [self setDefaultShadow];
    }
}

#pragma mark - Action

- (void)imageTapAciton {
    [self selectType:SCCapturingModeSwitchTypeImage];
}

- (void)videoTapAction {
    [self selectType:SCCapturingModeSwitchTypeVideo];
}

@end
