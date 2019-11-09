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

 uniform float horizontal;
 uniform float vertical;
 
 void main (void) {
    // 限制最小分割
    float horizontalCount = max(horizontal, 1.0);
    float verticalCount = max(vertical, 1.0);
    // 长宽比
    float ratio = verticalCount / horizontalCount;
    
    vec2 originSize = vec2(1.0, 1.0);
    vec2 newSize = originSize;
    
    if (ratio > 1.0) { // 竖直方向的分割数比较多，说明竖直方向需要裁剪
        newSize.y = 1.0 / ratio;
    } else {  // 水平方向的分割数比较多，说明水平方向需要裁剪
        newSize.x = ratio;
    }
    
    vec2 offset = (originSize - newSize) / 2.0;
    vec2 position = offset + mod(textureCoordinate * min(horizontalCount, verticalCount), newSize);
    
    gl_FragColor = texture2D(inputImageTexture, position);
 }
);

@implementation SCGPUImageStaticSplitFilter

- (id)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageStaticSplitFilterShaderString];
    return self;
}

@end
