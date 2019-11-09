//
//  SCGPUImageSplit3V2Filter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/11/9.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "SCGPUImageSplit3V2Filter.h"

@implementation SCGPUImageSplit3V2Filter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontal = 3.0;
        self.vertical = 2.0;
    }
    return self;
}

@end
