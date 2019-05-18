//
//  SCCapturingModeSwitchView.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/18.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCCapturingModeSwitchType) {
    SCCapturingModeSwitchTypeImage,
    SCCapturingModeSwitchTypeVideo
};

@class SCCapturingModeSwitchView;

@protocol SCCapturingModeSwitchViewDelegate <NSObject>

- (void)capturingModeSwitchView:(SCCapturingModeSwitchView *)view
                didChangeToType:(SCCapturingModeSwitchType)type;

@end

@interface SCCapturingModeSwitchView : UIView

@property (nonatomic, assign, readonly) SCCapturingModeSwitchType type;

@property (nonatomic, weak) id <SCCapturingModeSwitchViewDelegate> delegate;

@end
