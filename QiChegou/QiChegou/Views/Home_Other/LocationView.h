//
//  LocationView.h
//  MianBanDemo
//
//  Created by Meng Fan on 16/7/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuolueBlock)(NSString *string);


@interface LocationView : UIView

@property (nonatomic, copy) SuolueBlock block;
//block的调用
- (void)returnString:(SuolueBlock)block;

- (void)show;
- (void)hidden;

@end
