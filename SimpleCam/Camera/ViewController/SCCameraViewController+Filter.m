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
    [SCCameraManager shareManager].currentFilterHandler.beautifyFilterEnable = YES;
}

- (void)removeBeautifyFilter {
    [SCCameraManager shareManager].currentFilterHandler.beautifyFilterEnable = NO;
}

- (NSArray<SCFilterMaterialModel *> *)filtersWithCategoryIndex:(NSInteger)index {
    if (index == 0) {
        return self.defaultFilterMaterials;
    } else if (index == 1) {
        return self.tikTokFilterMaterials;
    }
    return nil;
}

@end

#pragma clang diagnostic pop
