//
//  HttpTool.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HttpTool.h"
#import "DataService.h"
#import "HomeModel.h"
#import "CarModel.h"
#import "WeatherModel.h"

@implementation HttpTool


//*******************  Home **************************
/*
 *  获取首页信息
 */
+ (void)requestHomeInfoWithParams:(NSDictionary *)params block:(void(^)(id json, BOOL result))block{
#warning params
//    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"40.0315917842",@"lat",
//                            @"116.4170289281",@"lon", nil];
    [DataService http_Post:@"/api/index/info" parameters:params success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            
            NSMutableArray *mWeatherArr = [NSMutableArray array];
            //weather
            NSDictionary *weatherDic = responseObject[@"datas"][@"weather"];
            NSArray *weatherArray = weatherDic[@"future"];
            
            //xianxing
            NSArray *xianxingArr = responseObject[@"datas"][@"xianxing"];
            
//            NSLog(@"%ld, %ld", [weatherArray count], [xianxingArr count]);
            NSInteger count = MIN([weatherArray count], [xianxingArr count]);
            for (int i = 0; i<count; i++) {
                NSDictionary *weatherDic = weatherArray[i];
                NSDictionary *xianxingDic = xianxingArr[i];
                NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:weatherDic];
                [mDic setValue:xianxingDic forKey:@"xianxing"];
//                NSLog(@"%@", mDic);
                [mWeatherArr addObject:mDic];
            }
//            NSLog(@"mWeatherArr:%@", mWeatherArr);
            
            
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *jsonDic in mWeatherArr) {
                WeatherModel *model = [[WeatherModel alloc] initContentWithDic:jsonDic];
                //youjia
                NSDictionary *youjiaDic = responseObject[@"datas"][@"youjia"];
                model.youjia = youjiaDic;
                [mArr addObject:model];
            }
//            NSLog(@"数据源:%@", mArr);
            block(mArr, YES);
            
        }else {
            NSLog(@"%@", responseObject[@"msg"]);
            [PromtView showAlert:responseObject[@"msg"] duration:1.5];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [PromtView showAlert:PromptWord duration:1.5];
    }];
}


/*
 *  获取品牌信息
 */
+ (void)requestBrandWithCityID:(NSString *)cityID block:(void(^)(id titles, id json))block {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:cityID, @"cityid", nil];
    
    [DataService http_Post:BRABD_LIST
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"brand :%@", responseObject);
                       if ([responseObject[@"status"] integerValue] == 1) {
                           NSArray *jsonArray = responseObject[@"brands"];

                           if ([jsonArray isKindOfClass:[NSArray class]] && jsonArray.count > 0) {
                               NSMutableDictionary *sectionDic = [NSMutableDictionary dictionary];
                               NSMutableArray *mArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in jsonArray) {
                                   HomeModel *model = [[HomeModel alloc] initContentWithDic:jsonDic];
                                   
                                   NSString *sectionTitle = model.first_letter;
                                   
                                   NSMutableArray *rowArray =[sectionDic objectForKey:sectionTitle];
                                   
                                   if (rowArray == nil) {
                                       [mArr addObject:sectionTitle];
                                       rowArray = [NSMutableArray array];
                                       [sectionDic setObject:rowArray forKey:model.first_letter];
                                   }
                                   
                                   [rowArray addObject:model];
                               }
                               
                               block(mArr, sectionDic);
                           }
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"brand error:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];

}

/*
 *  获取条件信息
 */
+ (void)requestCondationBlock:(void(^)(id json))block {
    [DataService http_Post:CONDATION
                parameters:nil
                   success:^(id responseObject) {
                       
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           //请求成功
                           NSArray *jsonArr = [responseObject objectForKey:@"models"];
                           
                           NSMutableArray *mArr = [NSMutableArray array];
                           for (NSDictionary *jsonDic in jsonArr) {
                               
                               HomeModel *condationModel = [[HomeModel alloc] initContentWithDic:jsonDic];
                               [mArr addObject:condationModel];
                           }
                           block(mArr);
                           
                       }else {
                           NSLog(@"msg:%@", [responseObject objectForKey:@"msg"]);
                           block(nil);
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"请求失败！:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];
}

+ (void)getCarNumbersWithCityID:(NSString *)cityid
                            min:(NSString *)min
                            max:(NSString *)max
                            mid:(NSString *)mid
                          block:(void(^)(id json))block {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:cityid ,@"cityid",
                            min,@"min",
                            max,@"max",
                            mid, @"mid",
                            @"1",@"iscount",nil];
    
    
    [DataService http_Post:CARLIST
                parameters:params
                   success:^(id responseObject) {
                       
                       NSLog(@"car list number:%@", responseObject);
                       NSString *total = [responseObject objectForKey:@"total"];
                       block(total);
                       
                   } failure:^(NSError *error) {
                       NSLog(@"%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];

}

/*
 *  车系选择页面的网络请求
 */
+ (void)requestPidCarWithbid:(NSString *)bid block:(void(^)(id json))block {
#warning cityID
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"6" ,@"cityid",
                            bid ,@"bid", nil];
    
    [DataService http_Post:CARPROS
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"pro list :%@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"products"];
                           NSMutableArray *mArr = [NSMutableArray array];
                           for (NSDictionary *jsonDic in jsonArr) {
                               CarModel *model = [[CarModel alloc] initContentWithDic:jsonDic];
                               [mArr addObject:model];
                           }
                           block(mArr);
                       }else {
                           block(nil);
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"pro list error:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];
}


/*
 *  车型列表数据请求
 */
+ (void)getCarListWithpid:(NSString *)pid
                 minPrice:(NSString *)min
                 maxPrice:(NSString *)max
                      mid:(NSString *)mid
                    block:(void(^)(id json))block {
#warning cityID
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cityid"] = @"6";
    
    if (pid.length == 0) {
        params[@"min"] = min;
        params[@"max"] = max;
        params[@"mid"] = mid;
    }else {
        params[@"pid"] = pid;
    }
    
    NSLog(@"params:%@", params);
    [DataService http_Post:CARLIST
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"list : %@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"cars"];
                           NSMutableArray *mArr = [NSMutableArray array];
                           for (NSDictionary *jsonDic in jsonArr) {
                               HomeModel *model = [[HomeModel alloc] initContentWithDic:jsonDic];
                               [mArr addObject:model];
                           }
                           block(mArr);
                       }else {
                           block(nil);
                       }
                   } failure:^(NSError *error) {
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];
}

/*
 *  车型列表数据请求 more
 */
+ (void)getMoreCarListWithpage:(NSInteger)page
                           pid:(NSString *)pid
                      minPrice:(NSString *)min
                      maxPrice:(NSString *)max
                           mid:(NSString *)mid
                         block:(void(^)(id json))block {
#warning cityID
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cityid"] = @"6";
    params[@"page"] = [NSString stringWithFormat:@"%ld", (long)page];
    
    if (pid.length == 0) {
        params[@"min"] = min;
        params[@"max"] = max;
        params[@"mid"] = mid;
    }else {
        params[@"pid"] = pid;
    }
    
    NSLog(@"params:%@", params);
    [DataService http_Post:CARLIST
                parameters:params
                   success:^(id responseObject) {
//                       NSLog(@"list : %@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"cars"];
                           if (jsonArr.count > 0) {
                               NSMutableArray *mArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in jsonArr) {
                                   HomeModel *model = [[HomeModel alloc] initContentWithDic:jsonDic];
                                   [mArr addObject:model];
                               }
                               block(mArr);
                           }else {
                               block(nil);
                           }
                       }else {
                           block(nil);
                       }
                   } failure:^( NSError *error) {
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];
}

/*
 *  详细选车页面－提交订单的前一页网络请求
 * cid: 车辆ID
 */
+ (void)requestOneCarWithCID:(NSString *)cid
                       block:(void(^)(id json))block {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid", nil];
    
    [DataService http_Post:DETAIL_CAR
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"one car success：%@", responseObject);
                       
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSDictionary *jsonDic = [responseObject objectForKey:@"car"];
                           
                           CarModel *detailModel = [[CarModel alloc] initContentWithDic:jsonDic];
                           block(detailModel);
                           
                       }else {
                           
                           NSLog(@"%@", [responseObject objectForKey:@"msg"]);
                           [PromtView showMessage:[responseObject objectForKey:@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       //
                       NSLog(@"one car errpr:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];

}


/*
 *  车型参数
 */
+ (void)requestParamsWithCID:(NSString *)carID
                       block:(void(^)(id json1, id json2, id json3))block {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:carID ,@"cid", nil];
    
    [DataService http_Post:PARAMSLIST
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"params success:%@", responseObject);
                       
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *responsArr = [responseObject objectForKey:@"params"];
                           
                           //处理参数
                           NSMutableArray *mArrTitle = [NSMutableArray array];
                           NSMutableArray *keyArray = [NSMutableArray array];
                           NSMutableArray *valueArray = [NSMutableArray array];
                           
                           for (NSDictionary *dic in responsArr) {
                               NSString *groupTitle = dic[@"group_name"];
                               [mArrTitle addObject:groupTitle];
                               
                               NSArray *keyValueArr = dic[@"params"];
                               NSMutableArray *keyArr = [NSMutableArray array];
                               NSMutableArray *valueArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in keyValueArr) {
                                   [keyArr addObject:jsonDic[@"param"]];
                                   [valueArr addObject:jsonDic[@"value"]];
                               }
                               
                               [keyArray addObject:keyArr];
                               [valueArray addObject:valueArr];
                           }
                           
                           NSLog(@"%@/n%@/n%@", mArrTitle, keyArray, valueArray);
                           block(mArrTitle, keyArray, valueArray);
                           
                       }else {
                           [PromtView showMessage:PromptWord duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       //
                       NSLog(@"params error:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];
}

/*
 *  车型图片
 */
+ (void)requestImagesWithCarID:(NSString *)carID
                         index:(NSInteger)index
                         block:(void(^)(id json , BOOL result))block {
    
//    NSLog(@"%ld", index);
    NSString *typeStr = [NSString stringWithFormat:@"%ld", index];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:carID ,@"cid",
                            typeStr ,@"type", nil];//type 1－4，不能为空，默认为1
    
    [DataService http_Post:IMGS
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"car images :%@", responseObject);
                       
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           NSArray *jsonArr = [responseObject objectForKey:@"images"];
                           if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count > 0) {
                               NSMutableArray *mArr = [NSMutableArray array];
                               for (NSDictionary *jsonDic in jsonArr) {
                                   
                                   HomeModel *model = [[HomeModel alloc] initContentWithDic:jsonDic];
                                   [mArr addObject:model];
                               }
                               block(mArr, YES);
                           }else {
                               [PromtView showMessage:@"暂无图片" duration:1.5];
                               block(NULL, NO);
                           }
                       }else {
                           [PromtView showMessage:@"加载图片失败" duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"car images error:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];
}

/*
 *  我的爱车
 */
+ (void)requestMyCarBlock:(void(^)(id json, BOOL result))block {
    NSString *token = [AppDelegate APP].user.token;
    NSLog(@"token:%@", token);
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:token, @"token", nil];
    
    [DataService http_Post:@"/api/AiChe/myCar"
                parameters:dic
                   success:^(id responseObject) {
                       NSLog(@"aiche :%@", responseObject);
                       if ([responseObject[@"status"] integerValue] == 1) {
                           
                           NSArray *dataArray = responseObject[@"datas"];
                           if ([dataArray isKindOfClass:[NSNull class]]) {
                               NSLog(@"null");
                           }
                           
                           if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count>0 && dataArray != NULL) {
                               
                               NSMutableArray *mArray = [NSMutableArray array];
                               NSLog(@"%@", dataArray);
                               for (NSDictionary *jsonDic in dataArray) {
                                   
                                   if (jsonDic == nil) {
                                       NSLog(@"jsonDic nil");
                                   }
                                   
                                   HomeModel *model = [[HomeModel alloc] initContentWithDic:jsonDic];
                                   [mArray addObject:model];
                               }
                               block(mArray, YES);
                               
                           }else {
                               block(@"", NO);
                           }
                           
                       }else {
                           [PromtView showMessage:responseObject[@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"aiche error:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];
}

/*
 *  添加爱车
 */
+ (void)addCarWithParams:(NSDictionary *)params block:(void(^)(BOOL result))block {
    
    [DataService http_Post:@"/api/AiChe/addCar"
                parameters:params
                   success:^(id responseObject) {
                       NSLog(@"add aiche :%@", responseObject);
                       if ([responseObject[@"status"] integerValue] == 1) {
                           [PromtView showMessage:@"保存爱车成功" duration:1.5];
                       }else {
                           [PromtView showMessage:responseObject[@"msg"] duration:1.5];
                       }
                   } failure:^(NSError *error) {
                       NSLog(@"add aiche error:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];
}

/*
 *  删除爱车
 */
+ (void)deleteCarWithID:(NSString *)idStr block:(void(^)(BOOL result))block {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[AppDelegate APP].user.token, @"token",
                            idStr, @"id", nil];
    
    [DataService http_Post:@"/api/AiChe/delete" parameters:params success:^(id responseObject) {
        NSLog(@"delete aiche:%@", responseObject);
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES);
        }else {
            block(NO);
            [PromtView showMessage:responseObject[@"msg"] duration:1.5];
        }
    } failure:^(NSError *error) {
        NSLog(@"delete aiche error:%@", error);
        [PromtView showMessage:PromptWord duration:1.5];
    }];
}


/*
 *  违章查询
 */
+ (void)requestBreakRuleWithParams:(NSDictionary *)params success:(void(^)(id json, BOOL result))block {

    [DataService http_Post:kSEARCHWEIZHANG
                parameters:params
                   success:^(id responseObject) {
//                       NSLog(@"break rule:%@, %@", responseObject, [responseObject objectForKey:@"msg"]);
                       
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           
                           NSArray *jsonArray = [responseObject objectForKey:@"datas"];
                           if ([jsonArray isKindOfClass:[NSArray class]] && jsonArray.count > 0) {
                               NSMutableArray *mArr = [NSMutableArray array];
//                               int sumFen = 0;
//                               int sumMoney = 0;
                               
                               for (NSDictionary *jsonDic in jsonArray) {
                                   HomeModel *model = [[HomeModel alloc] initContentWithDic:jsonDic];
                                   
//                                   //统计总计罚分和罚款
//                                   int scole = [[jsonDic objectForKey:@"fen"] intValue];
//                                   sumFen = sumFen + scole;
//                                   
//                                   int money = [[jsonDic objectForKey:@"money"] intValue];
//                                   sumMoney = sumMoney + money;
//                                   
//                                   model.totalFen = sumFen;
//                                   model.totalMoney = sumMoney;
                                   [mArr addObject:model];
                               }
                               
                               block(mArr, YES);
                           }else {
                               block(nil, NO);
                               
                           }
                       }else {
                           NSLog(@"%@", responseObject[@"msg"]);
                           [PromtView showMessage:responseObject[@"msg"] duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"break rule error:%@", error);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];

}


//*******************  MY ****************************
/*
 *  退出登录
 */
+ (void)requestLoginOutResult:(void(^)(BOOL result))block {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[AppDelegate APP].user.token,@"token", nil];
    [DataService http_Post:CANCEL_LOGIN
                parameters:params
                   success:^(id responseObject) {

                       NSLog(@"login out success:%@", responseObject);
                       if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                           block(YES);
                       }else {
                           block(NO);
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"login out error:%@", error);
                       block(NO);
                       [PromtView showMessage:PromptWord duration:1.5];
                   }];

}

/*
 *  我的活动列表页面
 */
+ (void)getMyActivityListBack:(void(^)(NSString *result))block {
    
}

/*
 *  我的订单列表信息
 *
 */
+ (void)requestMyOrderListWithToken:(NSString *)tokenString Back:(void(^)(id json, BOOL result))block {
    
}

@end
