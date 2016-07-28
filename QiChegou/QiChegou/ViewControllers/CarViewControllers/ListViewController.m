//
//  ListViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ListViewController.h"
#import "HomeModel.h"
#import "MJRefresh.h"
#import "CarListTableViewCell.h"
#import "DKDetailCarViewController.h"

static NSString *const cellID = @"carListCellID";
@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

/** 当前页码 */
@property (nonatomic, assign) NSInteger page;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view

    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav:YES];
    [self setClose:YES];
    
    [self setUpViews];
    [self setRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpViews {
    self.dataArr = [NSMutableArray array];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 80;
    self.tableView.pagingEnabled = YES;
    
    self.tableView.tableFooterView = [UIView new];

    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"CarListTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
}

- (void)setRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
}

#pragma mark - tableview dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.myModel = self.dataArr[indexPath.row];
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DKDetailCarViewController *carVC = [[DKDetailCarViewController alloc] init];
    HomeModel *model = self.dataArr[indexPath.row];
    carVC.cid = model.car_id;
    [self.navigationController pushViewController:carVC animated:YES];
}

#pragma mark - requestData
- (void)requestData {
    self.page = 1;
    //清空
    [self.dataArr removeAllObjects];
    
    [HttpTool getCarListWithpid:self.pid
                       minPrice:self.minPrice
                       maxPrice:self.maxPrice
                            mid:self.modelID
                          block:^(id json) {
                              if (json) {
                                  self.dataArr = json;
                                  [self.tableView reloadData];
                                  [self.tableView.mj_header endRefreshing];
                              }
                            }];
}


- (void)requestMoreData {
    
    self.page += 1;
    
    [HttpTool getMoreCarListWithpage:self.page
                                 pid:self.pid
                            minPrice:self.minPrice
                            maxPrice:self.maxPrice
                                 mid:self.modelID
                               block:^(id json) {
                                   NSArray *moreArr = json;
                                   if (moreArr) {
                                       [self.dataArr addObjectsFromArray:moreArr];
                                       [self.tableView reloadData];
                                   }else {
                                       [PromtView showMessage:@"加载完毕" duration:2];
                                   }
                                   [self.tableView.mj_footer endRefreshing];
                               }];
}


@end
