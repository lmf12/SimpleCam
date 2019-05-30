//
//  SCCapturingButton.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCapturingButton.h"

@interface SCCapturingButton ()

@property (nonatomic, strong) UIView *recordStopView;  // 录制视频暂停控件

@end

@implementation SCCapturingButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

#pragma mark - Private

- (void)commonInit {
    self.capturingState = SCCapturingButtonStateNormal;
    [self setupUI];
    [self addActions];
}

- (void)setupUI {
    [self setImage:[UIImage imageNamed:@"btn_capture"]
          forState:UIControlStateNormal];
    [self setupRecordStopView];
}

- (void)setupRecordStopView {
    self.recordStopView = [[UIView alloc] init];
    self.recordStopView.userInteractionEnabled = NO;
    self.recordStopView.alpha = 0;
    self.recordStopView.layer.cornerRadius = 5;
    self.recordStopView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.recordStopView];
    [self.recordStopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)addActions {
    [self addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Custom Accessor

- (void)setCapturingState:(SCCapturingButtonState)capturingState {
    _capturingState = capturingState;
    
    [self.recordStopView setHidden:capturingState == SCCapturingButtonStateNormal
                          animated:YES
                        completion:NULL];
}

#pragma mark - Actions

- (void)touchUpInsideAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(capturingButtonDidClicked:)]) {
        [self.delegate capturingButtonDidClicked:self];
    }
}

@end
