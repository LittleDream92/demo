//
//  DKChangePWDViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/8.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKChangePWDViewController.h"
#import "DKTextField.h"
#import "UIButton+Extension.h"
#import "DataService.h"

@interface DKChangePWDViewController ()
{
    __weak IBOutlet UIButton *_changeBtn;
}
@property (weak, nonatomic) IBOutlet DKTextField *telTF;
@property (weak, nonatomic) IBOutlet DKTextField *setPWD;
@property (weak, nonatomic) IBOutlet DKTextField *reNewPwdTF;
@property (weak, nonatomic) IBOutlet DKTextField *codeTF;

@end

@implementation DKChangePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重置密码";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateHighlighted];
    [backBtn createButtonWithBGImgName:nil bghighlightImgName:nil titleStr:@"返回" fontSize:17];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.telTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tel"]];
    self.telTF.leftViewMode = UITextFieldViewModeAlways;
    self.setPWD.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.setPWD.leftViewMode = UITextFieldViewModeAlways;
    self.reNewPwdTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.reNewPwdTF.leftViewMode = UITextFieldViewModeAlways;
    self.codeTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_code"]];
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Click Action Methods
//返回按钮触发事件
- (void)backAction:(UIButton *)backCtrl {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - button methods
- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 30:
        {
            NSLog(@"获取验证码");
            [self codeJudgebtn:sender];
            break;
        }
        case 31:
        {
            NSLog(@"确认修改");
            [self changePWDJudge];
            break;
        }
        case 32:
        {
            NSLog(@"直接登录");
            
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - judge if it‘s null
- (void)changePWDJudge {

    if (_telTF.text.length == 0) {
        
        NSLog(@"手机号不能为空！");
        [PromtView showAlert:@"手机号不能为空!" duration:1.5];
    }else if (_codeTF.text.length == 0) {
        
        NSLog(@"验证码不能为空！");
        [PromtView showAlert:@"验证码不能为空！" duration:1.5];
    }else if (self.setPWD.text.length == 0) {
        
        NSLog(@"新密码不能为空！");
        [PromtView showAlert:@"新密码不能为空！" duration:1.5];
    }else if (![_reNewPwdTF.text isEqualToString:self.setPWD.text]) {
        
        NSLog(@"两次密码不一致");
        [PromtView showAlert:@"两次密码不一致！" duration:1.5];
    }else {
        [self changePwdAction];
    }
}

- (void)codeJudgebtn:(UIButton *)button {
    if (_telTF.text.length == 11) {
        [button timerStartWithText:@"获取验证码"];
        [button http_requestForCodeWithParams:_telTF.text];
    }else if (_telTF.text.length == 0) {
        NSLog(@"手机号不能为空！");
        [PromtView showAlert:@"手机号不能为空！" duration:1.5];
    }else {
        NSLog(@"手机号格式错误");
        [PromtView showAlert:@"手机号格式错误" duration:1.5];
    }
}

#pragma mark - 网络请求
- (void)changePwdAction {

    NSString *randomString = [BaseFunction ret32bitString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", [BaseFunction getTimeSp]];
    NSString *md5String = [[BaseFunction md5Digest:[NSString stringWithFormat:@"%@%@%@", timeSp, randomString, APPSIGN]] uppercaseString];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:randomString,@"nonce_str",
                            timeSp, @"time",
                         md5String, @"sign",
                       _telTF.text,@"tel",
                      _codeTF.text, @"code",
                  self.setPWD.text, @"pass", nil];
    
    [DataService http_Post:RESET_PWD
                parameters:params
                   success:^(id responseObject) {
                       
                       NSLog(@"reset pwd:%@-%@", responseObject, [responseObject objectForKey:@"msg"]);
                       
                       NSDictionary *jsonDic = responseObject;
                       if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
                           //请求成功
                           NSLog(@"修改密码成功！");
                           [self dismissViewControllerAnimated:YES completion:nil];
                           
                       }else {
                           //提示修改密码失败
                           [PromtView showAlert:@"密码修改失败!" duration:1.5];
                       }
                       
                   } failure:^(NSError *error) {
                       NSLog(@"请求修改密码失败！error:%@", error);
                       [PromtView showAlert:PromptWord duration:1.5];
                   }];
}

#pragma mark - keyBoard methods
- (IBAction)view_touchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (IBAction)telTextField_DidEndExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [_codeTF becomeFirstResponder];
}

- (IBAction)codeTextField_DidEndOnExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [self.setPWD becomeFirstResponder];
}

- (IBAction)newPwd_DidEndOnExit:(id)sender {
    
    // 将焦点移至下一个文本框.
    [_reNewPwdTF becomeFirstResponder];
}

- (IBAction)reNewPwd_DidEndOnExit:(id)sender {
    
    // 隐藏键盘.
    [sender resignFirstResponder];
    
    // 触发登陆按钮的点击事件.
//    [_changeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}


@end
