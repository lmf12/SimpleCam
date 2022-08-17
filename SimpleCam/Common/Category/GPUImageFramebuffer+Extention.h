//
//  GPUImageFramebuffer+Extention.h
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/13.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import "GPUImageFramebuffer.h"

@interface GPUImageFramebuffer (Extention)

- (CVPixelBufferRef)renderTarget;

@end
