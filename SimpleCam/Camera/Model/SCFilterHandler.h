//
//  SCFilterHandler.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/25.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <GPUImage.h>

#import <Foundation/Foundation.h>

@interface SCFilterHandler : NSObject

// 滤镜链源头
@property (nonatomic, weak) GPUImageOutput *source;

/// 滤镜链第一个滤镜
- (GPUImageFilter *)firstFilter;

/// 滤镜链最后一个滤镜
- (GPUImageFilter *)lastFilter;

/// 设置裁剪比例，用于设置特殊的相机比例
- (void)setCropRect:(CGRect)rect;

/// 往末尾添加一个滤镜
- (void)addFilter:(GPUImageFilter *)filter;

/// 设置美颜滤镜
- (void)setBeautifyFilter:(GPUImageFilter *)filter;

/// 设置效果滤镜
- (void)setEffectFilter:(GPUImageFilter *)filter;

@end
