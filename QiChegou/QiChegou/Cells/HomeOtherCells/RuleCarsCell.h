//
//  RuleCarsCell.h
//  QiChegou
//
//  Created by Meng Fan on 16/7/25.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuleCarsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chepaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *fen;
@property (weak, nonatomic) IBOutlet UILabel *money;


@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end
