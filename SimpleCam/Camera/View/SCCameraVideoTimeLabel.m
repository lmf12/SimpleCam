//
//  SCCameraVideoTimeLabel.m
//  SimpleCam
//
//  Created by Lyman on 2019/6/3.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "SCTimeHelper.h"

#import "SCCameraVideoTimeLabel.h"

@interface SCCameraVideoTimeLabel ()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation SCCameraVideoTimeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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

#pragma mark - Public

- (void)resetTime {
    self.timestamp = 0;
}

#pragma mark - Private

- (void)commonInit {
    [self setupTimeLabel];
    
    [self updateDarkMode];
    [self updateTimeLabel];
}

- (void)setupTimeLabel {
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)updateDarkMode {
    self.timeLabel.textColor = self.isDarkMode ? [UIColor blackColor] : [UIColor whiteColor];
    
    if (self.isDarkMode) {
        [self clearShadow];
    } else {
        [self setDefaultShadow];
    }
}

- (void)updateTimeLabel {
    self.timeLabel.text = [SCTimeHelper timeStringWithTimestamp:self.timestamp];
}


#pragma mark - Custom Accessor

- (void)setTimestamp:(NSInteger)timestamp {
    _timestamp = timestamp;
    
    [self updateTimeLabel];
}

- (void)setIsDarkMode:(BOOL)isDarkMode {
    _isDarkMode = isDarkMode;
    
    [self updateDarkMode];
}

@end
