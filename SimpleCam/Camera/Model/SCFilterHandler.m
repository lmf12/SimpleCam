//
//  SCFilterHandler.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/25.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterHandler.h"

@interface SCFilterHandler ()

@property (nonatomic, strong) NSMutableArray<GPUImageFilter *> *filters;

@property (nonatomic, weak) GPUImageFilter *currentBeautifyFilter;
@property (nonatomic, weak) GPUImageFilter *currentDefaultFilter;

@end

@implementation SCFilterHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.filters = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Public

- (GPUImageFilter *)firstFilter {
    return self.filters.firstObject;
}

- (GPUImageFilter *)lastFilter {
    return self.filters.lastObject;
}

- (void)addFilter:(GPUImageFilter *)filter {
    NSArray *targets = self.filters.lastObject.targets;
    [self.filters.lastObject removeAllTargets];
    [self.filters.lastObject addTarget:filter];
    for (id <GPUImageInput> input in targets) {
        [filter addTarget:input];
    }
    [self.filters addObject:filter];
}

- (void)setBeautifyFilter:(GPUImageFilter *)filter {
    if (!filter) {
        filter = [[GPUImageFilter alloc] init];
    }
    if (!self.currentBeautifyFilter) {
        [self addFilter:filter];
    } else {
        NSInteger index = [self.filters indexOfObject:self.currentBeautifyFilter];
        GPUImageOutput *source = index == 0 ? self.source : self.filters[index - 1];
        for (id <GPUImageInput> input in self.currentBeautifyFilter.targets) {
            [filter addTarget:input];
        }
        [source removeTarget:self.currentBeautifyFilter];
        [source addTarget:filter];
        self.filters[index] = filter;
    }
    self.currentBeautifyFilter = filter;
}

- (void)setDefaultFilter:(GPUImageFilter *)filter {
    if (!filter) {
        filter = [[GPUImageFilter alloc] init];
    }
    if (!self.currentDefaultFilter) {
        [self addFilter:filter];
    } else {
        NSInteger index = [self.filters indexOfObject:self.currentDefaultFilter];
        GPUImageOutput *source = index == 0 ? self.source : self.filters[index - 1];
        for (id <GPUImageInput> input in self.currentDefaultFilter.targets) {
            [filter addTarget:input];
        }
        [source removeTarget:self.currentDefaultFilter];
        [source addTarget:filter];
        self.filters[index] = filter;
    }
    self.currentDefaultFilter = filter;
}

@end








