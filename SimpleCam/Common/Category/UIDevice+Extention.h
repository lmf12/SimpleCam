//
//  UIDevice+Extention.h
//  SimpleCam
//
//  Created by Lyman on 2019/6/1.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DeviceType) {
    Unknown = 0,
    Simulator,
    IPhone_1G,
    IPhone_3G,
    IPhone_3GS,
    IPhone_4,
    IPhone_4s,
    IPhone_5,
    IPhone_5C,
    IPhone_5S,
    IPhone_SE,
    IPhone_6,
    IPhone_6P,
    IPhone_6s,
    IPhone_6s_P,
    IPhone_7,
    IPhone_7P,
    IPhone_8,
    IPhone_8P,
    IPhone_X,
    IPhone_XR,
    IPhone_XS,
    IPhone_XS_Max,
    IPhone_11,
    IPhone_11_Pro,
    IPhone_11_Pro_Max,
};

@interface UIDevice (Extention)

+ (DeviceType)deviceType;

/// 是否 iPhoneX 系列手机
+ (BOOL)is_iPhoneX_Series;

/// 是否 6.5 英寸手机
+ (BOOL)is_6_5_Inch;

@end
