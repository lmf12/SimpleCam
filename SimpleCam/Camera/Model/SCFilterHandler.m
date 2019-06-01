//
//  SCFilterHandler.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/25.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCGPUImageBaseFilter.h"

#import "SCFilterHandler.h"

@interface SCFilterHandler ()

@property (nonatomic, strong) NSMutableArray<GPUImageFilter *> *filters;

@property (nonatomic, strong) GPUImageCropFilter *currentCropFilter;

@property (nonatomic, weak) GPUImageFilter *currentBeautifyFilter;
@property (nonatomic, weak) GPUImageFilter *currentEffectFilter;

@property (nonatomic, strong) CADisplayLink *displayLink;  // 用来刷新时间

@end

@implementation SCFilterHandler

- (void)dealloc {
    [self endDisplayLink];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
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

- (void)setCropRect:(CGRect)rect {
    self.currentCropFilter.cropRegion = rect;
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

- (void)setEffectFilter:(GPUImageFilter *)filter {
    if (!filter) {
        filter = [[GPUImageFilter alloc] init];
    }
    if (!self.currentEffectFilter) {
        [self addFilter:filter];
    } else {
        NSInteger index = [self.filters indexOfObject:self.currentEffectFilter];
        GPUImageOutput *source = index == 0 ? self.source : self.filters[index - 1];
        for (id <GPUImageInput> input in self.currentEffectFilter.targets) {
            [filter addTarget:input];
        }
        [source removeTarget:self.currentEffectFilter];
        [source addTarget:filter];
        self.filters[index] = filter;
    }
    self.currentEffectFilter = filter;
    
    // 记录应用的时间
    if ([filter isKindOfClass:[SCGPUImageBaseFilter class]]) {
        ((SCGPUImageBaseFilter *)filter).beginTime = self.displayLink.timestamp;
    }
}

#pragma mark - Private

- (void)commonInit {
    self.filters = [[NSMutableArray alloc] init];
    [self addCropFilter];
    [self setupDisplayLink];
}

- (void)addCropFilter {
    self.currentCropFilter = [[GPUImageCropFilter alloc] init];
    [self addFilter:self.currentCropFilter];
}

- (void)setupDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(displayAction)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)endDisplayLink {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - Action

- (void)displayAction {
    if ([self.currentEffectFilter isKindOfClass:[SCGPUImageBaseFilter class]]) {
        SCGPUImageBaseFilter *filter = (SCGPUImageBaseFilter *)self.currentEffectFilter;
        filter.time = self.displayLink.timestamp - filter.beginTime;
    }
}

@end








