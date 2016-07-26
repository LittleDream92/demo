//
//  DKChooseCarViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKChooseCarViewController.h"
#import "DKBrandTableViewController.h"
#import "DKCondationViewController.h"
#import "CustomButtonView.h"

@interface DKChooseCarViewController ()<CustomButtonProtocol, UIScrollViewDelegate>
{
    BOOL _index;
}
@property (nonatomic, strong) CustomButtonView *titleView;
@property (nonatomic,  weak) UIButton *seletedBtn;
@property (nonatomic,strong) UIScrollView *scrollview;

@end

@implementation DKChooseCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选车";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav:YES];
    
    self.titleView = [[CustomButtonView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    [self.view addSubview:self.titleView];
    self.titleView.myDelegate = self;
    [self.titleView createWithImgNameArr:nil selectImgNameArr:nil buttonW:kScreenWidth/2];
    NSArray *titles = @[@"品牌选车", @"条件选车"];
    [self.titleView _initButtonViewWithMenuArr:titles
                                     textColor:TEXTCOLOR
                               selectTextColor:ITEMCOLOR
                                fontSizeNumber:16
                                      needLine:YES];
    [self.view addSubview:self.scrollview];
    [self setupChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - set up views
//设置子控制器
-(void)setupChildViewControllers {
    DKBrandTableViewController *brandVC = [[DKBrandTableViewController alloc] init];
    [self addChildViewController:brandVC];
    brandVC.cityidString = self.cityidString;
    [self.scrollview addSubview:brandVC.view];
    brandVC.view.frame = CGRectMake(0, 0, kScreenWidth, self.scrollview.height);

    DKCondationViewController *condationVC = [[DKCondationViewController alloc] init];
    [self addChildViewController:condationVC];
    condationVC.cityidString = self.cityidString;
    [self.scrollview addSubview:condationVC.view];
    condationVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.scrollview.height);
}

#pragma mark - UIScrollViewDelegate
//滚动减速时
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //点击titleView按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self.titleView scrolledWithIndex:index];
    
}

#pragma mark - click action
//代理协议
-(void)getTag:(NSInteger)tag {
    _index = tag - 1501;
    
    CGPoint offset = self.scrollview.contentOffset;
    offset.x = _index * self.scrollview.width;
    [self.scrollview setContentOffset:offset animated:YES];
}


- (UIScrollView *)scrollview{
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc]init];
        _scrollview.frame = CGRectMake(0, self.titleView.bottom, kScreenWidth, kScreenHeight-64-self.titleView.height);
        
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.delegate = self;
        _scrollview.pagingEnabled = YES;//分页
        _scrollview.contentSize = CGSizeMake(_scrollview.width * 2, 0);
        
    }
    return _scrollview;
}

@end
