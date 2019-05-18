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
}

- (void)setupRotateButton {
    self.rotateButton = [[UIButton alloc] init];
    [self addSubview:self.rotateButton];
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.rotateButton addTarget:self
                          action:@selector(rotateAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.rotateButton setImage:[UIImage imageNamed:@"btn_rotato"]
                       forState:UIControlStateNormal];
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

@end
