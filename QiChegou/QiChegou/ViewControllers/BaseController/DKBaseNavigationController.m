//
//  DKBaseNavigationController.m
//  Qichegou
//
//  Created by Meng Fan on 16/3/15.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBaseNavigationController.h"

@interface DKBaseNavigationController ()

@end

@implementation DKBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏背景图片
    UIImage *image = [UIImage imageNamed:@"navBar"];
    UIGraphicsBeginImageContext(CGSizeMake(kScreenWidth, 64));
    [image drawInRect:CGRectMake(0, 0, kScreenWidth, 64)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //设置导航栏字体
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: systemFont(18)};
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//拦截push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //如果在控制器有设置，就可以让后面设置的按钮可以覆盖它
    [super pushViewController:viewController animated:animated];
}

- (void)backAction:(UIButton *)button {
    [self popViewControllerAnimated:YES];
}

@end
