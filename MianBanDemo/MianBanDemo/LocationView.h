//
//  LocationView.h
//  MianBanDemo
//
//  Created by Meng Fan on 16/7/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString *faceName);

@interface LocationView : UIView

@property (nonatomic, copy) SelectedBlock block;

//block的调用
- (void)returnText:(SelectedBlock)block;

- (void)show;
- (void)hidden;

@end
