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
    
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kFilterCategoryCellBottomLineHeight, 0, kFilterCategoryCellBottomLineHeight)];
    _bottomLine.clipsToBounds = YES;
    _bottomLine.backgroundColor = [UIColor redColor];
    [self addSubview:_bottomLine];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _titleLabel.frame = self.bounds;
    
    CGRect bottomLineFrame = _bottomLine.frame;
    bottomLineFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(bottomLineFrame)) / 2;
    bottomLineFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(bottomLineFrame);
    _bottomLine.frame = bottomLineFrame;
    
}

@end
