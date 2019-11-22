//
//  SCPhotoResultViewController.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <Photos/Photos.h>

#import "SCPhotoResultViewController+Private.h"

#import "SCPhotoResultViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation SCPhotoResultViewController

- (void)dealloc {
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    self.contentImageView.image = self.resultImage;
}

#pragma mark - Private

- (void)commonInit {
    [self setupUI];
}

- (void)backToCamera {
    [self.navigationController popViewControllerAnimated:NO];
}

// 保存图片到相册
- (void)writeImageToSavedPhotosAlbum:(UIImage *)image
                          completion:(void (^)(BOOL success))completion {
    void (^saveBlock)(void) = ^ {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (completion) {
                completion(success);
            }
        }];
    };
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                saveBlock();
            } else {
                if (completion) {
                    completion(NO);
                }
            }
        }];
    } else if (authStatus != PHAuthorizationStatusAuthorized) {
        if (completion) {
            completion(NO);
        }
    } else {
        saveBlock();
    }
}

#pragma mark - Action

- (void)confirmAction:(id)sender {
    @weakify(self);
    [self writeImageToSavedPhotosAlbum:self.resultImage completion:^(BOOL success) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self backToCamera];
                [self.view.window makeToast:@"保存成功"];
            } else {
                [self.view.window makeToast:@"保存失败"];
            }
        });
    }];
}

- (void)backAction:(id)sender {
    [self backToCamera];
}

@end

#pragma clang diagnostic pop
