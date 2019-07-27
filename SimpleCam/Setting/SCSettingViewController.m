//
//  SCSettingViewController.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/7/27.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCSettingViewController.h"

@interface SCSettingViewController ()

@end

@implementation SCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    [self commonInit];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Private

- (void)commonInit {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    [self setupCloseButton];
}

- (void)setupCloseButton {
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [closeButton setImage:[UIImage imageNamed:@"btn_close_black"] forState:UIControlStateNormal];
    [closeButton addTarget:self
                    action:@selector(closeAction:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - Action

- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
