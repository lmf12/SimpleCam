//
//  SCFilterBarView.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@class SCFilterBarView;

@protocol SCFilterBarViewDelegate <NSObject>

- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySwitchIsOn:(BOOL)isOn;

@end

@interface SCFilterBarView : UIView

@property (nonatomic, assign) BOOL showing;

/// 内置滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;

@property (nonatomic, weak) id <SCFilterBarViewDelegate> delegate;

@end
