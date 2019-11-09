//
//  SCFilterManager.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <GPUImage.h>

#import <Foundation/Foundation.h>

#import "SCFilterMaterialModel.h"

@interface SCFilterManager : NSObject

/// GPUImage 自带滤镜列表
@property (nonatomic, strong, readonly) NSArray<SCFilterMaterialModel *> *defaultFilters;
/// 抖音滤镜列表
@property (nonatomic, strong, readonly) NSArray<SCFilterMaterialModel *> *tiktokFilters;
/// 人脸识别滤镜列表
@property (nonatomic, strong, readonly) NSArray<SCFilterMaterialModel *> *faceRecognizerFilters;
/// 分屏滤镜列表
@property (nonatomic, strong, readonly) NSArray<SCFilterMaterialModel *> *splitFilters;

/**
 获取实例
 */
+ (SCFilterManager *)shareManager;

/**
 通过滤镜 ID 返回滤镜对象
 */
- (GPUImageFilter *)filterWithFilterID:(NSString *)filterID;

@end
