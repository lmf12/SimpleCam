//
//  SCAppSetting.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/7/27.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCAppSetting.h"

static NSString * const kUsingFaceppEngine = @"kUsingFaceppEngine";
static NSString * const kUsingOpenCVEngine = @"kUsingOpenCVEngine";

@implementation SCAppSetting

#pragma mark - Public

+ (void)setUsingFaceppEngine:(BOOL)isUsingFaceppEngine {
    [[NSUserDefaults standardUserDefaults] setBool:isUsingFaceppEngine
                                            forKey:kUsingFaceppEngine];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isUsingFaceppEngine {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUsingFaceppEngine];
}

+ (void)setUsingOpenCVEngine:(BOOL)isUsingOpenCVEngine {
    [[NSUserDefaults standardUserDefaults] setBool:isUsingOpenCVEngine
                                            forKey:kUsingOpenCVEngine];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isUsingOpenCVEngine {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUsingOpenCVEngine];
}

+ (BOOL)hasSaveFaceDetectEngine {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUsingOpenCVEngine] || [[NSUserDefaults standardUserDefaults] objectForKey:kUsingFaceppEngine];
}

@end
