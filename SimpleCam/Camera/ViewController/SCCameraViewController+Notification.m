//
//  SCCameraViewController+Notification.m
//  SimpleCam
//
//  Created by Lyman on 2019/6/3.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "SCCameraViewController+Private.h"

#import "SCCameraViewController+Notification.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (Notification)

- (void)addObserver {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification

- (void)didEnterBackground:(NSNotification *)notification {
    [self stopRecordVideo];
}

- (void)willResignActive:(NSNotification *)notification {
    [self stopRecordVideo];
}

@end

#pragma clang diagnostic pop
