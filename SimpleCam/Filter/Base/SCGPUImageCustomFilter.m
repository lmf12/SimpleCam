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
    return [self initWithVertexShaderFile:vertexShaderPath
                       fragmentShaderFile:fragmentShaderPath
                                 uniforms:nil];
}

- (instancetype)initWithVertexShaderFile:(NSString *)vertexShaderPath
                      fragmentShaderFile:(NSString *)fragmentShaderPath
                                uniforms:(NSDictionary *)uniforms {
    NSString *fsh = [NSString stringWithContentsOfFile:fragmentShaderPath
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
    NSString *vsh = [NSString stringWithContentsOfFile:vertexShaderPath
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
    fsh = fsh.length > 0 ? fsh : kGPUImagePassthroughFragmentShaderString;
    vsh = vsh.length > 0 ? vsh : kGPUImageVertexShaderString;
    self = [super initWithVertexShaderFromString:vsh fragmentShaderFromString:fsh];
    if (self) {
        if (uniforms) {
            [uniforms enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
                [self setFloat:value.floatValue forUniformName:key];
            }];
        }
    }
    return self;
}

@end
