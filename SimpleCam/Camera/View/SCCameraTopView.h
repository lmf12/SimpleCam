//
//  SCCameraTopView.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/5/15.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCCameraTopView;

@protocol SCCameraTopViewDelegate <NSObject>

- (void)cameraTopViewDidClickRotateButton:(SCCameraTopView *)cameraTopView;

@end

@interface SCCameraTopView : UIView

@property (nonatomic, weak) id <SCCameraTopViewDelegate> delegate;

@end
