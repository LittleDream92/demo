//
//  CondationCollectionCell.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/13.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CondationCollectionCell.h"

@implementation CondationCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self createViews];
    }
    return self;
}

-(void)awakeFromNib
{
    [self createViews];
}

- (void)createViews
{
    self.carLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.carLabel.userInteractionEnabled = YES;
    self.carLabel.font = systemFont(12);
    self.carLabel.textColor = TEXTCOLOR;
    self.carLabel.tag = 1001;
    self.carLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.carLabel];
    
    self.carImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.carImgView.userInteractionEnabled = YES;
    
    [self.contentView addSubview:self.carImgView];
}

-(void)setCondationModel:(HomeModel *)condationModel
{
    if (_condationModel != condationModel) {
        _condationModel = condationModel;
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.condationModel) {

        self.carLabel.frame = CGRectMake(0, 15, kScreenWidth/2, 21);
        self.carLabel.text = self.condationModel.model_name;
        
        self.carImgView.frame = CGRectMake((kScreenWidth/2-100)/2, self.carLabel.bottom, 0, 0);
        self.carImgView.image = [UIImage imageNamed:self.imgNameStr];
        [self.carImgView sizeToFit];
    
    }
    
}

@end
