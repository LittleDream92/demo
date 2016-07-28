//
//  DKActivityViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/6.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKActivityViewController.h"

@interface DKActivityViewController ()

@end

@implementation DKActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    UIButton *alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alipayBtn.frame = CGRectMake(100, 100, 100, 100);
    alipayBtn.backgroundColor = [UIColor cyanColor];
    [alipayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alipayBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)btnAction:(UIButton *)sender {
    
}

@end
