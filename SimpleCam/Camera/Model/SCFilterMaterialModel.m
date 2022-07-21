//
//  SCFilterMaterialModel.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterMaterialModel.h"

@interface SCFilterMaterialModel ()

@property (nonatomic, copy) NSString *floder;

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
        self.floder = floder;
    }
    return self;
}

- (GPUImageFilter *)filter {
    return [[NSClassFromString(self.filterClass) alloc] init];
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
