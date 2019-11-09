//
//  SCGPUImageStaticSplitFilter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/11/9.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "SCGPUImageStaticSplitFilter.h"

NSString * const kSCGPUImageStaticSplitFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;

 void main (void) {
    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
 }
);

@implementation SCGPUImageStaticSplitFilter

- (id)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageStaticSplitFilterShaderString];
    return self;
}

@end
