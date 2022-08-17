//
//  SCFilterMaterialModel.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCGPUImageCustomFilter.h"

#import "SCFilterMaterialModel.h"

@interface SCFilterMaterialModel ()

@property (nonatomic, copy) NSString *floder;
@property (nonatomic, copy) NSDictionary *uniforms;

@end

@implementation SCFilterMaterialModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                            floder:(NSString *)floder {
    self = [super init];
    if (self) {
        self.filterID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.filterClass = dictionary[@"class"];
        self.tabID = dictionary[@"tab_id"];
        self.sort = [dictionary[@"sort"] intValue];
        self.uniforms = dictionary[@"uniforms"];
        self.floder = floder;
    }
    return self;
}

- (GPUImageFilter *)filter {
    GPUImageFilter *filter = nil;
    Class filterClass = NSClassFromString(self.filterClass);
    NSString *vsh = [NSString stringWithFormat:@"%@/Vertex.vsh", self.floderPath];
    NSString *fsh = [NSString stringWithFormat:@"%@/Fragment.fsh", self.floderPath];
    BOOL hasCustomShader = ([[NSFileManager defaultManager] fileExistsAtPath:vsh] ||
                            [[NSFileManager defaultManager] fileExistsAtPath:fsh]);
    BOOL isCustomFilter = ([filterClass isEqual:[SCGPUImageCustomFilter class]] ||
                           [filterClass isSubclassOfClass:[SCGPUImageCustomFilter class]]);
    if (hasCustomShader && isCustomFilter) {
        filter = [[filterClass alloc] initWithVertexShaderFile:vsh
                                            fragmentShaderFile:fsh];
    } else {
        filter = [[filterClass alloc] init];
    }
    if ([filter isKindOfClass:[SCGPUImageCustomFilter class]]) {
        [((SCGPUImageCustomFilter *)filter) setUniforms:self.uniforms];
    }
    return filter;
}

- (NSString *)floderPath {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *materialDir = [NSString stringWithFormat:@"%@/Material/%@", bundlePath, self.floder];
    return materialDir;
}

- (NSString *)coverImagePath {
    return [NSString stringWithFormat:@"%@/cover.jpg", [self floderPath]];
}

@end
