//
//  CondationCollectionCell.h
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface CondationCollectionCell : UICollectionViewCell

//控件
@property (nonatomic, strong) UILabel *carLabel;
@property (nonatomic, strong) UIImageView *carImgView;


//@property (nonatomic, copy) NSString *index;

//数据源
@property (nonatomic, strong) HomeModel *condationModel;
@property (nonatomic, copy) NSString *imgNameStr;

//@property (nonatomic, copy) NSString *maxPrice;
//@property (nonatomic, copy) NSString *minPrice;

//@property (nonatomic, copy) NSString *str;

@end
