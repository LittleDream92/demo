//
//  HttpTool.h
//  QiChegou
//
//  Created by Meng Fan on 16/7/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

//*******************  Home **************************
/*
 *  获取首页信息
 */
+ (void)requestHomeInfoWithParams:(NSDictionary *)params block:(void(^)(id json, BOOL result))block;


/*
 *  获取品牌信息
 */
+ (void)requestBrandWithCityID:(NSString *)cityID block:(void(^)(id titles, id json))block;

/*
 *  获取条件信息
 */
+ (void)requestCondationBlock:(void(^)(id json))block;

/*
 *  获取有多少辆车
 */
+ (void)getCarNumbersWithCityID:(NSString *)cityid
                            min:(NSString *)min
                            max:(NSString *)max
                            mid:(NSString *)mid
                          block:(void(^)(id json))block;

/*
 *  车系选择页面的网络请求
 */
+ (void)requestPidCarWithbid:(NSString *)bid block:(void(^)(id json))block;

/*
 *  车型列表数据请求
 */
+ (void)getCarListWithpid:(NSString *)pid
                 minPrice:(NSString *)min
                 maxPrice:(NSString *)max
                      mid:(NSString *)mid
                    block:(void(^)(id json))block;

/*
 *  车型列表数据请求 more
 */
+ (void)getMoreCarListWithpage:(NSInteger)page
                           pid:(NSString *)pid
                      minPrice:(NSString *)min
                      maxPrice:(NSString *)max
                           mid:(NSString *)mid
                         block:(void(^)(id json))block;

/*
 *  详细选车页面－提交订单的前一页网络请求
 * cid: 车辆ID
 */
+ (void)requestOneCarWithCID:(NSString *)cid
                       block:(void(^)(id json))block;

/*
 *  车型参数
 */
+ (void)requestParamsWithCID:(NSString *)carID
                       block:(void(^)(id json1, id json2, id json3))block;

/*
 *  车型图片
 */
+ (void)requestImagesWithCarID:(NSString *)carID
                         index:(NSInteger)index
                         block:(void(^)(id json , BOOL result))block;

/*
 *  我的爱车
 */
+ (void)requestMyCarBlock:(void(^)(id json, BOOL result))block;


/*
 *  添加爱车
 */
+ (void)addCarWithParams:(NSDictionary *)params block:(void(^)(BOOL result))block;

/* 
 *  删除爱车
 */
+ (void)deleteCarWithID:(NSString *)idStr block:(void(^)(BOOL result))block;

/*  
 *  违章查询
 */
+ (void)requestBreakRuleWithParams:(NSDictionary *)params success:(void(^)(id json, BOOL result))block;


//*******************  MY ****************************
/*
 *  退出登录
 */
+ (void)requestLoginOutResult:(void(^)(BOOL result))block;

/*
 *  我的活动列表页面
 */
+ (void)getMyActivityListBack:(void(^)(NSString *result))block;

/*
 *  我的订单列表信息
 *
 */
+ (void)requestMyOrderListWithToken:(NSString *)tokenString Back:(void(^)(id json, BOOL result))block;

@end
