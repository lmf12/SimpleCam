//
//  SCCapturingButton.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCCapturingButton;

@protocol SCCapturingButtonDelegate <NSObject>

/**
 拍照按钮被点击
 */
- (void)capturingButtonDidClicked:(SCCapturingButton *)button;

@end

@interface SCCapturingButton : UIButton

@property (nonatomic, weak) id <SCCapturingButtonDelegate> delegate;

@end
