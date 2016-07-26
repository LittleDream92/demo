//
//  DKCondationViewController.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "DKCondationViewController.h"
#import "CondationCollectionCell.h"
#import "UIbutton+extension.h"
#import "ListViewController.h"

#define CELL_HEIGHT (430 / 5)

@interface DKCondationViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    //条件选车数组
    NSArray *imgNameArr;
    NSArray *priceArray;
    //记录选择选项的字典
    NSMutableDictionary *selectedDic;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *pushBtn;

@end

@implementation DKCondationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    [self setupView];
    [self getNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup 
- (void)setupData {
    //初始化，保存的选项的字典
    selectedDic = [NSMutableDictionary dictionary];
    
    imgNameArr = @[@"bg_mini",@"bg_small",@"bg_compactly",@"bg_maddle",@"bg_big",@"bg_luxurious",@"bg_MPV",@"bg_SUV",@"bg_runCar",@""];
    
    priceArray = @[@"5",@"8",@"12",@"18",@"25",@"35",@"50",@"60"];
}

- (void)setupView {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.clearBtn];
    [self.bottomView addSubview:self.pushBtn];
    
    //注册单元格和头视图
    NSString *identifier = @"CondationtvCollectionCell";
    [self.collectionView registerClass:[CondationCollectionCell class] forCellWithReuseIdentifier:identifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];//注册头/尾视图，视图类型必须为UICollectionReusableView或者其子类，kind设置为UICollectionElementKindSectionHeader或者UICollectionElementKindSectionFooter，最后设置标识
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }else if (section == 1) {
        return 10;
    }else {
        return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CGFloat width = kScreenWidth/2;
        CGFloat height = CELL_HEIGHT;
        
        return CGSizeMake(width, height);
    }else {
        CGFloat width = kScreenWidth/3;
        CGFloat height = 45;
        
        return CGSizeMake(width, height);
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //第一组
    static NSString *identifier = @"CondationtvCollectionCell";
    CondationCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        collectionCell.carImgView.image = nil;
        collectionCell.carLabel.text = nil;
        collectionCell.condationModel = nil;
        
        collectionCell.carLabel.frame = CGRectMake(0, 0, 375/3, 45);
        if (indexPath.row == 0) {
            //第一个
            collectionCell.carLabel.text = [NSString stringWithFormat:@"%@万以下", priceArray[0]];
        }else if (indexPath.row == 7) {
            //最后一个
            collectionCell.carLabel.text = [NSString stringWithFormat:@"%@万以上", priceArray[7]];
        }else {
            //其他
            collectionCell.carLabel.text = [NSString stringWithFormat:@"%@-%@万", priceArray[indexPath.row - 1],priceArray[indexPath.row]];
        }
    }else {
        
        HomeModel *cellModel = self.condationDataArr[indexPath.row];
        collectionCell.condationModel = cellModel;
        collectionCell.imgNameStr = imgNameArr[indexPath.row];
        
    }
    
    return collectionCell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - UICollectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth, 37);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //根据类型以及标识获取注册过的头视图,注意重用机制导致的bug
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    
    headerView.backgroundColor = kbgGrayColor;
    
    for (UIView *view in headerView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.frame.size.width - 15, headerView.frame.size.height)];

    label.font = systemFont(16);
    label.textColor = GRAYCOLOR;
    if (indexPath.section == 0) {
        label.text = @"价格区间";
    }else {
        label.text = @"级别";
    }
    [headerView addSubview:label];
    
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        NSIndexPath *index1 = [selectedDic objectForKey:@"Price"];
        
        //还原之前的
        CondationCollectionCell *cell = (CondationCollectionCell *)[collectionView cellForItemAtIndexPath:index1];
        UILabel *label = [cell viewWithTag:1001];
        label.textColor = [UIColor blackColor];
        
        [selectedDic setObject:indexPath forKey:@"Price"];
    }else
    {
        NSIndexPath *index2 = [selectedDic objectForKey:@"Level"];
        
        //还原之前的
        CondationCollectionCell *cell = (CondationCollectionCell *)[collectionView cellForItemAtIndexPath:index2];
        UILabel *label = [cell viewWithTag:1001];
        label.textColor = [UIColor blackColor];
        
        [selectedDic setObject:indexPath forKey:@"Level"];
    }
    
    //改变现在的颜色
    CondationCollectionCell *cell = (CondationCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:1001];
    label.textColor = [UIColor orangeColor];
    
    
    //改变button的位置
    self.clearBtn.frame = CGRectMake(0, 0, 100, 50);
    self.pushBtn.frame = CGRectMake(self.clearBtn.right, 0, kScreenWidth - self.clearBtn.width, 50);
    
    //网络请求改变button的title
    [self changeTheTitleForFindCar];
    
}

- (void)changeTheTitleForFindCar {
    NSString *minPrice = @"";
    NSString *maxPrice = @"";
    NSString *mid = @"";
    
    //取出已经选择的
    NSIndexPath *indexPath1 = [selectedDic objectForKey:@"Price"];
    NSIndexPath *indexPath2 = [selectedDic objectForKey:@"Level"];
    
    //价格
    if (indexPath1 != NULL || indexPath2 != NULL) {
        
        if (indexPath1 != NULL) {
            if (indexPath1.row == 0) {
                minPrice = @"";
                maxPrice = priceArray[0];
            }else if (indexPath1.row == 7) {
                minPrice = priceArray[7];
                maxPrice = @"";
            }else {
                minPrice = priceArray[indexPath1.row - 1];
                maxPrice = priceArray[indexPath1.row];
            }
            
        }else {
            minPrice = @"";
            maxPrice = @"";
        }
        
        //车型
        if (indexPath2 != NULL) {
            HomeModel *carModel = self.condationDataArr[indexPath2.row];
            mid = carModel.model_id;
        }else {
            mid = @"";
        }
        NSLog(@"%@, %@, %@",minPrice, maxPrice, mid);
        
        //网络请求多少款车
        [self carNumbersRequestWithmin:minPrice max:maxPrice mid:mid];
        
    }
}

#pragma mark - getNewData
- (void)getNewData {
    [HttpTool requestCondationBlock:^(id json) {
        if (json != nil) {
            self.condationDataArr = json;
            //刷新collection View
            [self.collectionView reloadData];
        }
    }];
}

- (void)carNumbersRequestWithmin:(NSString *)min max:(NSString *)max mid:(NSString *)mid {
    
    [HttpTool getCarNumbersWithCityID:self.cityidString min:min max:max mid:mid block:^(id json) {
        [self.pushBtn setTitle:[NSString stringWithFormat:@"找到%@款车型", json] forState:UIControlStateNormal];
    }];
}

#pragma mark - setting and getting

-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        //初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 48 - 64 - 50) collectionViewLayout:flowLayout];

        _collectionView.backgroundColor = [UIColor whiteColor];
        //代理数据源
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

-(UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 48 - 50, kScreenWidth, 50)];
    }
    return _bottomView;
}

- (UIButton *)clearBtn {
    if (_clearBtn == nil) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn createButtonWithBGImgName:@"btn_clear"
                          bghighlightImgName:@"btn_clear_2"
                                    titleStr:@"清空"
                                    fontSize:16];
        [_clearBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UIButton *)pushBtn {
    if (_pushBtn == nil) {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushBtn setTitleColor:WHITEColor forState:UIControlStateNormal];
        [_pushBtn createButtonWithBGImgName:@"btn_find"
                         bghighlightImgName:@"btn_find_2"
                                   titleStr:@"找到0款车型"
                                   fontSize:16];
        [_pushBtn addTarget:self action:@selector(pushNextAction:) forControlEvents:UIControlEventTouchUpInside];
        _pushBtn.x = self.clearBtn.right;
        _pushBtn.width = kScreenWidth - self.clearBtn.width;
        _pushBtn.height = self.bottomView.height;
        _pushBtn.y = 0;
        
    }
    return _pushBtn;
}

#pragma mark - btn action
- (void)clearAction:(UIButton *)button {
    //清空
    self.clearBtn.frame = CGRectZero;
    self.pushBtn.frame = CGRectMake(self.clearBtn.right, 0, kScreenWidth - self.clearBtn.width, 50);
    
    //恢复颜色
    [self backColor];
    
    //清空记录的数据
    [selectedDic removeAllObjects];
    
    //恢复button的title
    [self.pushBtn setTitle:@"找到0款车型" forState:UIControlStateNormal];
}

- (void)backColor {
    //第一组
    NSIndexPath *index1 = [selectedDic objectForKey:@"Price"];
    
    //还原之前的
    CondationCollectionCell *cell1 = (CondationCollectionCell *)[self.collectionView cellForItemAtIndexPath:index1];
    UILabel *label1 = [cell1 viewWithTag:1001];
    label1.textColor = [UIColor blackColor];
    
    //第二组
    NSIndexPath *index2 = [selectedDic objectForKey:@"Level"];
    //还原之前的
    CondationCollectionCell *cell2 = (CondationCollectionCell *)[self.collectionView cellForItemAtIndexPath:index2];
    UILabel *label2 = [cell2 viewWithTag:1001];
    label2.textColor = [UIColor blackColor];
    
}

- (void)pushNextAction:(UIButton *)button {
    //判断条件是否齐全
    NSIndexPath *indexPath1 = [selectedDic objectForKey:@"Price"];
    NSIndexPath *indexPath2 = [selectedDic objectForKey:@"Level"];
    
    if (indexPath1 == NULL && indexPath2 == NULL) {
        NSLog(@"不符合push");
        [PromtView showMessage:@"请选择价格区间或者级别" duration:1.5];
    }else {
        
        NSLog(@"符合push条件");
        [self pushNextPageWithIndex1:indexPath1 indexPath2:indexPath2];
    }
}

- (void)pushNextPageWithIndex1:(NSIndexPath *)indexPath1 indexPath2:(NSIndexPath *)indexPath2
{
    //push
    ListViewController *carListVC = [[ListViewController alloc] init];
    carListVC.title = @"条件选车";
    
    if (indexPath1 != NULL) {
        //价格
        if (indexPath1.row == 0) {
            carListVC.minPrice = @"";
            carListVC.maxPrice = priceArray[0];
        }else if (indexPath1.row == 7) {
            carListVC.minPrice = priceArray[7];
            carListVC.maxPrice = @"";
        }else {
            carListVC.minPrice = priceArray[indexPath1.row - 1];
            carListVC.maxPrice = priceArray[indexPath1.row];
        }
    }else {
        carListVC.minPrice = @"";
        carListVC.maxPrice = @"";
        
    }
    //条件选车
    if (indexPath2 != NULL) {
        //车型
        HomeModel *carModel = self.condationDataArr[indexPath2.row];
        carListVC.modelID = carModel.model_id;
    }else {
        carListVC.modelID = @"";
    }
    
    NSLog(@"max:%@, min:%@, mid:%@", carListVC.maxPrice, carListVC.minPrice, carListVC.modelID);
    [self.navigationController pushViewController:carListVC animated:YES];
    
}

@end
