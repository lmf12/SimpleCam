//
//  SCAssetHelper.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/25.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

#import "SCAssetHelper.h"

@implementation SCAssetHelper

+ (UIImage *)videoPreviewImageWithURL:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time
                                                 actualTime:nil
                                                      error:&error];
    if (error) {
        NSAssert(NO, error.description);
    }
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return videoImage;
}


@end
