//
//  SCFilterBarView.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterBarView.h"

#import "SCFilterMaterialView.h"

static CGFloat const kFilterMaterialViewHeight = 100.0f;

@interface SCFilterBarView () <SCFilterMaterialViewDelegate>

@property (nonatomic, strong) SCFilterMaterialView *filterMaterialView;
@property (nonatomic, strong) UISwitch *beautifySwitch;

@end

@implementation SCFilterBarView

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

#pragma mark - Private

- (void)commonInit {
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    [self setupFilterMaterialView];
    [self setupBeautifySwitch];
}

- (void)setupFilterMaterialView {
    self.filterMaterialView = [[SCFilterMaterialView alloc] init];
    self.filterMaterialView.delegate = self;
    [self addSubview:self.filterMaterialView];
    [self.filterMaterialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(50);
        make.height.mas_equalTo(kFilterMaterialViewHeight);
    }];
}

- (void)setupBeautifySwitch {
    self.beautifySwitch = [[UISwitch alloc] init];
    self.beautifySwitch.onTintColor = RGBA(129, 171, 119, 1);
    self.beautifySwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self.beautifySwitch addTarget:self
                            action:@selector(beautifySwitchValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.beautifySwitch];
    [self.beautifySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.top.equalTo(self.filterMaterialView.mas_bottom).offset(8);
    }];
    
    UILabel *switchLabel = [[UILabel alloc] init];
    switchLabel.textColor = [UIColor whiteColor];
    switchLabel.font = [UIFont systemFontOfSize:12];
    switchLabel.text = @"美颜";
    [self addSubview:switchLabel];
    [switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beautifySwitch.mas_right).offset(3);
        make.centerY.equalTo(self.beautifySwitch);
    }];
}

#pragma mark - Action

- (void)beautifySwitchValueChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterBarView:beautifySwitchIsOn:)]) {
        [self.delegate filterBarView:self beautifySwitchIsOn:self.beautifySwitch.isOn];
    }
}

#pragma mark - Custom Accessor

- (void)setDefaultFilterMaterials:(NSArray<SCFilterMaterialModel *> *)defaultFilterMaterials {
    _defaultFilterMaterials = [defaultFilterMaterials copy];
    
    self.filterMaterialView.itemList = defaultFilterMaterials;
}

#pragma mark - SCFilterMaterialViewDelegate

- (void)filterMaterialView:(SCFilterMaterialView *)filterMaterialView didScrollToIndex:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(filterBarView:materialDidScrollToIndex:)]) {
        [self.delegate filterBarView:self materialDidScrollToIndex:index];
    }
}

@end






