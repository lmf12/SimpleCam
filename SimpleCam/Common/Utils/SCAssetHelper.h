//
//  SCAssetHelper.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/25.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAssetHelper : NSObject

/// 获取视频的第一帧
+ (UIImage *)videoPreviewImageWithURL:(NSURL *)url;

@end
