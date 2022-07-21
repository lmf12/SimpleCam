//
//  SCFilterManager.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterManager.h"

static SCFilterManager *_filterManager;

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

#pragma mark - Private

- (void)commonInit {
    [self setupTabs];
    [self setupFilters];
}

- (void)setupTabs {
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"Tab"
                                                           ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:configPath];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:nil];
    NSMutableArray *tabList = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dictionary[@"tabs"]) {
        SCTabModel *tab = [[SCTabModel alloc] initWithDictionary:dict];
        [tabList addObject:tab];
    }
    self.tabs = [tabList copy];
}

- (void)setupFilters {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *materialDir = [NSString stringWithFormat:@"%@/Material", bundlePath];
    
    NSMutableDictionary<NSString *, NSMutableArray *> *filters = [[NSMutableDictionary alloc] init];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:materialDir];
    for (NSString *path in enumerator.allObjects) {
        if ([path containsString:@"/"]) {
            continue;
        }
        NSString *configPath = [NSString stringWithFormat:@"%@/%@/Material.json", materialDir, path];
        NSData *data = [[NSData alloc] initWithContentsOfFile:configPath];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
        SCFilterMaterialModel *filter = [[SCFilterMaterialModel alloc] initWithDictionary:dictionary floder:path];
        if (!filters[filter.tabID]) {
            filters[filter.tabID] = [[NSMutableArray alloc] init];
        }
        [filters[filter.tabID] addObject:filter];
    }
    
    for (SCTabModel *tab in self.tabs) {
        NSArray *sortedArray = [filters[tab.tabID] sortedArrayUsingComparator:^NSComparisonResult(SCFilterMaterialModel *model1, SCFilterMaterialModel *model2) {
            return model1.sort < model2.sort ? NSOrderedAscending : NSOrderedDescending;
        }];
        tab.filters = sortedArray;
    }
}

@end
