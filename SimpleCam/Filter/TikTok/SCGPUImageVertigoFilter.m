//
//  SCGPUImageVertigoFilter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/2.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCGPUImageVertigoFilter.h"

NSString * const kSCGPUImageVertigoFilterShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 varying vec2 textureCoordinate;
 
 uniform float time;
 
 const float PI = 3.1415926;
 const float duration = 2.0;
 
 vec4 getMask(float currentTime, vec2 textureCoords, float padding) {
     vec2 translation = vec2(sin(currentTime * (PI * 2.0 / duration)),
                             cos(currentTime * (PI * 2.0 / duration)));
     vec2 translationTextureCoords = textureCoords + padding * translation;
     vec4 mask = texture2D(inputImageTexture, translationTextureCoords);
     
     return mask;
 }
 
 float maskAlphaProgress(float currentTime, float hideTime, float startTime) {
     float time = mod(duration + currentTime - startTime, duration);
     return min(time, hideTime);
 }
 
 void main (void) {
     float currentTime = mod(time, duration);
     
     float scale = 1.2;
     float padding = 0.5 * (1.0 - 1.0 / scale);
     vec2 textureCoords = vec2(0.5, 0.5) + (textureCoordinate - vec2(0.5, 0.5)) / scale;
     
     float hideTime = 0.9;
     float timeGap = 0.2;
     
     float maxAlphaR = 0.5; // max R
     float maxAlphaG = 0.05; // max G
     float maxAlphaB = 0.05; // max B
     
     vec4 mask = getMask(time, textureCoords, padding);
     float alphaR = 1.0; // R
     float alphaG = 1.0; // G
     float alphaB = 1.0; // B
     
     vec4 resultMask = vec4(0, 0, 0, 0);
     
     for (float f = 0.0; f < duration; f += timeGap) {
         float tmpTime = f;
         vec4 tmpMask = getMask(tmpTime, textureCoords, padding);
         float tmpAlphaR = maxAlphaR - maxAlphaR * maskAlphaProgress(time, hideTime, tmpTime) / hideTime;
         float tmpAlphaG = maxAlphaG - maxAlphaG * maskAlphaProgress(time, hideTime, tmpTime) / hideTime;
         float tmpAlphaB = maxAlphaB - maxAlphaB * maskAlphaProgress(time, hideTime, tmpTime) / hideTime;
         
         resultMask += vec4(tmpMask.r * tmpAlphaR,
                            tmpMask.g * tmpAlphaG,
                            tmpMask.b * tmpAlphaB,
                            1.0);
         alphaR -= tmpAlphaR;
         alphaG -= tmpAlphaG;
         alphaB -= tmpAlphaB;
     }
     resultMask += vec4(mask.r * alphaR, mask.g * alphaG, mask.b * alphaB, 1.0);
     
     gl_FragColor = resultMask;
 }
);

@implementation SCGPUImageVertigoFilter

- (instancetype)init {
    self = [super initWithFragmentShaderFromString:kSCGPUImageVertigoFilterShaderString];
    return self;
}

@end
