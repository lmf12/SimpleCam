//
//  SCFilterMaterialViewCell.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <GPUImage.h>

#import "SCFilterHelper.h"
#import "SCFilterManager.h"

#import "SCFilterMaterialViewCell.h"

@interface SCFilterMaterialViewCell ()

@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) GPUImagePicture *picture;

@end

@implementation SCFilterMaterialViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.picture removeAllTargets];
}

#pragma mark - Private

- (void)commonInit {
    [self setupImageView];
    [self setupTitleLabel];
    
    self.picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"filter_sample.jpg"]];
}

- (void)setupImageView {
    self.imageView = [[GPUImageView alloc] init];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 80));
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self);
    }];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - Custom Accessor

- (void)setFilterMaterialModel:(SCFilterMaterialModel *)filterMaterialModel {
    _filterMaterialModel = filterMaterialModel;

    self.titleLabel.text = filterMaterialModel.filterName;
    
    GPUImageFilter *filter = [[SCFilterManager shareManager] filterWithFilterID:filterMaterialModel.filterID];
    
    [self.picture addTarget:filter];
    [filter addTarget:self.imageView];
    
    // 放到下次runloop执行
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.picture processImage];
    });

    
}

@end






