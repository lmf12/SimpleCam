//
//  SCCapturingButton.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮状态

 - SCCapturingButtonStateNormal: 默认
 - SCCapturingButtonStateRecording: 录制中
 */
typedef NS_ENUM(NSUInteger, SCCapturingButtonState) {
    SCCapturingButtonStateNormal,
    SCCapturingButtonStateRecording,
};

@class SCCapturingButton;

@protocol SCCapturingButtonDelegate <NSObject>

/**
 拍照按钮被点击
 */
- (void)capturingButtonDidClicked:(SCCapturingButton *)button;

@end

@interface SCCapturingButton : UIButton

@property (nonatomic, assign) SCCapturingButtonState capturingState;
@property (nonatomic, weak) id <SCCapturingButtonDelegate> delegate;

@end
