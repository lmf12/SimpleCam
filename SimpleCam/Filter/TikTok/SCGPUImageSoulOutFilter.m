//
//  SCGPUImageSoulOutFilter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/2.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCGPUImageSoulOutFilter.h"

NSString * const kSCGPUImageSoulOutFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;
 
 void main (void) {
     float duration = 0.7;
     float maxAlpha = 0.7;
     float maxScale = 2.0;
     
     float progress = mod(time, duration) / duration;
     float alpha = maxAlpha * (1.0 - progress);
     float scale = 1.0 + (maxScale - 1.0) * progress;
     
     float weakX = 0.5 + (textureCoordinate.x - 0.5) / scale;
     float weakY = 0.5 + (textureCoordinate.y - 0.5) / scale;
     vec2 weakTextureCoords = vec2(weakX, weakY);
     
     vec4 weakMask = texture2D(inputImageTexture, weakTextureCoords);
     
     vec4 mask = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = mask * (1.0 - alpha) + weakMask * alpha;
 }
);

@implementation SCGPUImageSoulOutFilter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageSoulOutFilterShaderString];
    return self;
}

@end
