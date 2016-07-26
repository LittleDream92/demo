//
//  DKRuleViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKRuleViewController.h"
#import "RulesCell.h"

static NSString *const cellID = @"resultCellID";
static NSString *const lastCellID = @"lastCellID";
@interface DKRuleViewController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *noRulesView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


//数据源
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DKRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav:YES];
    [self setClose:YES];
    
    [self setUpViews];
    [self requestData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpViews {
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"RulesCell" bundle:nil] forCellReuseIdentifier:cellID];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RulesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.ruleModel = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    HomeModel *model = self.dataArray[indexPath.row];
    CGFloat height1 = [BaseFunction heightForString:model.area fontSize:15 andWidth:kScreenWidth - 80];
    CGFloat height2 = [BaseFunction heightForString:model.act fontSize:14 andWidth:kScreenWidth - 80];
    
    return height1 + height2 + 80;
}

#pragma mark - requestData
- (void)requestData {
    NSString *token = [AppDelegate APP].user.token;
    if (!token || token.length <= 0) {
        token = @"";
    }

    NSLog(@"%@", self.engine);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",
                            self.chepai, @"chepai",
                            self.cityCode, @"city_code",
                            self.type, @"chepai_type",
                            self.engine, @"fadongji",  nil];

    [HttpTool requestBreakRuleWithParams:params success:^(id json, BOOL result) {
        if (result) {
//            NSLog(@"%@", json);
            self.dataArray = json;
            
            self.tableView.hidden = NO;
            self.noRulesView.hidden = YES;
            
            [self.tableView reloadData];
        }else {
            self.noRulesView.hidden = NO;
            self.tableView.hidden = YES;
        }
        
    }];
}


@end
