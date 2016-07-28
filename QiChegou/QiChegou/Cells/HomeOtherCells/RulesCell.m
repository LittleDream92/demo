//
//  RulesCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/25.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "RulesCell.h"
#import "UILabel+Extension.h"

@interface RulesCell ()

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *action;
@property (weak, nonatomic) IBOutlet UILabel *fen;
@property (weak, nonatomic) IBOutlet UILabel *money;

@end

@implementation RulesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRuleModel:(HomeModel *)ruleModel {
    if (_ruleModel != ruleModel) {
        _ruleModel = ruleModel;
        
        self.location.text = _ruleModel.area;
        self.time.text = _ruleModel.date;
        self.action.text = _ruleModel.act;
        self.money.text = _ruleModel.money;
        self.fen.text = _ruleModel.fen;
    }
}

@end
