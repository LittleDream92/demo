//
//  Citymodel.h
//  CityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"
#import "CityDetailModel.h"

@interface Citymodel : BaseModel

/* 
 province:		省份名称
 province_code:	省份代码
 */

/* 省份代码 */
@property (nonatomic, copy) NSString *province_code;
/* 省份名称 */
@property (nonatomic, copy) NSString *province;

@property (nonatomic, strong) NSArray *cityArray;

@end
