//
//  CityViewController.h
//  CityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString *cityName, NSString *cityCode);

@interface CityViewController : UIViewController


@property (nonatomic, copy) SelectedBlock block;

//block的调用
- (void)returnText:(SelectedBlock)block;


@end
