//
//  BrandTVCell.m
//  DKQiCheGou
//
//  Created by Song Gao on 16/1/14.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BrandTVCell.h"
#import "UIImageView+WebCache.h"

@implementation BrandTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //
        [self createViews];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}


- (void)createViews
{
    iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 24, 24)];
    iconImgView.image = [UIImage imageNamed:@"bg_car_Brand"];
    [self.contentView addSubview:iconImgView];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImgView.right+15, 0, 100, 44)];
    textLabel.font = systemFont(16);
    textLabel.textColor = TEXTCOLOR;
    [self.contentView addSubview:textLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBrandModel:(HomeModel *)brandModel
{
    if (_brandModel != brandModel) {
        _brandModel = brandModel;
        
        [self setNeedsLayout];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.brandModel.thumb.length > 0) {
        [iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, self.brandModel.thumb]] placeholderImage:[UIImage imageNamed:@"bg_car_Brand"]];
    }
    
    textLabel.text = self.brandModel.brand_name;

}

@end
