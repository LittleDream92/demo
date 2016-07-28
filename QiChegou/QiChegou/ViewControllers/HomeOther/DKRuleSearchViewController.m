//
//  DKRuleSearchViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/22.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKRuleSearchViewController.h"
#import "DKBreakRuleViewController.h"
#import "RuleCarsCell.h"
#import "DKRuleViewController.h"
#import "DKLoginViewController.h"
#import "HomeModel.h"

static NSString *cellID = @"breakRuleCarCellID";
@interface DKRuleSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *carTableView;

@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;


@property (nonatomic, assign) BOOL isOperation;

//数据源
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DKRuleSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违章查询";
    [self setUpNav:YES];
    
    [self setUpViews];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpViews {
    self.carTableView.backgroundColor = BGCOLOR;
//    self.carTableView.rowHeight = 80;
    //注册单元格
    [self.carTableView registerNib:[UINib nibWithNibName:@"RuleCarsCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    self.carTableView.tableFooterView = [UIView new];
    
    //button
    self.addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    self.editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.carTableView addGestureRecognizer:tapG];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isOperation = NO;
    [self.carTableView reloadData];
}


#pragma mark - button Action
- (IBAction)addCar:(id)sender {
//    DKBreakRuleViewController *vc = [[UIStoryboard storyboardWithName:@"HomeOther" bundle:nil] instantiateViewControllerWithIdentifier:@"DKBreakRuleViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
    self.isOperation = NO;
    [self.carTableView reloadData];
}

- (IBAction)editAction:(id)sender {
    self.isOperation = YES;
    [self.carTableView reloadData];
}

- (void)changeAction:(UIButton *)sender {
    NSLog(@"change");
}

- (void)deleteAction:(UIButton *)sender {
    NSLog(@"确定删除爱车信息吗？");
    
//    NSLog(@"%ld", sender.tag - 500);
    [HttpTool deleteCarWithID:[NSString stringWithFormat:@"%ld",sender.tag-500] block:^(BOOL result) {
        if (result) {
            [PromtView showAlert:@"删除爱车成功" duration:1.5];
        }
//        self.isOperation = NO;
        [self requestData];
    }];
    
//    [self.carTableView reloadData];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    self.isOperation = NO;
    [self.carTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RuleCarsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    cell.deleteBtn.tag = 500 + indexPath.row;
    [cell.changeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isOperation) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.deleteBtn.hidden = NO;
        cell.changeBtn.hidden = NO;
        cell.countBtn.hidden = YES;
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.deleteBtn.hidden = YES;
        cell.changeBtn.hidden = YES;
        cell.countBtn.hidden = NO;
    }
    
    HomeModel *model = self.dataArray[indexPath.row];
    cell.homeModel = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isOperation) {
//        NSDictionary *dic = self.dataArray[indexPath.row];
//        
//        DKRuleViewController *detailVC = [[UIStoryboard storyboardWithName:@"HomeOther" bundle:nil] instantiateViewControllerWithIdentifier:@"DKRuleViewController"];
//        detailVC.title = dic[@"chepai"];
//        detailVC.chepai = dic[@"chepai"];
//        detailVC.type = [NSString stringWithFormat:@"%d", 1];
////        detailVC.cityCode = self.cityCode;
////        detailVC.engine = fadongjiStr;
//        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - requestData
- (void)requestData {
    if (![AppDelegate APP].user) {
        NSLog(@"你还没有登录呢!");
//        //login
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还未登录，去登录？" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            NSLog(@"取消");
//        }];
//        
//        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            DKLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"DKLoginViewController"];
//            [self presentViewController:loginVC animated:YES completion:nil];
//        }];
//        
//        [alertController addAction:cancelAction];
//        [alertController addAction:otherAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        [HttpTool requestMyCarBlock:^(id json, BOOL result) {
            
            NSLog(@"result:%d", result);
            if (!result) {
                NSLog(@"noCar");
                self.text1.hidden = NO;
                self.text2.hidden = NO;
                self.carTableView.hidden = YES;
            }else {
                NSLog(@"have car");
                self.dataArray = json;
                self.text1.hidden = YES;
                self.text2.hidden = YES;
                self.carTableView.hidden = NO;
                [self.carTableView reloadData];
            }
        }];
    }
}


@end
