//
//  DKBrandTableViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKBrandTableViewController.h"
#import "HomeModel.h"
#import "BrandTVCell.h"

#import "ProViewController.h"

static NSString *const cellID = @"brandTableViewCellID";
@interface DKBrandTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DKBrandTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-48) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 37;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //注册单元格
    [self.tableView registerClass:[BrandTVCell class] forCellReuseIdentifier:cellID];
    
    [self getNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sectionDic objectForKey:self.sectionTitleArr[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSString *sectionTitle = self.sectionTitleArr[indexPath.section];
    HomeModel *brandModel = [self.sectionDic objectForKey:sectionTitle][indexPath.row];

    cell.brandModel = brandModel;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionTitleArr;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
    sectionView.backgroundColor = kbgGrayColor;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 0, 21)];
    textLabel.font = systemFont(16);
    textLabel.textColor = GRAYCOLOR;
    textLabel.text = self.sectionTitleArr[section];
    [textLabel sizeToFit];
    [sectionView addSubview:textLabel];
    
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *sectionTitle = self.sectionTitleArr[indexPath.section];
    HomeModel *brandModel = [self.sectionDic objectForKey:sectionTitle][indexPath.row];
    
    //push进入选择车系的
    ProViewController *carProVC = [[ProViewController alloc] init];
    carProVC.bid = brandModel.brand_id;
    carProVC.bid_name = brandModel.brand_name;
    [self.navigationController pushViewController:carProVC animated:YES];
    
}


#pragma mark - getNewData
- (void)getNewData {
    [HttpTool requestBrandWithCityID:self.cityidString block:^(id titles, id json) {
        if (titles != nil) {
            self.sectionDic = json;
            self.sectionTitleArr = titles;
            [self.tableView reloadData];
        }
    }];
}

@end
