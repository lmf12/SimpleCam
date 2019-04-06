//
//  SCCameraViewController+Private.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <GPUImage.h>
#import "SCCapturingButton.h"

#import "SCCameraManager.h"

#import "SCCameraViewController.h"

@interface SCCameraViewController () <SCCapturingButtonDelegate>

@property (nonatomic, strong) GPUImageView *cameraView;

@property (nonatomic, strong) SCCapturingButton *capturingButton;

#pragma mark - UI

- (void)setupCameraView;
- (void)setupCapturingButton;

#pragma mark - TakePhoto

- (void)takePhoto;

@end
