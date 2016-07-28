//
//  CityTableViewCell.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/22.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CityTableViewCell.h"

@implementation CityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.font = systemFont(14);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.textLabel.textColor = WHITEColor;
        self.contentView.backgroundColor = [UIColor orangeColor];
    } else {
        self.textLabel.textColor = GRAYCOLOR;
        self.contentView.backgroundColor = BGCOLOR;
    }
}


@end
