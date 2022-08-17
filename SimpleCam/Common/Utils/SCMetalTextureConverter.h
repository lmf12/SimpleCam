//
//  SCMetalTextureConverter.h
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/8.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <Metal/Metal.h>

@interface SCMetalTextureConverter : NSObject

- (instancetype)initWithCommandQueue:(id<MTLCommandQueue>)queue;

/// Metal 纹理转化为 PixelBuffer
- (CVPixelBufferRef)pixelBufferWithTexture:(id<MTLTexture>)texture;

/// 将纹理绘制到纹理
- (void)drawSrcTexture:(id<MTLTexture>)srcTexture toDstTexture:(id<MTLTexture>)dstTexture;

/// PixelBuffer 转化为 Metal 纹理
- (id<MTLTexture>)textureWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end
