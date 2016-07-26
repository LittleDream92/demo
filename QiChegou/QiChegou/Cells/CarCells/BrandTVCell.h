//
//  BrandTVCell.h
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/14.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface BrandTVCell : UITableViewCell
{
    UIImageView *iconImgView;

    UILabel *textLabel;
}

@property (nonatomic, strong) HomeModel *brandModel;

@end
