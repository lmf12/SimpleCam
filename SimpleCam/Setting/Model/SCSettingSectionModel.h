//
//  SCSettingSectionModel.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/7/27.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCSettingModel.h"

@interface SCSettingSectionModel : NSObject

@property (nonatomic, strong) NSString *sectionID;
@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, copy) NSArray <SCSettingModel *>*models;

@end
