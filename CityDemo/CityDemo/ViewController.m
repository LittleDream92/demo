//
//  ViewController.m
//  CityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ViewController.h"
#import "CityViewController.h"

// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define navigationBarColor RGB(33, 192, 174)
#define separaterColor RGB(200, 199, 204)


// 4.屏幕大小尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
{
    UIButton *btn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpViews {
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"请选择" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor cyanColor];
    btn.frame = CGRectMake(0, 64, 100, 40);
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnAction:(UIButton *)sender {
    
    CityViewController *vc = [[CityViewController alloc] init];
    [vc returnText:^(NSString *cityName, NSString *cityCode) {
        NSLog(@"%@:%@", cityName, cityCode);
        [btn setTitle:cityName forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
