//
//  SCGPUImageGlitchFilter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/2.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCGPUImageGlitchFilter.h"

NSString * const kSCGPUImageGlitchFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;
 
 const float PI = 3.1415926;
 
 float rand(float n) {
     return fract(sin(n) * 43758.5453123);
 }
 
 void main (void) {
     float maxJitter = 0.06;
     float duration = 0.3;
     float colorROffset = 0.06 * textureCoordinate.y;
     float colorBOffset = -0.02 * textureCoordinate.y;
     
     float currentTime = mod(time, duration * 2.0);
     float amplitude = max(sin(currentTime * (PI / duration)), 0.0);
     
     float jitter = rand(textureCoordinate.y) * 2.0 - 1.0;
     if (abs(jitter) >= maxJitter * amplitude) {
         jitter *= jitter * amplitude * 0.03;
     }

     float textureX = textureCoordinate.x + jitter;
     vec2 textureCoords = vec2(textureX, textureCoordinate.y);
     
     vec4 mask = texture2D(inputImageTexture, textureCoords);
     vec4 maskR = texture2D(inputImageTexture, textureCoords + vec2(colorROffset * amplitude, 0.0));
     vec4 maskB = texture2D(inputImageTexture, textureCoords + vec2(colorBOffset * amplitude, 0.0));
     
     gl_FragColor = vec4(maskR.r, mask.g, maskB.b, mask.a);
 }
);

@implementation SCGPUImageGlitchFilter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageGlitchFilterShaderString];
    return self;
}

@end
