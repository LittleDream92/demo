//
//  ErWeiMaViewController.m
//  ErWeiMaDemo
//
//  Created by Meng Fan on 16/8/2.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ErWeiMaViewController.h"
#import "MBProgressHUD.h"

@interface ErWeiMaViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation ErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
     NSLog(@"self.myUrl:%@", self.myUrl);
    [self loadTheString];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (void)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _webView;
}


- (void)loadTheString {
    
    self.webView.delegate = self;
    self.hud = [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    self.hud.labelText = @"loading..";
    
    self.webView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;
    
    if ([self.myUrl hasPrefix:@"http://"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.myUrl]];
        [self.webView loadRequest:request];
    }else {
        [self.webView loadHTMLString:[NSString stringWithFormat:@"<span style=\"font-size:40px;\"><span style=\"color:#000000;\">%@</span></span></span>", self.myUrl] baseURL:nil];
    }
    
    if ([[NSURL URLWithString:self.myUrl] checkResourceIsReachableAndReturnError:nil]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.myUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [self.webView loadRequest:request];
    }
}

#pragma mark - delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //超过10s没有响应,或者请求失败
    [self requestFailed];
    [self.hud hide:YES];
}
///请求失败
- (void)requestFailed {
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 30)];
    myView.backgroundColor = [UIColor darkGrayColor];
    myView.alpha = 0;
    UILabel *mylable = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, [UIScreen mainScreen].bounds.size.width - 60, 20)];
    mylable.text = @"网络连接失败,请检测网络设置.";
    mylable.textColor = [UIColor whiteColor];
    mylable.font = [UIFont systemFontOfSize:15];
    mylable.textAlignment = NSTextAlignmentCenter;
    [myView addSubview:mylable];
    [self.view addSubview:myView];
    [UIView animateWithDuration:1 animations:^{
        myView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            myView.alpha = 0;
        }];
    }];
}

@end
