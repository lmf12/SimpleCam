//
//  SCColorfulHairFilter.m
//  SimpleCam
//
//  Created by 李棉烽 on 2022/8/17.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import "SCColorfulHairFilter.h"

NSString * const kSCColorfulHairFilterShaderString = SHADER_STRING
(
 precision highp float;

 uniform sampler2D inputImageTexture;
 uniform sampler2D hairMask;
 
 uniform float colorR;
 uniform float colorG;
 uniform float colorB;
 uniform float colorA;
 
 varying vec2 textureCoordinate;

 float maxColor(float r, float g, float b) {
    return max(max(r, g), b);
 }

 float minColor(float r, float g, float b) {
    return min(min(r, g), b);
 }
 
 float lightness(vec3 color) {
    return (maxColor(color.r, color.g, color.b) + minColor(color.r, color.g, color.b)) / 2.0;
}

 void main (void) {
    vec4 mask = texture2D(hairMask, textureCoordinate);
    vec4 color = texture2D(inputImageTexture, textureCoordinate);
    
    float originLightness = lightness(color.rgb);
     
    color.r = color.r + colorR * colorA * mask.g;
    color.g = color.g + colorG * colorA * mask.g;
    color.b = color.b + colorB * colorA * mask.g;

    float resultLightness = lightness(color.rgb);
    
    gl_FragColor = vec4(color.rgb * (originLightness / resultLightness), 1.0);
 }

);

@implementation SCColorfulHairFilter

- (instancetype)init {
    self = [super initWithVertexShaderFromString:nil fragmentShaderFromString:kSCColorfulHairFilterShaderString];
    return self;
}

@end
