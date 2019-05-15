//
//  SCCameraTopView.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/15.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraTopView.h"

@interface SCCameraTopView ()

@property (nonatomic, strong) UIButton *rotateButton;  // 切换前后置按钮

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
}

- (void)setupRotateButton {
    self.rotateButton = [[UIButton alloc] init];
    [self addSubview:self.rotateButton];
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.rotateButton addTarget:self
                          action:@selector(rotateAction:)
                forControlEvents:UIControlEventTouchUpInside];
    self.rotateButton.backgroundColor = [UIColor blueColor];
}

#pragma mark - Action

- (void)rotateAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cameraTopViewDidClickRotateButton:)]) {
        [self.delegate cameraTopViewDidClickRotateButton:self];
    }
}

@end
