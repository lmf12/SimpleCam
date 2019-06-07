//
//  SCFilterMaterialView.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@class SCFilterMaterialView;

@protocol SCFilterMaterialViewDelegate <NSObject>

- (void)filterMaterialView:(SCFilterMaterialView *)filterMaterialView didScrollToIndex:(NSUInteger)index;

@end

@interface SCFilterMaterialView : UIView

@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *itemList;
@property (nonatomic, weak) id <SCFilterMaterialViewDelegate> delegate;

@end
