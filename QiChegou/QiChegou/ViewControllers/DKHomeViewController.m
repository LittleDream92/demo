//
//  DKHomeViewController.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/6.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKHomeViewController.h"
#import "DKChooseCarViewController.h"
#import "DKRuleSearchViewController.h"
#import "DKMainWebViewController.h"
#import "HomeButton.h"
#import "DataService.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import "WeatherView.h"

static NSString *const collectionCellID = @"collectioncellID";
@interface DKHomeViewController () <CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CLLocationManager *locationManager;   //定位
//定位结果，经纬度
@property (nonatomic, copy) NSString *latitude;//   纬度
@property (nonatomic, copy) NSString *longitude;    //经度
@property (nonatomic, copy) NSString *address;  //定位出来的地址
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet WeatherView *weatherView;

@property (weak, nonatomic) IBOutlet UIImageView *newsImgView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsHeight;

//数据源
@property (nonatomic, strong) NSArray *weatherArray;

@end

@implementation DKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self location];
    [self setUpViews];
    [self requestData];
    
    [self location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setUp
- (void)setUpViews {
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    self.newsHeight.constant = 230 * kHeightScale;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
    
    //刷新
    UIButton *update = [UIButton buttonWithType:UIButtonTypeCustom];
    [update setTitle:@"刷新" forState:UIControlStateNormal];
    update.frame = CGRectMake(0, 0, 50, 44);
    [update addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:update];
    self.navigationItem.rightBarButtonItem = right;
    
    [self setUpControlBtn];
    
    //初始化汽车狗按钮
    UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mainBtn setBackgroundImage:[UIImage imageNamed:@"home_go"] forState:UIControlStateNormal];
    [mainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mainBtn setTitle:@"汽车狗 Go！" forState:UIControlStateNormal];
    [mainBtn addTarget:self action:@selector(mainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.middleView addSubview:mainBtn];
    
    [mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.middleView.mas_centerX);
        make.centerY.mas_equalTo(self.middleView.mas_centerY);
        
        //判断是否为iPhone 5/s
        if (kScreenHeight < 667) {
            make.size.mas_equalTo(CGSizeMake(150, 35));
        }else {
            make.size.mas_equalTo(CGSizeMake(160, 40));
        }
        
    }];
    
}

//设置按钮
- (void)setUpControlBtn {
    HomeButton *rulesBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
    [self setButtonWithButton:rulesBtn imgName:@"home_weizhang" title:@"违章查询" index:1];
    
    HomeButton *washBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
    [self setButtonWithButton:washBtn imgName:@"home_xiche" title:@"健康洗车" index:2];
    
    HomeButton *orderBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
    [self setButtonWithButton:orderBtn imgName:@"home_baodan" title:@"保单查询" index:3];
    
    HomeButton *oilBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
    [self setButtonWithButton:oilBtn imgName:@"home_baodan" title:@"油价查询" index:4];
    
    int padding = 5;
    
    [rulesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.btnView.mas_centerY);
        make.left.equalTo(self.btnView.mas_left).with.offset(padding);
        make.right.equalTo(washBtn.mas_left).with.offset(-padding);
        make.height.mas_equalTo(@60);
        make.width.equalTo(washBtn);
    }];
    
    [washBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.btnView.mas_centerY);
        make.left.equalTo(rulesBtn.mas_right).with.offset(padding);
        make.right.equalTo(orderBtn.mas_left).with.offset(-padding);
        make.height.mas_equalTo(@60);
        make.width.equalTo(rulesBtn);
    }];
    
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.btnView.mas_centerY);
        make.left.equalTo(washBtn.mas_right).with.offset(padding);
        make.right.equalTo(oilBtn.mas_left).with.offset(-padding);
        make.height.mas_equalTo(@60);
        make.width.equalTo(rulesBtn);
    }];
    
    [oilBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.btnView.mas_centerY);
        make.left.equalTo(orderBtn.mas_right).with.offset(padding);
        make.right.equalTo(self.btnView.mas_right).with.offset(-padding);
        make.height.mas_equalTo(@60);
        make.width.equalTo(rulesBtn);
    }];
}

#pragma mark - private
- (void)setButtonWithButton:(HomeButton *)btn imgName:(NSString *)imgName title:(NSString *)title index:(NSInteger)index {
    btn.tag = index + 2000;
    btn.isAtHome = YES;
    [btn setBackgroundImage:[UIImage imageNamed:@"home_btn_bg"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnView addSubview:btn];
}

#pragma mark - button action
- (void)updateAction:(UIButton *)sender {
    [self location];
}

- (IBAction)newsListAction:(id)sender {
    DKMainWebViewController *webVC = [[DKMainWebViewController alloc] init];
    webVC.title = @"新闻列表";
    webVC.isRequest = YES;
    webVC.webString = [NSString stringWithFormat:@"%@%@", URL_String, NEWSLIST];
    [self.navigationController pushViewController:webVC animated:YES];
}

/* buy car */
- (void)mainButtonAction:(UIButton *)sender {
    DKChooseCarViewController *chooseVC = [[DKChooseCarViewController alloc] init];
    chooseVC.cityidString = @"6";
    [self.navigationController pushViewController:chooseVC animated:YES];
}

- (void)btnAction:(UIButton *)sender {
    switch (sender.tag-2000) {
        case 1:
        {
            DKRuleSearchViewController *ruleVC =  [[UIStoryboard storyboardWithName:@"HomeOther" bundle:nil] instantiateViewControllerWithIdentifier:@"DKRuleSearchViewController"];
            [self.navigationController pushViewController:ruleVC animated:YES];
            break;
        }
        case 2:
        {
            DKMainWebViewController *webViewController = [[DKMainWebViewController alloc] init];
            webViewController.title = @"洗车";
//            webViewController.webString = @"http://test.tangxinzhuan.com/api/XiChe";
//            webViewController.isRequest = YES;
            webViewController.webString = @"http://open.chediandian.com/xc/index?ApiKey=25fea4fca5d54a91ad935814980dd787&ApiST=1467609844&ApiSign=962ad4b142ae429ac5bdb051b958e0e8";
            webViewController.isRequest = NO;
            [self.navigationController pushViewController:webViewController animated:YES];

            break;
        }
        case 3:
        {
            break;
        }
        case 4:
        {
            break;
        }
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    UILabel *week = [cell viewWithTag:90];
    UILabel *date = [cell viewWithTag:80];
    
    if (!week) {
        UILabel *weekLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth / 5, 20)];
        weekLable.tag = 90;
        weekLable.textAlignment = NSTextAlignmentCenter;
        weekLable.font = systemFont(14);
        weekLable.textColor = RGB(0, 120.0, 255);
        [cell.contentView addSubview:weekLable];
    }else {
        week.text = nil;
    }
    
    if (!date) {
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, kScreenWidth/5, 20)];
        dateLabel.tag = 80;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = systemFont(14);
        dateLabel.textColor = RGB(0, 120.0, 255);
        [cell.contentView addSubview:dateLabel];
    }else {
        date.text = nil;
    }
    
    if (indexPath.row == self.lastIndexPath.row) {
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        cell.backgroundColor = BGCOLOR;
    }
    
    WeatherModel *model = self.weatherArray[indexPath.item];
    week.text = model.week;
    date.text = model.date;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.collectionView.width / 5;
    return CGSizeMake(width, 50);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
    
    [self.weatherView setUpViewWithData:self.weatherArray[indexPath.item]];

    if (!self.lastIndexPath) {
        UICollectionViewCell *lastCell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        lastCell.backgroundColor = BGCOLOR;
    }else {
        UICollectionViewCell *lastCell = [collectionView cellForItemAtIndexPath:self.lastIndexPath];
        lastCell.backgroundColor = BGCOLOR;
    }
    
    //显示当前选择的
    UICollectionViewCell *currentCell = [collectionView cellForItemAtIndexPath:indexPath];
    currentCell.backgroundColor = [UIColor whiteColor];
    
    self.lastIndexPath = indexPath;
}

#pragma mark - location
- (void)location {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
        }
        
        //设置代理
        [self.locationManager setDelegate:self];
        //设置定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        //设置距离筛选
        [self.locationManager setDistanceFilter:100];
        //开始定位
        [self.locationManager startUpdatingLocation];
        //设置开始识别方向
        [self.locationManager startUpdatingHeading];
        
    }else {
        NSLog(@"无定位");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您没有开启定位功能"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}


#pragma mark CoreLocation delegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取经纬度
    self.latitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    
    NSLog(@"%@, %@", self.longitude, self.latitude);
    
    //获取信息
    [self requestInfo];

    //反编码
    [self reverseGeocoder:currentLocation];
}

#pragma mark - 反编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            NSLog(@"error == %@", error);
        }else {
            CLPlacemark *placemark = placemarks.firstObject;
            NSLog(@"%@", [placemark addressDictionary]);
            NSLog(@"placemarks:%@%@", [[placemark addressDictionary] objectForKey:@"City"], [[[placemark addressDictionary] objectForKey:@"FormattedAddressLines"] objectAtIndex:0]);
            
            self.navigationItem.title = [[placemark addressDictionary] objectForKey:@"City"];
            self.address = [NSString stringWithFormat:@"%@", [[[placemark addressDictionary] objectForKey:@"FormattedAddressLines"] objectAtIndex:0]];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的位置" message:[[placemark addressDictionary] objectForKey:@"City"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
        
    }];
}

#pragma mark - af 
- (void)requestData {
    
    [DataService http_Post:@"/api/news/zuixin" parameters:nil success:^(id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            
            NSArray *jsonArr = [responseObject objectForKey:@"datas"];
            if ([jsonArr isKindOfClass:[NSArray class]] && jsonArr.count > 0) {

                [self.newsImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", URL_String, jsonArr[0][@"main_photo"]]]];
                self.newsTitle.text = jsonArr[0][@"name"];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"news error:%@", error);
    }];
}


- (void)requestInfo {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.latitude,@"lat",
                           self.longitude,@"lon", nil];
    
    [HttpTool requestHomeInfoWithParams:params block:^(id json, BOOL result) {
        if (result) {
           self.weatherArray = json;
           [self.weatherView setUpViewWithData:self.weatherArray[0]];
            [self.collectionView reloadData];
        }
    }];
}


@end
