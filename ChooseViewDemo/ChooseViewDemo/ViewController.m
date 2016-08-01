//
//  ViewController.m
//  ChooseViewDemo
//
//  Created by Meng Fan on 16/7/22.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ViewController.h"
#import "CartypeView.h"

@interface ViewController ()
{
    CartypeView *typeView;
    UIButton *btn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 64, 100, 50);
    [btn setTitle:@"click me" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    typeView = [[CartypeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:typeView];
    typeView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction:(UIButton *)sender {
    typeView.hidden = NO;
    
    [typeView returnBlock:^(NSString *typeName, NSInteger type) {
        NSLog(@"%ld", type);
        [btn setTitle:typeName forState:UIControlStateNormal];
    }];
}

@end
