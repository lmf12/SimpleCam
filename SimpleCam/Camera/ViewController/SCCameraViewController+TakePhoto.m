//
//  SCCameraViewController+TakePhoto.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraViewController+Private.h"

#import "SCCameraViewController+TakePhoto.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (TakePhoto)

- (void)takePhoto {
    [[SCCameraManager shareManager] takePhotoWtihFilters:nil
                                              completion:^(UIImage *resultImage, NSError *error) {
        
    }];
}

@end

#pragma clang diagnostic pop
