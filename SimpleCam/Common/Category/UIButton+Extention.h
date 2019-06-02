//
//  UIButton+Extention.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/2.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extention)

/// 通过图片名称来设置图片，会自动设置黑暗模式和正常模式的图片
- (void)setEnableDarkWithImageName:(NSString *)name;

/// 设置黑暗模式和正常模式的图片
- (void)setDarkImage:(UIImage *)darkImage normalImage:(UIImage *)normalImage;

/// 设置是否黑暗模式
- (void)setIsDarkMode:(BOOL)isDarkMode;

@end
