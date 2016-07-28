//
//  WeatherView.h
//  QiChegou
//
//  Created by Meng Fan on 16/7/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"

@interface WeatherView : UIView


- (void)setUpViewWithData:(WeatherModel *)model;

@end
