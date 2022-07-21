//
//  SCGPUImageCustomFilter.h
//  SimpleCam
//
//  Created by Lyman Li on 2022/7/22.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import "SCGPUImageBaseFilter.h"

@interface SCGPUImageCustomFilter : SCGPUImageBaseFilter

- (instancetype)initWithVertexShaderFile:(NSString *)vertexShaderPath
                      fragmentShaderFile:(NSString *)fragmentShaderPath;

@end
