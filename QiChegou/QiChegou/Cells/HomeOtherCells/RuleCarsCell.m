//
//  RuleCarsCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/25.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "RuleCarsCell.h"

@implementation RuleCarsCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHomeModel:(HomeModel *)homeModel {
    if (_homeModel != homeModel) {
        _homeModel = homeModel;
        
        self.deleteBtn.tag = [_homeModel.rule_ID integerValue] + 500;

        self.chepaiLabel.text = _homeModel.rule_pai;
        self.fen.text = [NSString stringWithFormat:@"%@", _homeModel.koufen];
        self.money.text = [NSString stringWithFormat:@"%@", _homeModel.fakuan];
        
        [self.countBtn setTitle:[NSString stringWithFormat:@"%@", _homeModel.rule_count] forState:UIControlStateNormal];
    }
}

@end
