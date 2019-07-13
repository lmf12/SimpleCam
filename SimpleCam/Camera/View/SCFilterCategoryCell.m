//
//  SCFilterCategoryCell.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/1.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterCategoryCell.h"

static NSInteger kFilterCategoryCellBottomLineHeight = 2;

@implementation SCFilterCategoryCell

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.clipsToBounds = YES;
    self.bottomLine.layer.cornerRadius = kFilterCategoryCellBottomLineHeight / 2;
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.titleLabel);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(kFilterCategoryCellBottomLineHeight);
        make.bottom.equalTo(self);
    }];
}

@end
