//
//  SCFilterBarView.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCTabModel.h"

#import "SCFilterMaterialModel.h"

@class SCFilterBarView;

@protocol SCFilterBarViewDelegate <NSObject>

- (void)filterBarView:(SCFilterBarView *)filterBarView categoryDidScrollToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySwitchIsOn:(BOOL)isOn;
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySliderChangeToValue:(CGFloat)value;

@end

@interface SCFilterBarView : UIView

@property (nonatomic, assign) BOOL showing;
@property (nonatomic, weak) id <SCFilterBarViewDelegate> delegate;

- (void)setTabs:(NSArray<SCTabModel *> *)tabs;
- (NSInteger)currentCategoryIndex;

@end
