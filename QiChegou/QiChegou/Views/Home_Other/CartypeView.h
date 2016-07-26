//
//  CartypeView.h
//  ChooseViewDemo
//
//  Created by Meng Fan on 16/7/22.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^typeBlock)(NSString *typeName, NSInteger type);

@interface CartypeView : UIView

@property (nonatomic, copy) typeBlock block;

//调用
- (void)returnBlock:(typeBlock)block;

@end
