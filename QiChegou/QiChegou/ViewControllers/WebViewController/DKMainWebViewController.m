//
//  DKMainWebViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/11.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKMainWebViewController.h"
#import "DataService.h"

@interface DKMainWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation DKMainWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    [self setUpNav:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpViews {
    //初始化web View
    self.webView = [UIWebView new];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (self.isRequest) {   // request htmlstring
        [self requestData];
    }else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webString]]];
    }
    
}

#pragma mark - 重写返回触发事件
- (void)backAction:(UIButton *)backCtrl {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - webView delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"webView error:%@", error);
    
    /*一个页面没有被完全加载之前收到下一个请求，此时迅速会出现此error,error=-999
     此时可能已经加载完成，则忽略此error，继续进行加载。
     http: //stackoverflow.com/questions/1024748/how-do-i-fix-nsurlerrordomain-error-999-in-iphone-3-0-os */
    if([error code] == NSURLErrorCancelled) {
        return;
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"list webView start load");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"list webView finish load");
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"type:%ld_list %@_%@",(long)navigationType,  request, [[request URL] absoluteString]);
    
    if ([self.title isEqualToString:@"新闻列表"] && navigationType == UIWebViewNavigationTypeLinkClicked) {
        DKMainWebViewController *webViewController = [[DKMainWebViewController alloc] init];
        webViewController.title = @"新闻详情";
        webViewController.webString = [[request URL] absoluteString];
        webViewController.isRequest = NO;
        [self.navigationController pushViewController:webViewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - requestData
- (void)requestData {

    [DataService request_post_html:self.webString
                            params:nil
                    completedBlock:^(id responseObject) {
                        
                        NSString *htmlStr = responseObject;
                        [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:URL_String]];
                        
                    } failure:^(NSError *error) {
                        NSLog(@"error:%@", error);
                    }];
    
}



@end
