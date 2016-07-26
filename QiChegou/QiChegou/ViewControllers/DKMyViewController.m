//
//  DKMyViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/6.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKMyViewController.h"
#import "DKLoginViewController.h"
#import "DKChangePWDViewController.h"
#import "DKBaseNavigationController.h"
#import "HomeButton.h"
#import "DKDetailCarViewController.h"

#define HeaderH 175

static NSString *const commentCell = @"commentCellID";
static NSString *const latestCell = @"latestCellID";
@interface DKMyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *imgNamesArr;

//最近浏览数据源
@property (nonatomic, strong) NSArray *carIDArr;

@end

@implementation DKMyViewController

-(void)dealloc {
    [NotificationCenters removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    [self setUpData];
    [self setUpViews];
    
    //通知
    [NotificationCenters addObserver:self selector:@selector(loginSuccess:) name:LOGIN_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - system view methods
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![AppDelegate APP].user) {
        self.nameLabel.text = @"点击头像登录";
    }else {
        self.nameLabel.text = [AppDelegate APP].user.zsxm;
    }
    
    //判断有没有最近浏览数据
    NSMutableArray *array = [UserDefaults objectForKey:kLatestLook];
    
    if (array) {
        NSLog(@"not nil");
        
        NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:array];
        self.carIDArr = mArr;
    }
    
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

#pragma mark - private
- (void)setUpData {
    _imgNamesArr = @[@"icon_myOrder",@"icon_activity",@"icon_changePwd",@"icon_off",@"icon_time"];
    _titleArr = @[@"我的订单",@"我的活动",@"修改密码",@"退出登录",@"最近浏览"];
}

- (void)setUpViews {
    //初始化
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64 - 44) style:UITableViewStyleGrouped];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.sectionHeaderHeight = 10;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    //注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commentCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:latestCell];
    
    //设置头/尾视图
    [self setUpHeaderView];
    [self setUpFooterView];
}

- (void)setUpHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderH)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_TableHeader"]];
    imgView.tag = 2015;
    [headerView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //昵称
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = systemFont(16);
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.text = @"点击头像登录";
    [headerView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.bottom.mas_equalTo(headerView.mas_bottom).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 21));
    }];
    
    //头像
    UIButton *iconBtn = [[UIButton alloc] init];
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"bg_TVHeader"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(iconAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:iconBtn];
    
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.centerY.mas_equalTo(headerView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(96, 96));
    }];
    //圆角
    iconBtn.layer.masksToBounds = YES;
    iconBtn.layer.cornerRadius = 96/2;
    
    self.tableView.tableHeaderView = headerView;
}

- (void)setUpFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    self.tableView.tableFooterView = footerView;
    
    UILabel *tellLabel = [[UILabel alloc] init];
    tellLabel.font = systemFont(14);
    tellLabel.textColor = ITEMCOLOR;
    tellLabel.text = @"400-169-0399";
    tellLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:tellLabel];
    
    [tellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView.mas_centerX);
        make.top.equalTo(footerView.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 21));
    }];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = systemFont(10);
    textLabel.textColor = GRAYCOLOR;
    textLabel.text = @"汽车购为您服务（ 9:00 - 21:00 ）";
    textLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView.mas_centerX);
        make.top.equalTo(tellLabel.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 21));
    }];
}

#pragma mark - -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 4 ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = indexPath.row == 0 ? commentCell : latestCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:self.imgNamesArr[indexPath.section]];
        cell.textLabel.font = systemFont(16);
        cell.textLabel.textColor = TEXTCOLOR;
        cell.textLabel.text = self.titleArr[indexPath.section];
        
        if (indexPath.section == 4) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        }
    }else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.contrlArr.count>0) {
            //需要删除之前的control
            for (int i = 0; i < self.contrlArr.count; i++) {
                
                NSInteger tag = [self.contrlArr[i] integerValue];
                HomeButton *control = (HomeButton *)[cell viewWithTag:tag];
                [control removeFromSuperview];
            }
        }
        //最近浏览
        if (self.carIDArr) {
            
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *jsonDic in self.carIDArr) {
                NSInteger tagValue = [[jsonDic objectForKey:@"cid"] integerValue]+ 2016;
                [mArr addObject:[NSNumber numberWithInteger:tagValue]];
            }
            self.contrlArr = mArr;
            
            for (int i = 0; i < [self.carIDArr count]; i++) {
                //初始化自定义Control
                CGFloat ctrlY = 0;
                CGFloat ctrlWidth = (kScreenWidth - 45)/3;
                CGFloat ctrlHeight = 100;
                
                HomeButton *carCtrl = [[HomeButton alloc] initWithFrame:CGRectMake(15 + i*ctrlWidth, ctrlY, ctrlWidth, ctrlHeight)];
                NSDictionary *myDic = self.carIDArr[i];
                
                carCtrl.tag = [[myDic objectForKey:@"cid"] integerValue] + 2016;
                [carCtrl setUpButtonWithImageName:myDic[@"imgName"] title:myDic[@"title"]];
                [carCtrl addTarget:self action:@selector(ctrlClickAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:carCtrl];
            }
        }
    }
    
    return cell;
}

//点击最近浏览控件触发的
- (void)ctrlClickAction:(HomeButton *)ctrl
{
    NSLog(@"浏览click");
    NSString *carID = [NSString stringWithFormat:@"%ld",(ctrl.tag - 2016)];
    NSLog(@"push cid:%@", carID);
    
    //push进入详细选车页面
    DKDetailCarViewController *detailCarVC = [[DKDetailCarViewController alloc] init];
    detailCarVC.cid = carID;
    [self.navigationController pushViewController:detailCarVC animated:YES];
    
}

#pragma mark -tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    }else {
        if ([self.carIDArr isKindOfClass:[NSArray class]] && self.carIDArr.count > 0) {
            return 110;
        }else {
            return 0;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //消除cell选择痕迹
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([AppDelegate APP].user) {   //have login
        if (indexPath.section == 0) {   //my order
            
            
        }else if (indexPath.section == 1) {    //my activity
            
            
        }else if (indexPath.section == 2) {     //reset password
            
            DKChangePWDViewController *changePwdVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"DKChangePWDViewController"];
            DKBaseNavigationController *navCtrller = [[DKBaseNavigationController alloc] initWithRootViewController:changePwdVC];
            [self presentViewController:navCtrller animated:YES completion:nil];
            
        }else if (indexPath.section == 3) {     //login out
            
            [self loginOut];
        }
    }else {
        if (indexPath.section == 3) {
            NSLog(@"您还没有登录");
        }else if (indexPath.section != 4) {
            DKLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"DKLoginViewController"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //观察滑动视图的偏移量
    CGFloat yOffset = scrollView.contentOffset.y + 64;
    if (yOffset < 0) {
        //往下拉
        //取出图片视图
        UIImageView *imgView = (UIImageView *)[self.tableView.tableHeaderView viewWithTag:2015];
        //计算宽度
        CGFloat width = kScreenWidth/HeaderH * (HeaderH - yOffset);
        imgView.frame = CGRectMake((kScreenWidth - width) / 2, yOffset, width, HeaderH - yOffset);
    }
}

#pragma mark - button action
- (void)iconAction:(UIButton *)button {
    if (![AppDelegate APP].user) {
        //没有登录
        DKLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"DKLoginViewController"];
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }else {
        NSLog(@"%@ have login", [AppDelegate APP].user.zsxm);
    }
}

- (void)loginSuccess:(NSNotification *)notification {
    //由于每次view will appear的时候都会判断，因此这里可不做赋值
}

- (void)loginOut {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定退出登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"确定退出");
        NSLog(@"controller:%@", [AppDelegate APP].user.token);
        [HttpTool requestLoginOutResult:^(BOOL result) {
            if (result) {
                [AppDelegate APP].user = nil;
                self.nameLabel.text = @"点击头像登录";
            }
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
