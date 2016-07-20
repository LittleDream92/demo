//
//  Citymodel.m
//  CityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "Citymodel.h"

@implementation Citymodel

-(id)initContentWithDic:(NSDictionary *)jsonDic {
    if (self = [super initContentWithDic:jsonDic]) {
        
        NSArray *cityArray = jsonDic[@"citys"];
        if ([cityArray isKindOfClass:[NSArray class]] && cityArray.count > 0) {
            
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *cityDic in cityArray) {
                CityDetailModel *model = [[CityDetailModel alloc] initContentWithDic:cityDic];
                [mArr addObject:model];
            }
            self.cityArray = mArr;
        }
    }
    return self;
}

@end
