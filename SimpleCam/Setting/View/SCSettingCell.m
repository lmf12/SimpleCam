//
//  SCSettingCell.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/7/27.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCSettingCell.h"

@interface SCSettingCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *statusSwitch;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation SCSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

- (void)setOn:(BOOL)isOn {
    [self.statusSwitch setOn:isOn];
}

- (BOOL)isOn {
    return [self.statusSwitch isOn];
}

#pragma mark - Custom Accessor

- (void)setModel:(SCSettingModel *)model {
    _model = model;
    
    self.titleLabel.text = model.modelTitle;
    [self.statusSwitch setOn:model.isSwitchOn];
}

#pragma mark - Private

- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupTitleLabel];
    [self setupStatusSwitch];
    [self setupBottomLine];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
}

- (void)setupStatusSwitch {
    self.statusSwitch = [[UISwitch alloc] init];
    self.statusSwitch.onTintColor = ThemeColor;
    self.statusSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.statusSwitch addTarget:self
                          action:@selector(switchValueChangedAction:)
                forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.statusSwitch];
    [self.statusSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
}

- (void)setupBottomLine {
    self.bottomLine = [[UIView alloc] init];
    [self.bottomLine setBackgroundColor:RGBA(205, 205, 205, 1)];
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(20);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Action

- (void)switchValueChangedAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(settingCell:didChangedWithModel:)]) {
        [self.delegate settingCell:self didChangedWithModel:self.model];
    }
}

@end
