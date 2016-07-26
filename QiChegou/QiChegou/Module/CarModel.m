//
//  CarModel.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

-(id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    
    if (self) {
        //处理特殊数据
        
        NSLog(@"%@", jsonDic);
        NSArray *jsonArr = [jsonDic objectForKey:@"car_imgs"];
     
        if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count > 0) {
            NSMutableArray *mArr_text = [NSMutableArray array];
            NSMutableArray *mArr_img = [NSMutableArray array];
            for (NSDictionary *json in jsonArr) {
                [mArr_text addObject:[json objectForKey:@"color"]];
                [mArr_img addObject:[json objectForKey:@"img"]];
            }
            self.color_imgs = mArr_img;
            self.color_text = mArr_text;
        }
    }
    return self;
}

@end
