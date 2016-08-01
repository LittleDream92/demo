//
//  MerchantView.m
//  ChooseCityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "MerchantView.h"

// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define leftWidth (self.frame.size.width/2)

@interface MerchantView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _leftSelectedIndex;
    
    NSArray *_leftArray;
    NSArray *_rightArray;
}


@end

@implementation MerchantView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _leftArray = @[@"美食", @"酒店", @"休闲娱乐", @"生活服务", @"丽人", @"旅游", @"本地购物", @"汽车服务", @"摄影写真", @"电影"];
        
        
        [self initViews];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self getCateListData];
//        });
    }
    return self;
}

-(void)initViews{
    //分组
    self.tableViewOfGroup = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, leftWidth-30, self.frame.size.height) style:UITableViewStylePlain];
    self.tableViewOfGroup.tag = 10;
    self.tableViewOfGroup.delegate = self;
    self.tableViewOfGroup.dataSource = self;
    self.tableViewOfGroup.backgroundColor = [UIColor whiteColor];
    self.tableViewOfGroup.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableViewOfGroup];

    //详情
    self.tableViewOfDetail = [[UITableView alloc] initWithFrame:CGRectMake(leftWidth-30, 0, leftWidth+30, self.frame.size.height) style:UITableViewStylePlain];
    self.tableViewOfDetail.tag = 20;
    self.tableViewOfDetail.dataSource = self;
    self.tableViewOfDetail.delegate = self;
    self.tableViewOfDetail.backgroundColor = RGB(242, 242, 242);
    self.tableViewOfDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableViewOfDetail];
    
    
    self.userInteractionEnabled = YES;
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        return 10;
    }else{
        return 20;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        static NSString *cellIndentifier = @"filterCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
    
        cell.textLabel.text = [NSString stringWithFormat:@"left tableview:%ld", indexPath.row];
    
        return cell;
    }else {
        static NSString *cellIndentifier = @"filterCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"right:%ld", indexPath.row];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        _leftSelectedIndex = indexPath.row;
        [self.tableViewOfDetail reloadData];
    }else {
        
        NSString *name = [NSString stringWithFormat:@"right:%ld", indexPath.row];
        //代理方法
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath withName:name];
    }
}

@end
