//
//  BaseViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/6.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseViewController.h"
#import "UIButton+Extension.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //**************方法一****************//
    //设置滑动回退
    __weak typeof(self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    //判断是否为第一个view
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark- UIGestureRecognizerDelegate
//**************方法一****************//
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpNav:(BOOL)back {
    if (back) {
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateHighlighted];
        [backBtn createButtonWithBGImgName:nil bghighlightImgName:nil titleStr:@"返回" fontSize:17];
        
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [backBtn sizeToFit];
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
}

- (void)setClose:(BOOL)close {
    if (close) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(0, 0, 44, 44);
        [closeBtn createButtonWithBGImgName:nil bghighlightImgName:nil titleStr:@"关闭" fontSize:17];
        [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    }
}

#pragma mark - Click Action Methods
//返回按钮触发事件
- (void)backAction:(UIButton *)backbtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeAction:(UIButton *)closeBtn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
