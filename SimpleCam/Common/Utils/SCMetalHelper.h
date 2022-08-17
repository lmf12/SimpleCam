//
//  SCMetalHelper.h
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/13.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface SCMetalHelper : NSObject

+ (id<MTLTexture>)resizeTexture:(id<MTLTexture>)texture
                   commandQueue:(id<MTLCommandQueue>)commandQueue
                       dstWidth:(NSInteger)dstWidth
                      dstHeight:(NSInteger)dstHeight;

+ (id<MTLTexture>)createTextureWithWidth:(NSInteger)width
                                  height:(NSInteger)height;

@end
