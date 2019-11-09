//
//  SCGPUImageSplit4V4Filter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/11/9.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "SCGPUImageSplit4V4Filter.h"

@implementation SCGPUImageSplit4V4Filter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontal = 4.0;
        self.vertical = 4.0;
    }
    return self;
}

@end
