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

- (void)addBeautifyFilter {
    GPUImageFilter *beautifyFilter = (GPUImageFilter *)[[GPUImageBeautifyFilter alloc] init];
    [[SCCameraManager shareManager].currentFilterHandler setBeautifyFilter:beautifyFilter];
}

- (void)removeBeautifyFilter {
    [[SCCameraManager shareManager].currentFilterHandler setBeautifyFilter:nil];
}

@end

#pragma clang diagnostic pop
