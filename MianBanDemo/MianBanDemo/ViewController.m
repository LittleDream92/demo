//
//  ViewController.m
//  MianBanDemo
//
//  Created by Meng Fan on 16/7/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ViewController.h"
#import "LocationView.h"


@interface ViewController ()
{
    UIButton *clickBtn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(50, 100, 100, 50);
    [clickBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [clickBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickBtn];
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)choose:(UIButton *)sender {
    LocationView *view = [[LocationView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
//    view.backgroundColor = [UIColor colorWithRed:51 green:51 blue:51 alpha:1];
    [self.view addSubview:view];
    [view returnText:^(NSString *faceName) {
        NSLog(@"selected:%@", faceName);
        [clickBtn setTitle:faceName forState:UIControlStateNormal];
    }];
//    [self.view insertSubview:view atIndex:0];
}

@end
