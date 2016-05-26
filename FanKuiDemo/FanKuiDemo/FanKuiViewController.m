//
//  FanKuiViewController.m
//  FanKuiDemo
//
//  Created by Meng Fan on 16/5/26.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "FanKuiViewController.h"

// 屏幕宽高
#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

@interface FanKuiViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgBg;
@property (weak, nonatomic) IBOutlet UIImageView *contactImgBg;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLengthLabel;


@end

@implementation FanKuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //把内容textview设为第一响应者
    [self.contentTextView becomeFirstResponder];
    
    //初始化完成按钮
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:223./255 green:223./255 blue:223./255 alpha:1];
    view.frame = CGRectMake(0, 0, 40, 30);
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(KWidth -60, 2, 50, 26);
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(finishEdited) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

    //键盘的附属视图
    self.contentTextView.inputAccessoryView = view;
    self.contactTextField.inputAccessoryView = view;
}

- (void)finishEdited{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendFeed:(id)sender {
    //发送意见
    [self.view endEditing:YES];
    
    NSString* aString = self.contentTextView.text;
    
    /*下面if的作用就是把输入的空格合并，防止用户全输入的是空格还能够发送*/
    if (aString) {
        aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
        aString = [aString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    if (!aString || [aString length] < 1) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"还没有写反馈内容呢！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if ([self.contentTextView.text length] > 200) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"反馈内容限制在200个字以内！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    NSLog(@"send");
    
    /*友盟统计：
     NSMutableDictionary* feedbackDict = [NSMutableDictionary dictionaryWithCapacity:2];
     [feedbackDict setObject:removeSpaceAndReturn(self.contentTextView.text) forKey:@"content"];
     NSString* contact = removeSpaceAndReturn(self.contactTextView.text);
     if (contact && [contact length] > 0) {
     [feedbackDict setObject:contact forKey:@"contact"];
     }
     UMFeedback *umFeedback = [UMFeedback sharedInstance];
     [umFeedback post:feedbackDict];
     */
    
    /*可以集成MMBProgressHUD，提示正在发送*/
}

/*友盟的代理方法
#pragma mark - UMFeedbackDataDelegate

- (void)getFinishedWithError: (NSError *)error {
    NSInteger textCount = 200 - [self.contentTextView.text length];
    self.navigationItem.rightBarButtonItem.enabled = (textCount >= 0 && textCount < 200);
    [MMBProgressHUD showMBNoticeWithText:@"网络异常,请稍后再试!" inView:self.inputView];
}

- (void)postFinishedWithError:(NSError *)error {
    [self.hud hide:NO];
    
    if (error) {
        NSInteger textCount = 200 - [self.contentTextView.text length];
        self.navigationItem.rightBarButtonItem.enabled = (textCount >= 0 && textCount < 200);
        
        [MMBProgressHUD showMBNoticeWithText:@"网络异常,请稍后再试!" inView:self.inputView];
    }
    else {
        [MMBProgressHUD showMBNoticeWithText:@"发送成功!" inView:self.inputView];
        [self performSelector:@selector(goBackButtonPressed:) withObject:nil afterDelay:1.0];
    }
}*/

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    //当内容发生变化时，调用的方法
    self.placeholderLabel.hidden = self.contentTextView.text.length > 0;
    
    //最大长度 － 已输入字符串的长度
    NSInteger textCount = 200 - [textView.text length];
    
    //有内容并且长度不超过200的时候可以发送
    self.navigationItem.rightBarButtonItem.enabled = (textCount >= 0 && textCount < 200);
    
    //剩余可输入的字符串长度
    self.textLengthLabel.text = [NSString stringWithFormat:@"%ld",textCount];
    if (textCount < 0) {
        self.textLengthLabel.textColor = [UIColor redColor];
    }
    else {
        self.textLengthLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    }
}

#pragma mark - touch methds
//点击页面上空余地方结束编辑状态
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//不明白为什么要写下边的scrollview的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
