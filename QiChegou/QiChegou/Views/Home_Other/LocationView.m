//
//  LocationView.m
//  MianBanDemo
//
//  Created by Meng Fan on 16/7/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "LocationView.h"

#define kFace_Height (kFace_Width+20)
#define kFace_Width (kScreenWidth / 9.0)

//表情图片的宽和高
#define kItem_Width 30.0
#define kItem_Height 45.0

@interface LocationView ()
{
    UIView *localView;  //键盘View
}
@end

@implementation LocationView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        
        [self setUpViews];
        
    }
    return self;
}


- (void)setUpViews {
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    //取出文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"plist"];
    NSArray *location = [NSArray arrayWithContentsOfFile:filePath];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kFace_Height*4-84, kScreenWidth, kFace_Height*4+20)];
    view.backgroundColor = BGCOLOR;
    [self addSubview:view];
    
    int row = 0, colum = 0;
    
    for (int i = 0; i < location.count; i++) {
        
        //计算坐标
        CGFloat x = colum *kFace_Width + (kFace_Width - kItem_Width)/2;
        CGFloat y = row * kFace_Height + (kFace_Height - kItem_Height)/2 + 10;
        
        colum++;
        if (colum == 9) {
            row++;
            colum = 0;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, kItem_Width, kItem_Height);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:location[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(locationBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        //button圆角
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
    }
}

- (void)locationBtn:(UIButton *)sender {

    if (self.block != nil) {
        self.block(sender.titleLabel.text);
    }
    [self hidden];
}

- (void)returnString:(SuolueBlock)block {
    self.block = block;
}

- (void)show {
    self.hidden = NO;
}

- (void)hidden {
    self.hidden = YES;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self hidden];
}

@end
