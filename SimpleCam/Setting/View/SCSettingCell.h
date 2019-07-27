//
//  SCSettingCell.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/7/27.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCSettingModel.h"

#import <UIKit/UIKit.h>

@interface SCSettingCell : UITableViewCell

@property (nonatomic, strong) SCSettingModel *model;

- (void)setOn:(BOOL)isOn;

@end
