//
//  SCCameraViewController+TakePhoto.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraViewController+Private.h"

#import "SCPhotoResultViewController.h"

#import "SCCameraViewController+TakePhoto.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (TakePhoto)

- (void)takePhoto {
    @weakify(self);
    [[SCCameraManager shareManager] takePhotoWtihFilters:self.currentFilters completion:^(UIImage *resultImage, NSError *error) {
        @strongify(self);
        SCPhotoResultViewController *resultVC = [[SCPhotoResultViewController alloc] init];
        resultVC.resultImage = resultImage;
        [self.navigationController pushViewController:resultVC animated:NO];
    }];
}

@end

#pragma clang diagnostic pop
