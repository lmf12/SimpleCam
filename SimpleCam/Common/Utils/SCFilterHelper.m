//
//  SCFilterHelper.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterHelper.h"

@implementation SCFilterHelper

+ (UIImage *)imageWithFilter:(GPUImageFilter *)filter
                 originImage:(UIImage *)originImage {
    [filter forceProcessingAtSize:originImage.size];
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:originImage];
    [picture addTarget:filter];
    
    [picture processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}


@end
