//
//  SCTabModel.h
//  SimpleCam
//
//  Created by Lyman Li on 2022/7/19.
//  Copyright © 2022 Lyman Li. All rights reserved.
//

#import "SCFilterMaterialModel.h"

@interface SCTabModel : NSObject

@property (nonatomic, copy) NSString *tabID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *filters;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

