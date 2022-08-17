//
//  GPUImageFramebuffer+Extention.m
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/13.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import <objc/runtime.h>

#import "GPUImageFramebuffer+Extention.h"

@implementation GPUImageFramebuffer (Extention)

- (CVPixelBufferRef)renderTarget {
    Ivar ivar = class_getInstanceVariable([self class], "renderTarget");
    CVPixelBufferRef renderTarget = (__bridge CVPixelBufferRef)object_getIvar(self, ivar);
    return renderTarget;
}

@end
