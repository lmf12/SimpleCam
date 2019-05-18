//
//  UIView+Extention.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extention)

/**
 设置显示隐藏
 */
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

@end
