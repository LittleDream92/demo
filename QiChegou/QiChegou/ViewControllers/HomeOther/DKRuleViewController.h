//
//  DKRuleViewController.h
//  QiChegou
//
//  Created by Meng Fan on 16/7/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface DKRuleViewController : BaseViewController

//查询所需要的参数
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *engine;
@property (nonatomic, copy) NSString *chepai;
@property (nonatomic, copy) NSString *type;

@end
