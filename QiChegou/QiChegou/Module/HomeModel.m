//
//  HomeModel.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

-(id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    if (self) {
        //
        
        NSArray *cityArray = jsonDic[@"citys"];
        if ([cityArray isKindOfClass:[NSArray class]] && cityArray.count > 0) {
            
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *cityDic in cityArray) {
                CityDetailModel *model = [[CityDetailModel alloc] initContentWithDic:cityDic];
                [mArr addObject:model];
            }
            self.cityArray = mArr;
        }
        
        self.rule_ID = [jsonDic objectForKey:@"id"];
        self.rule_pai = [jsonDic objectForKey:@"chepai"];
        self.rule_fen = [jsonDic objectForKey:@"koufen"];
        self.rule_money = [jsonDic objectForKey:@"fakuan"];
        self.rule_count = [jsonDic objectForKey:@"count"];
    }
    return self;
}


@end
