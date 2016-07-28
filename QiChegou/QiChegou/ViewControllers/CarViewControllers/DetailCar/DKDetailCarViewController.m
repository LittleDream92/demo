//
//  DKDetailCarViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKDetailCarViewController.h"
#import "UIButton+Extension.h"
#import "DetailChooseCarHeader.h"
#import "ParamsViewController.h"
#import "ImageViewController.h"

static NSString *const commenCell = @"commenCell";
static NSString *const lastCell = @"lastCell";
@interface DKDetailCarViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArr;
    DetailChooseCarHeader *headerView;
}
@property (nonatomic, strong) UITableView *tableView;

//数据源
@property (nonatomic, strong) CarModel *detailModel;

@end

@implementation DKDetailCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUpViews
- (void)setUpViews {
    self.title = @"洗车";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav:YES];
    [self setClose:YES];
    
    titleArr = @[@"参数配置", @"车型图片"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    //注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commenCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:lastCell];
    
    //设置头视图
    CGFloat headerH = [self getHeaderViewHeight];
    //头视图
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"DetailChooseCarHeader" owner:self options:nil] lastObject];
    headerView.height = headerH;
    self.tableView.tableHeaderView = headerView;
    
    //设置尾视图
    UIButton *submmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submmitBtn.frame = CGRectMake(0, 0, kScreenWidth, 50);
    [submmitBtn createButtonWithBGImgName:@"btn_nextStep1"
                     bghighlightImgName:@"btn_nextStep1.2"
                               titleStr:@"下一步"
                               fontSize:16];
    [submmitBtn addTarget:self action:@selector(submmitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = submmitBtn;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lastCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        adView.image = [UIImage imageNamed:@"bg_ad"];
        [cell.contentView addSubview:adView];
        
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commenCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = systemFont(16);
        cell.textLabel.textColor = TEXTCOLOR;
        cell.textLabel.text = titleArr[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = kScreenHeight - self.tableView.tableHeaderView.height - self.tableView.tableFooterView.height - 12 - 44*2 - 64;
    return indexPath.row == 2 ? height : 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ParamsViewController *paramsVC = [[ParamsViewController alloc] init];
        paramsVC.title = @"参数配置";
        paramsVC.carID = self.detailModel.car_id;
        [self.navigationController pushViewController:paramsVC animated:YES];
    }else {
        ImageViewController *imageVC = [[ImageViewController alloc] init];
        imageVC.title = @"车型图片";
        imageVC.carID = self.detailModel.car_id;
        [self.navigationController pushViewController:imageVC animated:YES];
    }
}

#pragma mark - 最近浏览
- (void)nearlyLookCarWithModel:(CarModel *)detailModel {
    //取出数组
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [[NSUserDefaults standardUserDefaults] objectForKey:kLatestLook];
    
    if (array) {
        NSLog(@"you have looked car yet!");
        
        //存在此数组
        NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:array];
        
        //保存成字典，包含CID、phono、title
        NSDictionary *carDic = [NSDictionary dictionaryWithObjectsAndKeys:self.cid,@"cid",
                                detailModel.main_photo,@"imgName",
                                detailModel.car_subject,@"title",nil];
        
        if ([mArr containsObject:carDic]) {     //包含重复元素
            //删除重复元素
            [mArr removeObject:carDic];
        }
        
        
        if ([mArr count] >= 3) {    //>3
            //删除第一个元素
            [mArr removeObjectAtIndex:0];
        }
        
        [mArr addObject:carDic];
        NSLog(@"这次的mArr:%@", mArr);
        
        //操作数组
        [UserDefaults setObject:mArr forKey:kLatestLook];
        
    }else {
        NSLog(@"you have't looked any car!");
        
        //初始化mArr
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        
        //保存成字典，包含CID、phono、title
        NSDictionary *carDic = [NSDictionary dictionaryWithObjectsAndKeys:self.cid,@"cid",
                                detailModel.main_photo,@"imgName",
                                detailModel.car_subject,@"title",nil];
        
        [mArr addObject:carDic];
        [UserDefaults setObject:mArr forKey:kLatestLook];
    }
    
}


#pragma mark - private
- (CGFloat)getHeaderViewHeight {
    if (kScreenHeight == 667) {
        return 240.0;
    }else if (kScreenHeight > 667) {
        return 250.0;
    }else {
        return 210.0;
    }
}

- (void)submmitAction:(UIButton *)sender {
    NSLog(@"submmit");
    
}

#pragma mark - requestData
- (void)requestData {
    [HttpTool requestOneCarWithCID:self.cid block:^(id json) {
        self.detailModel = json;
        [headerView createHeaderScrollViewWithModel:self.detailModel];
        //最近浏览
        [self nearlyLookCarWithModel:self.detailModel];
    }];
}

@end
