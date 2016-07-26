//
//  WeatherModel.m
//  HomeDemo
//
//  Created by Meng Fan on 16/7/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

-(id)initContentWithDic:(NSDictionary *)jsonDic {
    self = [super initContentWithDic:jsonDic];
    if (self) {
        
        NSDictionary *xianxingDic = jsonDic[@"xianxing"];
        NSArray *weihao = xianxingDic[@"weihao"];
        if ([weihao isKindOfClass:[NSArray class]] && [weihao count]>0) {
            self.weihao = [weihao componentsJoinedByString:@"和"];
        }else {
            self.weihao = @"无";
        }
    }
    return self;
}


@end
