//
//  SCTimeHelper.m
//  SimpleCam
//
//  Created by Lyman on 2019/6/3.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "SCTimeHelper.h"

@implementation SCTimeHelper

+ (NSString *)timeStringWithTimestamp:(NSInteger)timestamp {
    NSInteger second = timestamp % 60;
    NSInteger minute = (timestamp / 60) % 60;
    NSInteger hour = timestamp / 60 / 60;
    
    NSString *result = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    if (hour > 0) {
        result = [NSString stringWithFormat:@"%02ld:%@", hour, result];
    }
    return result;
}

@end
