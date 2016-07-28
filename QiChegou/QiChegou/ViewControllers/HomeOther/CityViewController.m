//
//  CityViewController.m
//  CityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CityViewController.h"
#import "DataService.h"
#import "HomeModel.h"
#import "CityTableViewCell.h"

#define LeftW (kScreenWidth/3)
#define RightW (kScreenWidth/3*2)

static NSString *const leftCellID = @"leftCellID";

@interface CityViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _leftSelectedRow;
}
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

//数据源
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *rightArray;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav:YES];
    
    //1、获得路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"city.plist"];
    //3、读取数据
    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
    
    if (result == NULL) {
        [self requestData];
    }else {

        //处理数据
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *provDic in result) {
            HomeModel *model = [[HomeModel alloc] initContentWithDic:provDic];
            [mArr addObject:model];
        }
        self.dataArray = mArr;
        _leftSelectedRow = 0;
        HomeModel *cityModel = self.dataArray[_leftSelectedRow];
        self.rightArray = cityModel.cityArray;
    }
    
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpViews {
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LeftW, kScreenHeight-64) style:UITableViewStylePlain];
    self.leftTableView.tag = 10;
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.rowHeight = 40;
    self.leftTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.leftTableView];
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableView.tableFooterView = [UIView new];
    
    
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(LeftW, 0, RightW, kScreenHeight-64) style:UITableViewStylePlain];
    self.rightTableView.tag = 20;
    self.rightTableView.rowHeight = 52;
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    [self.view addSubview:self.rightTableView];
    self.rightTableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 10) {
        return self.dataArray.count;
    }else {
        return self.rightArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 10) {
        CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellID];
        if (cell == nil) {
            cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellID];
        }
        
        if (_leftSelectedRow == 0) {
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        HomeModel *model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.province;
        
        return cell;
    }else {
        NSString *cellID = @"rightCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.textLabel.font = systemFont(16);
        }

        CityDetailModel *detailModel = self.rightArray[indexPath.row];
        cell.textLabel.text = detailModel.city_name;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 10) {
        _leftSelectedRow = indexPath.row;
        HomeModel *model = self.dataArray[_leftSelectedRow];
        self.rightArray = model.cityArray;
        
        [self.rightTableView reloadData];
    }else {
        //block传值
        CityDetailModel *model = self.rightArray[indexPath.row];
        
        if (self.block != nil) {
            self.block(model.city_name, model.city_code);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - requestData
- (void)requestData {
    [DataService http_Post:@"/api/WeiZhang/citys" parameters:nil success:^(id responseObject) {
//        NSLog(@"responseObject:%@", responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSArray *dataArray = [responseObject objectForKey:@"datas"];
            
            //1、获得路径
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *fileName = [path stringByAppendingPathComponent:@"city.plist"];
            //2、存储数据
            [dataArray writeToFile:fileName atomically:YES];
            
            
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *provDic in dataArray) {
                HomeModel *model = [[HomeModel alloc] initContentWithDic:provDic];
                [mArr addObject:model];
            }
            _leftSelectedRow = 0;
            HomeModel *cityModel = self.dataArray[_leftSelectedRow];
            self.rightArray = cityModel.cityArray;
            
            self.dataArray = mArr;
            [self.leftTableView reloadData];

        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

#pragma mark - block
//block的调用
- (void)returnText:(SelectedBlock)block {
    self.block = block;
}

@end
