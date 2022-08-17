//
//  SCAIManager.h
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/7.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAIManager : NSObject

+ (instancetype)shareManager;

// 获取头发分割 mask 图
- (CVPixelBufferRef)hairSegmentationPixelBufferWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (void)hairSegmentationWithSrcPixelBuffer:(CVPixelBufferRef)srcPixelBuffer
                                dstTexture:(id<MTLTexture>)dstTexture;

@end
