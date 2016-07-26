//
//  DKBreakRuleViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBreakRuleViewController.h"
#import "DKRuleViewController.h"
#import "DataService.h"
#import "CityViewController.h"
#import "LocationView.h"
#import "CartypeView.h"
#import "DKRuleViewController.h"

@interface DKBreakRuleViewController ()
{
    LocationView *_suolueView;
    CartypeView *_typeView;
}
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *suolueBtn;

@property (weak, nonatomic) IBOutlet UITextField *chepaiTF;
@property (weak, nonatomic) IBOutlet UITextField *fadongjihaoTF;

/* 城市代码 */
@property (nonatomic, copy) NSString *cityCode;
/* 车牌号 */
@property (nonatomic, copy) NSString *licenceNumber;
/* 车辆类型 */
@property (nonatomic, assign) NSInteger type;

@end

@implementation DKBreakRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"违章查询";
    [self setUpNav:YES];
    [self setClose:YES];
    
    [self setUpViews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//触摸收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setUpViews {

    _suolueView = [[LocationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_suolueView];
    _suolueView.hidden = YES;
    
    _typeView = [[CartypeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:_typeView];
    _typeView.hidden = YES;
}

#pragma mark - button action
- (IBAction)cityAction:(id)sender {
    
    CityViewController *vc = [[CityViewController alloc] init];
    [vc returnText:^(NSString *cityName, NSString *cityCode) {
        NSLog(@"%@:%@", cityName, cityCode);
        self.cityCode = cityCode;
        [self.cityBtn setTitle:cityName forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)typeAction:(id)sender {
    _typeView.hidden = NO;
    [_typeView returnBlock:^(NSString *typeName, NSInteger type) {
        NSLog(@"%ld", type);
        self.type = type;
        [self.typeBtn setTitle:typeName forState:UIControlStateNormal];
    }];
}

- (IBAction)suolueAction:(id)sender {
    
    _suolueView.hidden = NO;
    [_suolueView returnString:^(NSString *string) {
        [self.suolueBtn setTitle:string forState:UIControlStateNormal];
    }];
}


#pragma mark - save and search Action
- (IBAction)saveAndSearchAction:(id)sender {

    //拿到输入的信息
    self.licenceNumber = [NSString stringWithFormat:@"%@%@", self.suolueBtn.titleLabel.text, self.chepaiTF.text];
    NSString *fadongjiStr = self.fadongjihaoTF.text;

    if (!self.cityCode) {
        NSLog(@"默认北京");
        self.cityCode = @"BJ";
    }
    
    if (!self.type) {
        self.type = 02;
    }
    
    if (!self.licenceNumber || self.licenceNumber.length <= 1 || self.suolueBtn.titleLabel.text.length <= 0) {
        NSLog(@"请输入车牌号码%@", self.suolueBtn.titleLabel.text);
        [PromtView showMessage:@"请输入车牌号码" duration:1.5];
        return;
    } else if (!fadongjiStr || [fadongjiStr length] <= 0) {
        NSLog(@"请输入发动机号");
        [PromtView showMessage:@"请输入发动机号" duration:1.5];
        return;
    } else  {
        
        [self save];
    
        DKRuleViewController *detailVC = [[UIStoryboard storyboardWithName:@"HomeOther" bundle:nil] instantiateViewControllerWithIdentifier:@"DKRuleViewController"];
        detailVC.title = self.licenceNumber;
        detailVC.chepai = self.licenceNumber;
        detailVC.type = [NSString stringWithFormat:@"%ld", self.type];
        detailVC.cityCode = self.cityCode;
        detailVC.engine = fadongjiStr;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (void)save {
    NSString *token = [AppDelegate APP].user.token;
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:token, @"token",
                                self.cityCode, @"city_code",
                                self.licenceNumber,@"chepai",
                                [NSString stringWithFormat:@"%ld", self.type],@"chepai_type",
                            self.fadongjihaoTF.text,@"fadongji",
                            @"1234567", @"chejiahao",nil];
    NSLog(@"params:%@", params);
    [HttpTool addCarWithParams:params block:^(BOOL result) {
    }];
}



@end
