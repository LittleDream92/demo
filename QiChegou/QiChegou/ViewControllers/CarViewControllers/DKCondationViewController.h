//
//  DKCondationViewController.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface DKCondationViewController : BaseViewController

//参数
@property (nonatomic, copy) NSString *cityidString;

//条件视图数据源
@property (nonatomic, strong) NSArray *condationDataArr;

@end
