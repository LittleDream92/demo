//
//  MerchantView.h
//  ChooseCityDemo
//
//  Created by Meng Fan on 16/7/20.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MerchantDelegate <NSObject>

@optional
/**
 *  点击tableview，过滤id
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withName:(NSString *)name;

@end



@interface MerchantView : UIView

@property(nonatomic, strong) UITableView *tableViewOfGroup;
@property(nonatomic, strong) UITableView *tableViewOfDetail;

@property(nonatomic, assign) id<MerchantDelegate> delegate;

@end
