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
@property (nonatomic, strong, readwrite) NSArray<SCFilterMaterialModel *> *tikTokFilters;
@property (nonatomic, strong, readwrite) NSArray<SCFilterMaterialModel *> *faceRecognizerFilters;
@property (nonatomic, strong, readwrite) NSArray<SCFilterMaterialModel *> *splitFilters;

@property (nonatomic, strong) NSDictionary *defaultFilterMaterialsInfo;
@property (nonatomic, strong) NSDictionary *tikTokFilterMaterialsInfo;
@property (nonatomic, strong) NSDictionary *faceRecognizerMaterialsInfo;
@property (nonatomic, strong) NSDictionary *splitFilterMaterialsInfo;

@property (nonatomic, strong) NSMutableDictionary *filterClassInfo;

@end

@implementation SCFilterManager

+ (SCFilterManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _filterManager = [[SCFilterManager alloc] init];
    });
    return _filterManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

- (GPUImageFilter *)filterWithFilterID:(NSString *)filterID {
    NSString *className = self.filterClassInfo[filterID];
    
    Class filterClass = NSClassFromString(className);
    return [[filterClass alloc] init];
}

#pragma mark - Private

- (void)commonInit {
    self.filterClassInfo = [[NSMutableDictionary alloc] init];
    [self setupDefaultFilterMaterialsInfo];
    [self setupTikTokFilterMaterialsInfo];
    [self setupFaceRecognizerMaterialsInfo];
    [self setupSplitFilterMaterialsInfo];
}

- (void)setupDefaultFilterMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DefaultFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.defaultFilterMaterialsInfo = [info copy];
}

- (void)setupTikTokFilterMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TikTokFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.tikTokFilterMaterialsInfo = [info copy];
}

- (void)setupFaceRecognizerMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FaceRecognizerMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.faceRecognizerMaterialsInfo = [info copy];
}

- (void)setupSplitFilterMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SplitFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.splitFilterMaterialsInfo = [info copy];
}

- (NSArray<SCFilterMaterialModel *> *)setupFiltersWithInfo:(NSDictionary *)info {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    
    NSArray *defaultArray = info[@"Default"];
    
    for (NSDictionary *dict in defaultArray) {
        SCFilterMaterialModel *model = [[SCFilterMaterialModel alloc] init];
        model.filterID = dict[@"filter_id"];
        model.filterName = dict[@"filter_name"];
        
        [mutArr addObject:model];
        
        self.filterClassInfo[dict[@"filter_id"]] = dict[@"filter_class"];
    }
    
    return [mutArr copy];
}

#pragma mark - Custom Accessor

- (NSArray<SCFilterMaterialModel *> *)defaultFilters {
    if (!_defaultFilters) {
        _defaultFilters = [self setupFiltersWithInfo:self.defaultFilterMaterialsInfo];
    }
    return _defaultFilters;
}

- (NSArray<SCFilterMaterialModel *> *)tiktokFilters {
    if (!_tikTokFilters) {
        _tikTokFilters = [self setupFiltersWithInfo:self.tikTokFilterMaterialsInfo];
    }
    return _tikTokFilters;
}

- (NSArray<SCFilterMaterialModel *> *)faceRecognizerFilters {
    if (!_faceRecognizerFilters) {
        _faceRecognizerFilters = [self setupFiltersWithInfo:self.faceRecognizerMaterialsInfo];
    }
    return _faceRecognizerFilters;
}

- (NSArray<SCFilterMaterialModel *> *)splitFilters {
    if (!_splitFilters) {
        _splitFilters = [self setupFiltersWithInfo:self.splitFilterMaterialsInfo];
    }
    return _splitFilters;
}

@end
