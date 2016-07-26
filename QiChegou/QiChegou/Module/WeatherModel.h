//
//  WeatherModel.h
//  HomeDemo
//
//  Created by Meng Fan on 16/7/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface WeatherModel : BaseModel

/* weather */

/* 日期 */
@property (nonatomic, copy) NSString *date;
/* 星期几 */
@property (nonatomic, copy) NSString *week;
/* 温度 */
@property (nonatomic, copy) NSString *wen_du;
/* 天气 */
@property (nonatomic, copy) NSString *weather;
/* 风 */
@property (nonatomic, copy) NSString *wind;
/* 洗车指数 */
@property (nonatomic, copy) NSString *wash;


/* 限行 */
/* 尾号 */
@property (nonatomic, copy) NSString *weihao;


/* 油价 */
@property (nonatomic, strong) NSDictionary *youjia;

@end
