//
//  Configure.h
//  QiChegou
//
//  Created by Meng Fan on 16/7/6.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#ifndef Configure_h
#define Configure_h

/**
 *  4.弱引用
 */
#define STWeakSelf __weak typeof(self) weakSelf = self;

#define DefaultAnimationDuration 0.2
#define PromptWord @"网络开小差了，稍后试试吧"

//HUD
#define HUD_DELAY 1.5

//>>>>>>>
#define RGBA(r,g,b,a)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define ITEMCOLOR       RGB(255, 96, 0)         //#ff6000
#define WHITEColor       RGB(255, 255, 255)
#define BGCOLOR         RGB(244, 244, 244)      //F4F4F4
#define kbgGrayColor    RGB(240, 240, 240)
#define TEXTCOLOR       RGB(51, 51, 51)         //#333333
#define GRAYCOLOR       RGB(170, 170, 170)      //#aaaaaa

//屏幕宽高
#define kScreenWidth          [UIScreen mainScreen].bounds.size.width
#define kScreenHeight         [UIScreen mainScreen].bounds.size.height
#define kWidthScale           (kScreenWidth / 375.0)
#define kHeightScale          (kScreenHeight / 667.0)

//字体大小
#define systemFont(size)      [UIFont systemFontOfSize:size]

// common
#define UserDefaults          [NSUserDefaults standardUserDefaults]
#define NotificationCenters   [NSNotificationCenter defaultCenter]

#import "Masonry.h"
#import "AFNetworking.h"
#import "HttpTool.h"
#import "BaseFunction.h"
#import "AppDelegate.h"
#import "UIViewExt.h"
#import "PromtView.h"
#import "UIView+Extension.h"

//notification
#define kLatestLook @"LatestLookCar"

//签名密钥
#define APPSIGN @"BFB4A88E2341FB39F1C7B794341A86D4"

#define LOGIN_SUCCESS @"loginSuccess_result"
//base url
#define URL_String @"http://test.tangxinzhuan.com"

//违章查询
#define kSEARCHWEIZHANG @"/api/WeiZhang/search"
//退出登录
#define CANCEL_LOGIN @"/api/user/logout"
//验证码／密码登录
#define kLOGIN @"/api/user/login"
//用户信息
#define USER_INFORMATION @"/api/user/getUserInfo"
//注册
#define REGIST @"/api/user/register"
//重置密码
#define RESET_PWD @"/api/user/findpass"
#define NEWSLIST @"/api/news/lists"
//**************************** 车辆模块 *****************************
////特价车型
//#define SALECAR_MODEL @"/api/car/tejiache"
////热销车型
//#define HOTCAR_MODEL @"/api/car/rexiaoche"

#define CONDATION @"/api/car/models"        //条件选车
#define BRABD_LIST @"/api/car/brands"       //品牌选车
#define CARLIST @"/api/car/cars"            //车型列表
#define CARPROS @"/api/car/pros"            //车系列表
#define DETAIL_CAR @"/api/car/car"          //具体车型
#define IMGS @"/api/car/images"             //车型图片
//车辆参数
#define PARAMSLIST @"/api/car/params"
//外观颜色
#define CHOOSE_COLOR @"/api/car/getcolors"

#endif /* Configure_h */
