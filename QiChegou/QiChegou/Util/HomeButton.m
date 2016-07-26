//
//  HomeButton.m
//  Qichegou
//
//  Created by Meng Fan on 16/6/1.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "HomeButton.h"
#import "UIButton+WebCache.h"

@implementation HomeButton

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

-(void)awakeFromNib {

}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isAtHome) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = systemFont(13);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //调整图片
        self.imageView.y = 5;
        self.imageView.width = 32;
        self.imageView.height = 30;
        self.imageView.x = (self.width - self.imageView.width)/2;
        
        //调整文字
        self.titleLabel.x = 0;
        self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
        self.titleLabel.width = self.width;
        self.titleLabel.height = self.height - self.titleLabel.y;
    }else {
        [self setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        self.titleLabel.font = systemFont(10);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    
        //调整图片
        self.imageView.y = 0;
        self.imageView.width = self.width-20;
        self.imageView.height = self.height *2/3;
        self.imageView.x = 10;
        
        //调整文字
        self.titleLabel.x = 0;
        self.titleLabel.y = self.imageView.bottom;
        self.titleLabel.width = self.width;
        self.titleLabel.height = self.height - self.imageView.height;
    }
    
}

- (void)setUpButtonWithImageName:(NSString *)imgName title:(NSString *)title {
//    NSLog(@"%@, %@", imgName, title);
    
    [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_String, imgName]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg_default"]];
    [self setTitle:title forState:UIControlStateNormal];
}

@end
