//
//  SCMetalHelper.m
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/13.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <tnn/tnn.h>
#import <MetalKit/MetalKit.h>
#import "SCMetalHelper.h"

using namespace std;
using namespace TNN_NS;

@implementation SCMetalHelper

+ (id<MTLTexture>)resizeTexture:(id<MTLTexture>)texture
                   commandQueue:(id<MTLCommandQueue>)commandQueue
                       dstWidth:(NSInteger)dstWidth
                      dstHeight:(NSInteger)dstHeight {
    Mat srcMat = {DEVICE_METAL, tnn::N8UC4, {1, 3, (int)texture.height, (int)texture.width}, (__bridge void*)texture};
    Mat dstMat = {DEVICE_METAL, tnn::N8UC4};
    ResizeParam param = {(float)dstWidth / texture.width,
        (float)dstHeight / texture.height};
    MatUtils::Resize(srcMat, dstMat, param, (__bridge void*)commandQueue);
    return (__bridge id<MTLTexture>)dstMat.GetData();
}

+ (id<MTLTexture>)createTextureWithWidth:(NSInteger)width height:(NSInteger)height {
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
    textureDescriptor.usage = MTLTextureUsageShaderRead | MTLTextureUsageShaderWrite | MTLTextureUsageRenderTarget;
    textureDescriptor.width = width;
    textureDescriptor.height = height;
    id<MTLTexture> texture = [MTLCreateSystemDefaultDevice() newTextureWithDescriptor:textureDescriptor];
    
    return texture;
}

@end
