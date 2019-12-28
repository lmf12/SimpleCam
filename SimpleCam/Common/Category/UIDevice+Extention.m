//
//  UIDevice+Extention.m
//  SimpleCam
//
//  Created by Lyman on 2019/6/1.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import <sys/utsname.h>

#import "UIDevice+Extention.h"

@implementation UIDevice (Extention)

+ (DeviceType)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    //simulator
    if ([platform isEqualToString:@"i386"])          return Simulator;
    if ([platform isEqualToString:@"x86_64"])        return Simulator;
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])     return IPhone_1G;
    if ([platform isEqualToString:@"iPhone1,2"])     return IPhone_3G;
    if ([platform isEqualToString:@"iPhone2,1"])     return IPhone_3GS;
    if ([platform isEqualToString:@"iPhone3,1"])     return IPhone_4;
    if ([platform isEqualToString:@"iPhone3,2"])     return IPhone_4;
    if ([platform isEqualToString:@"iPhone4,1"])     return IPhone_4s;
    if ([platform isEqualToString:@"iPhone5,1"])     return IPhone_5;
    if ([platform isEqualToString:@"iPhone5,2"])     return IPhone_5;
    if ([platform isEqualToString:@"iPhone5,3"])     return IPhone_5C;
    if ([platform isEqualToString:@"iPhone5,4"])     return IPhone_5C;
    if ([platform isEqualToString:@"iPhone6,1"])     return IPhone_5S;
    if ([platform isEqualToString:@"iPhone6,2"])     return IPhone_5S;
    if ([platform isEqualToString:@"iPhone7,1"])     return IPhone_6P;
    if ([platform isEqualToString:@"iPhone7,2"])     return IPhone_6;
    if ([platform isEqualToString:@"iPhone8,1"])     return IPhone_6s;
    if ([platform isEqualToString:@"iPhone8,2"])     return IPhone_6s_P;
    if ([platform isEqualToString:@"iPhone8,4"])     return IPhone_SE;
    if ([platform isEqualToString:@"iPhone9,1"])     return IPhone_7;
    if ([platform isEqualToString:@"iPhone9,3"])     return IPhone_7;
    if ([platform isEqualToString:@"iPhone9,2"])     return IPhone_7P;
    if ([platform isEqualToString:@"iPhone9,4"])     return IPhone_7P;
    if ([platform isEqualToString:@"iPhone10,1"])    return IPhone_8;
    if ([platform isEqualToString:@"iPhone10,4"])    return IPhone_8;
    if ([platform isEqualToString:@"iPhone10,2"])    return IPhone_8P;
    if ([platform isEqualToString:@"iPhone10,5"])    return IPhone_8P;
    if ([platform isEqualToString:@"iPhone10,3"])    return IPhone_X;
    if ([platform isEqualToString:@"iPhone10,6"])    return IPhone_X;
    if ([platform isEqualToString:@"iPhone11,8"])    return IPhone_XR;
    if ([platform isEqualToString:@"iPhone11,2"])    return IPhone_XS;
    if ([platform isEqualToString:@"iPhone11,4"] ||
        [platform isEqualToString:@"iPhone11,6"])    return IPhone_XS_Max;
    if ([platform isEqualToString:@"iPhone12,1"])    return IPhone_11;
    if ([platform isEqualToString:@"iPhone12,3"])    return IPhone_11_Pro;
    if ([platform isEqualToString:@"iPhone12,5"])    return IPhone_11_Pro_Max;
    
    return Unknown;
}

+ (BOOL)is_iPhoneX_Series {
    DeviceType deviceType = [self deviceType];
    BOOL is_iPhoneX = deviceType == IPhone_X ||
                      deviceType == IPhone_XR ||
                      deviceType == IPhone_XS ||
                      deviceType == IPhone_XS_Max ||
                      deviceType == IPhone_11 ||
                      deviceType == IPhone_11_Pro ||
                      deviceType == IPhone_11_Pro_Max;
    return is_iPhoneX;
}

+ (BOOL)is_6_5_Inch {
    DeviceType deviceType = [self deviceType];
    return (deviceType == IPhone_XS_Max ||
            deviceType == IPhone_11_Pro_Max);
}

@end
