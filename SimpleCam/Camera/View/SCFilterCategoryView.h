//
//  SCFilterCategoryView.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/1.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCFilterCategoryView;

@protocol SCFilterCategoryViewDelegate <NSObject>

- (void)filterCategoryView:(SCFilterCategoryView *)filterCategoryView
          didScrollToIndex:(NSUInteger)index;

@end

@interface SCFilterCategoryView : UIView

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, assign) CGFloat bottomLineWidth;
@property (nonatomic, assign) CGFloat bottomLineHeight;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, strong) NSArray <NSString *> *itemList;

@property (nonatomic, weak) id<SCFilterCategoryViewDelegate> delegate;

- (void)scrollToIndex:(NSUInteger)index;

@end
