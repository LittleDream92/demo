//
//  AppDelegate.h
//  QiChegou
//
//  Created by Meng Fan on 16/7/6.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModule.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UserModule *user;
+ (AppDelegate *)APP;

@end

