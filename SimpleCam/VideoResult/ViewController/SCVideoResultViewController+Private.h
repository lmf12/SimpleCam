//
//  SCVideoResultViewController+Private.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

#import "SCVideoResultViewController.h"

@interface SCVideoResultViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *backButton;

#pragma mark - Action

- (void)confirmAction:(id)sender;

- (void)backAction:(id)sender;

#pragma mark - UI

- (void)setupUI;

@end
