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
    [self setupData];
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

- (void)setupData {
    self.videos = [[NSMutableArray alloc] init];
}

- (void)forwardToPhotoResultWith:(UIImage *)image {
    SCPhotoResultViewController *resultVC = [[SCPhotoResultViewController alloc] init];
    resultVC.resultImage = image;
    [self.navigationController pushViewController:resultVC animated:NO];
}

- (void)forwardToVideoResult {
    SCVideoResultViewController *vc = [[SCVideoResultViewController alloc] init];
    vc.videos = self.videos;
    [self.videos removeAllObjects];
    [self.navigationController pushViewController:vc animated:NO];
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

- (void)nextAction:(id)sender {
    [self forwardToVideoResult];
    [self refreshNextButton];
    [self.modeSwitchView setHidden:NO animated:NO completion:NULL];
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    [self setFilterBarViewHidden:YES
                        animated:YES
                      completion:NULL];
}

#pragma mark - SCCapturingButtonDelegate

- (void)capturingButtonDidClicked:(SCCapturingButton *)button {
    if (self.modeSwitchView.type == SCCapturingModeSwitchTypeImage) {
        [self takePhoto];
    } else if (self.modeSwitchView.type == SCCapturingModeSwitchTypeVideo) {
        if (self.isRecordingVideo) {
            [self stopRecordVideo];
        } else {
            [self startRecordVideo];
        }
    }
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SCCameraManager shareManager] rotateCamera];
    });
}

#pragma mark - SCCapturingModeSwitchViewDelegate

- (void)capturingModeSwitchView:(SCCapturingModeSwitchView *)view
                didChangeToType:(SCCapturingModeSwitchType)type {
}

@end

#pragma clang diagnostic pop
