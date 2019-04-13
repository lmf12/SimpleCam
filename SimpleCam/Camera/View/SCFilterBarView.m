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

#pragma mark - Custom Accessor

- (void)setDefaultFilterMaterials:(NSArray<SCFilterMaterialModel *> *)defaultFilterMaterials {
    _defaultFilterMaterials = [defaultFilterMaterials copy];
    
    self.filterMaterialView.itemList = defaultFilterMaterials;
}

#pragma mark - SCFilterMaterialViewDelegate

- (void)filterMaterialView:(SCFilterMaterialView *)filterMaterialView didScrollToIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterBarView:materialDidScrollToIndex:)]) {
        [self.delegate filterBarView:self materialDidScrollToIndex:index];
    }
}

@end






