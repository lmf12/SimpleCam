//
//  UIButton+Extention.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/6/2.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <objc/runtime.h>

#import "UIButton+Extention.h"

@implementation UIButton (Extention)

#pragma mark - Public

- (void)setEnableDarkWithImageName:(NSString *)name {
    NSString *darkName = [name stringByAppendingString:@"_black"];
    [self setDarkImage:[UIImage imageNamed:darkName]
           normalImage:[UIImage imageNamed:name]];
    [self setIsDarkMode:[self isDarkMode]];
}

- (void)setDarkImage:(UIImage *)darkImage normalImage:(UIImage *)normalImage {
    [self setDarkImage:darkImage];
    [self setNormalImage:normalImage];
}

- (void)setIsDarkMode:(BOOL)isDarkMode {
    objc_setAssociatedObject(self, @selector(isDarkMode), @(isDarkMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIImage *image = isDarkMode ? [self darkImage] : [self normalImage];
    [self setImage:image forState:UIControlStateNormal];
    
    if (isDarkMode) {
        [self clearShadow];
    } else {
        [self setDefaultShadow];
    }
}

#pragma mark - Private

- (BOOL)isDarkMode {
    NSNumber *isDark = objc_getAssociatedObject(self, _cmd);
    return [isDark boolValue];
}

- (void)setDarkImage:(UIImage *)image {
    objc_setAssociatedObject(self, @selector(darkImage), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNormalImage:(UIImage *)image {
    objc_setAssociatedObject(self, @selector(normalImage), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)normalImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIImage *)darkImage {
    return objc_getAssociatedObject(self, _cmd);
}

@end
