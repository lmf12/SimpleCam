//
//  SCGPUImageSplit1V3Filter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/11/9.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "SCGPUImageSplit1V3Filter.h"

@implementation SCGPUImageSplit1V3Filter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontal = 1.0;
        self.vertical = 3.0;
    }
    return self;
}

@end
