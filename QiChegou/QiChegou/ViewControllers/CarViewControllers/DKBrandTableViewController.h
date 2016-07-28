//
//  DKBrandTableViewController.h
//  Qichegou
//
//  Created by Meng Fan on 16/4/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseViewController.h"

@interface DKBrandTableViewController : BaseViewController

//参数
@property (nonatomic, copy) NSString *cityidString;

//表视图数据源
@property (nonatomic, strong) NSArray *sectionTitleArr;
@property (nonatomic, strong) NSMutableDictionary *sectionDic;

@end
