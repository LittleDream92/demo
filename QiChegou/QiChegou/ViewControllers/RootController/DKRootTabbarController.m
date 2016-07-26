//
//  DKRootTabbarController.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKRootTabbarController.h"
#import "DKHomeViewController.h"
#import "DKActivityViewController.h"
#import "DKMyViewController.h"
#import "DKBaseNavigationController.h"

@interface DKRootTabbarController ()

@end

@implementation DKRootTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.tabBar.backgroundColor = BGCOLOR;
    self.tabBar.translucent = NO;
    
    //初始化子控制器
    [self initialControllers];
}

//初始化子控制器
-(void)initialControllers {
    
    DKHomeViewController *homeVC = [[DKHomeViewController alloc] init];
    DKActivityViewController *activityVC = [[DKActivityViewController alloc] init];
    DKMyViewController *myVC = [[DKMyViewController alloc] init];
    
    [self setupController:homeVC image:@"home_icon_1" selectedImage:@"home_icon_2" title:@"首页"];
    [self setupController:activityVC image:@"acti_icon_1" selectedImage:@"acti_icon_2" title:@"活动"];
    [self setupController:myVC image:@"my_icon_1" selectedImage:@"my_icon_2" title:@"我的"];
}

//设置控制器
-(void)setupController:(UIViewController *)childVc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    
    UIViewController *viewVc = childVc;
    viewVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewVc.tabBarItem.title = title;
    DKBaseNavigationController *navi = [[DKBaseNavigationController alloc]initWithRootViewController:viewVc];
    [self addChildViewController:navi];
    
}


//先对tabbar做一些属性设置.这个initialize方法,只会走一次,所以我们把tabbar初始化的一些方法放在这里面
+(void)initialize{
    //通过apperance统一设置UITabBarItem的文字属性
    //后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = systemFont(10);
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAtts = [NSMutableDictionary dictionary];
    selectedAtts[NSFontAttributeName] = systemFont(10);
    selectedAtts[NSForegroundColorAttributeName] = ITEMCOLOR;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAtts forState:UIControlStateSelected];
}

@end
