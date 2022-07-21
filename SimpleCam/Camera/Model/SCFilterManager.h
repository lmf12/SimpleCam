//
//  SCFilterManager.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <GPUImage.h>

#import "SCTabModel.h"

#import "SCFilterMaterialModel.h"

@interface SCFilterManager : NSObject

@property (nonatomic, strong) NSArray<SCTabModel *> *tabs;

/**
 获取实例
 */
+ (SCFilterManager *)shareManager;

@end
