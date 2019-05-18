//
//  SCVideoResultViewController.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCVideoResultViewController+Private.h"
#import "SCVideoResultViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation SCVideoResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self playVideo];
    });
}

#pragma mark - Private

- (void)commonInit {
    [self setupUI];
}

- (void)playVideo {
    NSString *path = [self.videos firstObject].filePath;
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    self.player = [AVPlayer playerWithURL:videoURL];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.playerContainerView.bounds;
    [self.playerContainerView.layer addSublayer:self.playerLayer];
    [self.player play];
}

- (void)stopVideo {
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    self.player = nil;
}

- (void)backToCamera {
    [self.navigationController popViewControllerAnimated:NO];
}

// 保存视频
- (void)saveVideo:(NSString *)path completion:(void (^)(BOOL success))completion {
    NSURL *url = [NSURL fileURLWithPath:path];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (completion) {
            completion(success);
        }
    }];
}

#pragma mark - Action

- (void)confirmAction:(id)sender {
    NSString *path = [self.videos firstObject].filePath;
    @weakify(self);
    [self saveVideo:path completion:^(BOOL success) {
        @strongify(self);
        if (success) {
            NSLog(@"保存成功");
        }
    }];
}

- (void)backAction:(id)sender {
    [self backToCamera];
}

#pragma clang diagnostic pop

@end
