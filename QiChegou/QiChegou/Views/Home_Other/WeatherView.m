//
//  WeatherView.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "WeatherView.h"

@interface WeatherView ()

@property (weak, nonatomic) IBOutlet UILabel *temper;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *weihao;
@property (weak, nonatomic) IBOutlet UILabel *xiche;
@property (weak, nonatomic) IBOutlet UILabel *oil1;
@property (weak, nonatomic) IBOutlet UILabel *oil2;
@property (weak, nonatomic) IBOutlet UILabel *oil3;


@end

@implementation WeatherView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)awakeFromNib {
    [self setUpViews];
}

- (void)setUpViews {
    
}

- (void)setUpViewWithData:(WeatherModel *)model {

    self.temper.text = model.wen_du;
    self.weatherLabel.text = model.weather;
    self.windLabel.text = model.wind;
    self.weihao.text = model.weihao;
    self.xiche.text = model.wash;
    
    NSLog(@"%@", model.youjia);
    NSDictionary *oilDic = model.youjia;
    NSArray *oilArr = [oilDic allKeys];
    if ([oilDic count] == 3) {
        self.oil1.text = [NSString stringWithFormat:@"%@  %@",oilArr[0], [oilDic objectForKey:oilArr[0]]];
        self.oil2.text = [NSString stringWithFormat:@"%@  %@",oilArr[1], [oilDic objectForKey:oilArr[1]]];
         self.oil3.text = [NSString stringWithFormat:@"%@  %@",oilArr[2], [oilDic objectForKey:oilArr[2]]];
    }else if (oilArr.count==2) {
        self.oil1.text = [NSString stringWithFormat:@"%@  %@",oilArr[0], [oilDic objectForKey:oilArr[0]]];
        self.oil2.text = nil;
        self.oil3.text = [NSString stringWithFormat:@"%@  %@",oilArr[1], [oilDic objectForKey:oilArr[1]]];
    }

}

@end
