//
//  ProTableViewCell.m
//  CityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ProTableViewCell.h"

// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

@implementation ProTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initViews {
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor grayColor];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:self.frame];
    UIView *selectedIndicator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 43+1)];
    selectedIndicator.backgroundColor = RGB(219, 21, 26);
    [selectedView addSubview:selectedIndicator];
    self.selectedBackgroundView = selectedView;
    self.selectedBackgroundView.backgroundColor = RGB(245, 245, 245);
    
    self.textLabel.highlightedTextColor = RGB(219, 21, 26);
}

-(void)setModel:(Citymodel *)model {
    if (_model != model) {
        _model = model;
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.text = model.province;
    }
}

@end
