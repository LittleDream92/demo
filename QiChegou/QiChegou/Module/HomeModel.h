//
//  HomeModel.h
//  QiChegou
//
//  Created by Meng Fan on 16/7/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"
#import "CityDetailModel.h"

@interface HomeModel : BaseModel


/*
 brand_id:	品牌ID
 brand_name:	品牌名称
 first_letter:	品牌大写首字母
 thumb:		品牌LOGO图片
 */
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *brand_name;
@property (nonatomic, copy) NSString *first_letter;
@property (nonatomic, copy) NSString *thumb;

/*
 model_id:	类型ID
 model_name:	类型名称，例如SUV
 */
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *model_name;

/*
 color:		颜色描述
 thumb_lg：	大的缩略图
 thumb_sm:	小的缩略图*/
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *thumb_lg;
@property (nonatomic, copy) NSString *thumb_sm;


/*
 car_id:		车型ID
 pro_subject：	车系名称
 year:			车型年份
 car_subject：	车型名称
 main_photo：	车型图片*/
@property (nonatomic, copy) NSString *car_id;
@property (nonatomic, copy) NSString *pro_subject;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *car_subject;
@property (nonatomic, copy) NSString *main_photo;


/* 违章行为 */
@property (nonatomic, copy) NSString *act;
/* 违章地点 */
@property (nonatomic, copy) NSString *area;
/* 违章代码 */
@property (nonatomic, copy) NSString *code;
/* 违章时间 */
@property (nonatomic, copy) NSString *date;
/* 违章扣分 */
@property (nonatomic, copy) NSString *fen;
/* 违章罚款 */
@property (nonatomic, copy) NSString *money;
/* 违章处理状态 0未处理 1已处理 */
@property (nonatomic, copy) NSString *handled;
///* 违章总分 */
//@property (nonatomic, assign) NSInteger totalFen;
///* 违章总钱数 */
//@property (nonatomic, assign) NSInteger totalMoney;


/*
 province:		省份名称
 province_code:	省份代码
 */

/* 省份代码 */
@property (nonatomic, copy) NSString *province_code;
/* 省份名称 */
@property (nonatomic, copy) NSString *province;

@property (nonatomic, strong) NSArray *cityArray;

/*
 id: 		ID
 chepai:	 	车牌
 koufen:		扣分
 fakuan:		罚款
 count:		违章记录数
 */

@property (nonatomic, copy) NSString *rule_ID;
@property (nonatomic, copy) NSString *rule_pai;
@property (nonatomic, copy) NSString *rule_fen;
@property (nonatomic, copy) NSString *rule_money;
@property (nonatomic, copy) NSString *rule_count;

@end
