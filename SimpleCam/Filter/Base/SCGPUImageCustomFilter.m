//
//  SCGPUImageCustomFilter.m
//  SimpleCam
//
//  Created by Lyman Li on 2022/7/22.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import "SCGPUImageCustomFilter.h"

@implementation SCGPUImageCustomFilter

- (instancetype)initWithVertexShaderFile:(NSString *)vertexShaderPath
                      fragmentShaderFile:(NSString *)fragmentShaderPath {
    NSString *fsh = [NSString stringWithContentsOfFile:fragmentShaderPath
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
    NSString *vsh = [NSString stringWithContentsOfFile:vertexShaderPath
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
    self = [self initWithVertexShaderFromString:vsh fragmentShaderFromString:fsh];
    return self;
}


- (instancetype)initWithVertexShaderFromString:(NSString *)vertexShaderString
                      fragmentShaderFromString:(NSString *)fragmentShaderString {
    fragmentShaderString = fragmentShaderString.length > 0 ? fragmentShaderString : kGPUImagePassthroughFragmentShaderString;
    vertexShaderString = vertexShaderString.length > 0 ? vertexShaderString : kGPUImageVertexShaderString;
    self = [super initWithVertexShaderFromString:vertexShaderString fragmentShaderFromString:fragmentShaderString];
    return self;
}

- (void)setUniforms:(NSDictionary *)uniforms {
    if (!uniforms) {
        return;
    }
    [uniforms enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [self setFloat:value.floatValue forUniformName:key];
    }];
}

@end
