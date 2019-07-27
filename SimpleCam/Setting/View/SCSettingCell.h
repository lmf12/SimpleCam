//
//  SCSettingCell.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/7/27.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCSettingModel.h"

#import <UIKit/UIKit.h>

@class SCSettingCell;

@protocol SCSettingCellDelegate <NSObject>

- (void)settingCell:(SCSettingCell *)settingCell didChangedWithModel:(SCSettingModel *)model;

@end

@interface SCSettingCell : UITableViewCell

@property (nonatomic, strong) SCSettingModel *model;
@property (nonatomic, weak) id <SCSettingCellDelegate> delegate;

- (void)setOn:(BOOL)isOn;
- (BOOL)isOn;

@end
