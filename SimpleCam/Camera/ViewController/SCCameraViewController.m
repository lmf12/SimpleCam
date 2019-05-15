//
//  SCCameraViewController.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraViewController+Private.h"

#import "SCCameraViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation SCCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    SCCameraManager *cameraManager = [SCCameraManager shareManager];
    [cameraManager addOutputView:self.cameraView];
    [cameraManager setCameraFilters:self.currentFilters];
    [cameraManager startCapturing];
}

#pragma mark - Public

#pragma mark - Private

- (void)commonInit {
    [self setupFilters];
    [self setupUI];
    [self setupTap];
    
    self.defaultFilterMaterials = [[SCFilterManager shareManager] defaultFilters];
}

- (void)setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Action

- (void)filterAction:(id)sender {
    [self setFilterBarViewHidden:NO
                        animated:YES
                      completion:NULL];
    
    // 第一次展开的时候，添加数据
    if (!self.filterBarView.defaultFilterMaterials) {
        self.filterBarView.defaultFilterMaterials = self.defaultFilterMaterials;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    [self setFilterBarViewHidden:YES
                        animated:YES
                      completion:NULL];
}

#pragma mark - SCCapturingButtonDelegate

- (void)capturingButtonDidClicked:(SCCapturingButton *)button {
    [self takePhoto];
}

#pragma mark - SCFilterBarViewDelegate

- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index {
    SCCameraManager *cameraManager = [SCCameraManager shareManager];
    SCFilterMaterialModel *model = self.defaultFilterMaterials[index];
    self.currentFilters = [[SCFilterManager shareManager] filterWithFilterID:model.filterID];
    [cameraManager setCameraFilters:self.currentFilters];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.filterBarView]) {
        return NO;
    }
    return YES;
}

#pragma mark - SCCameraTopViewDelegate

- (void)cameraTopViewDidClickRotateButton:(SCCameraTopView *)cameraTopView {
    [[SCCameraManager shareManager] rotateCamera];
}

@end

#pragma clang diagnostic pop
