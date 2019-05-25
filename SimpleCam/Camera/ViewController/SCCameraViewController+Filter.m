//
//  SCCameraViewController+Filter.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCCameraViewController+Private.h"

#import "SCCameraViewController+Filter.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (Filter)

#pragma mark - Public

- (void)setupFilters {
    self.currentFilters = [[GPUImageFilter alloc] init];
}

- (void)addBeautifyFilter {
}

- (void)removeBeautifyFilter {
}

@end

#pragma clang diagnostic pop
