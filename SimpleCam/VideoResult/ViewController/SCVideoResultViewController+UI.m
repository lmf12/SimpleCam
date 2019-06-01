//
//  SCVideoResultViewController+UI.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCVideoResultViewController+Private.h"
#import "SCVideoResultViewController+UI.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCVideoResultViewController (UI)

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPlayerContainerView];
    [self setupConfirmButton];
    [self setupBackButton];
    
    [self.view layoutIfNeeded];
}

- (void)setupPlayerContainerView {
    self.playerContainerView = [[UIView alloc] init];
    [self.view addSubview:self.playerContainerView];
    
    SCCameraRatio ratio = [SCCameraManager shareManager].ratio;
    CGFloat cameraHeight = [self cameraViewHeightWithRatio:ratio];
    BOOL isIPhoneX = [UIDevice is_iPhoneX_Series];
    [self.playerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)setupConfirmButton {
    self.confirmButton = [[UIButton alloc] init];
    [self.confirmButton setImage:[UIImage imageNamed:@"btn_confirm"]
                        forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        }
    }];
}

- (void)setupBackButton {
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"btn_back"]
                     forState:UIControlStateNormal];
    [self.backButton setDefaultShadow];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    UIView *layoutGuide = [[UIView alloc] init];
    layoutGuide.userInteractionEnabled = NO;
    [self.view addSubview:layoutGuide];
    [layoutGuide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.confirmButton.mas_left);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(self.confirmButton);
        make.centerX.equalTo(layoutGuide);
    }];
}

#pragma mark - Private
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

@end

#pragma clang diagnostic pop
