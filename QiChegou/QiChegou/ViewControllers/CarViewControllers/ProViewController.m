//
//  ProViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ProViewController.h"
#import "CarProTableViewCell.h"
#import "ListViewController.h"

@interface ProViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择车系";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav:YES];
    [self setClose:YES];
    
    [self setUpViews];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 100;
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - tableview dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarProTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CarProTableViewCell" owner:self options:nil] lastObject];
    
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ListViewController *listVC = [[ListViewController alloc] init];
    CarModel *model = self.dataArr[indexPath.row];
    listVC.title = [NSString stringWithFormat:@"%@%@", self.bid_name, model.pro_subject];
    listVC.pid = model.pro_id;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - requestData
- (void)requestData {
    [HttpTool requestPidCarWithbid:self.bid block:^(id json) {
        if (json != nil) {
            self.dataArr = json;
            [self.tableView reloadData];
        }
    }];
}

@end
