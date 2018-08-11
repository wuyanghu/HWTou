//
//  MeEarningTableViewCell.h
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyEarningModel.h"

@interface MeEarningTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * priceLabel;

@property (nonatomic,strong) MoneyEarningModel * model;
@end
