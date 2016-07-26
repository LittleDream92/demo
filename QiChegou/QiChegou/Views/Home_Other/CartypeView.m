//
//  CartypeView.m
//  ChooseViewDemo
//
//  Created by Meng Fan on 16/7/22.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CartypeView.h"

static NSString *const cellID = @"carTypeCellID";
@interface CartypeView ()<UITableViewDelegate, UITableViewDataSource>

@end


@implementation CartypeView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    [self setUpChooseView];

}

- (void)setUpChooseView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake((self.width-200)/2, (self.height-110)/2, 200, 120) style:UITableViewStylePlain];
    tableView.rowHeight = 60;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    tableView.scrollEnabled = NO;
    
    //注册单元格
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedBtn.userInteractionEnabled = NO;
    selectedBtn.frame = CGRectMake(170, 20, 20, 20);
    selectedBtn.tag = 110;
    selectedBtn.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:selectedBtn];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"小型车";
    }else {
        cell.textLabel.text = @"大型车";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIButton *btn = (UIButton *)[cell viewWithTag:110];
    btn.backgroundColor = [UIColor cyanColor];
    
    NSString *resultStr = indexPath.row == 0 ? @"小型车" : @"大型车" ;
    NSInteger result = indexPath.row == 0 ? 02 : 01;
    
    if (self.block != nil) {
        self.block(resultStr, result);
    }
    [self hidden];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIButton *btn = (UIButton *)[cell viewWithTag:110];
    btn.backgroundColor = [UIColor redColor];
}

#pragma mark - private
- (void)hidden {
    self.hidden = YES;
}

//调用
- (void)returnBlock:(typeBlock)block {
    self.block = block;
}

@end
