//
//  SCFilterHelper.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <GPUImage.h>
#import <Foundation/Foundation.h>

@interface SCFilterHelper : NSObject

/**
 给图片上滤镜效果

 @param filter 滤镜
 @param originImage 原图
 @return 效果图
 */
+ (UIImage *)imageWithFilter:(GPUImageFilter *)filter
                 originImage:(UIImage *)originImage;

@end
