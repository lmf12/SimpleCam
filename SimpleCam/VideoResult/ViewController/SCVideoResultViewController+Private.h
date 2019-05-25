//
//  SCVideoResultViewController+Private.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage.h>

#import "SCAssetHelper.h"
#import "SCFileHelper.h"

#import "SCVideoResultViewController.h"

@interface SCVideoResultViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) CALayer *lastPlayerLayer; // 为了避免两段切换的时候出现短暂白屏

@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, assign) NSInteger currentVideoIndex;

#pragma mark - Action

- (void)confirmAction:(id)sender;

- (void)backAction:(id)sender;

#pragma mark - UI

- (void)setupUI;

@end
