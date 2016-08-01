//
//  ViewController.m
//  ChooseCityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ViewController.h"
#import "MerchantView.h"

// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface ViewController ()
{
    UIView *_maskView;
    MerchantView *_merchantView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpViews];
    [self initMaskView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpViews {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor cyanColor];
    btn.frame = CGRectMake(0, 64, 100, 40);
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)initMaskView {
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+40, 375, 667-64-40)];
    _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self.view addSubview:_maskView];
    _maskView.hidden = YES;
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMaskView:)];
//    tap.delegate = self;
    [_maskView addGestureRecognizer:tap];
    

    _merchantView = [[MerchantView alloc] initWithFrame:CGRectMake(0, 0, 375, _maskView.frame.size.height-100)];
//    _merchantView.delegate = self;
    [_maskView addSubview:_merchantView];
}

- (void)btnAction:(UIButton *)sender {
    _maskView.hidden = NO;
}

-(void)OnTapMaskView:(UITapGestureRecognizer *)sender{
    _maskView.hidden = YES;
}

@end
