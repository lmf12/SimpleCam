//
//  SCFilterManager.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterManager.h"

static SCFilterManager *_filterManager;

@interface SCFilterManager ()

@property (nonatomic, strong, readwrite) NSArray<SCFilterMaterialModel *> *defaultFilters;

@end

@implementation SCFilterManager

+ (SCFilterManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _filterManager = [[SCFilterManager alloc] init];
    });
    return _filterManager;
}

#pragma mark - Public

- (GPUImageFilter *)filterWithFilterID:(NSString *)filterID {
    if ([filterID isEqualToString:@"sketch"]) {
        return [[GPUImageSketchFilter alloc] init];
    } else {
        return [[GPUImageFilter alloc] init];
    }
}

#pragma mark - Private

- (NSArray<SCFilterMaterialModel *> *)setupDefaultFilters {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    
    SCFilterMaterialModel *filterMaterialModel = [[SCFilterMaterialModel alloc] init];
    filterMaterialModel.filterID = @"none";
    filterMaterialModel.filterName = @"原图";
    
    [mutArr addObject:filterMaterialModel];
    
    SCFilterMaterialModel *filterMaterialModel1 = [[SCFilterMaterialModel alloc] init];
    filterMaterialModel1.filterID = @"sketch";
    filterMaterialModel1.filterName = @"素描";
    
    [mutArr addObject:filterMaterialModel1];
    
    return [mutArr copy];
}

#pragma mark - Custom Accessor

- (NSArray<SCFilterMaterialModel *> *)defaultFilters {
    if (!_defaultFilters) {
        _defaultFilters = [self setupDefaultFilters];
    }
    return _defaultFilters;
}

@end
