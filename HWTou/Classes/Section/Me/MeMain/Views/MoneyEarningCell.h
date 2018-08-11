//
//  MoneyEarningCell.h
//  HWTou
//
//  Created by Reyna on 2018/3/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyEarningModel.h"

@interface MoneyEarningCell : UITableViewCell

+ (NSString *)cellReuseIdentifierInfo;

+ (CGFloat)singleCellHeight;

- (void)bind:(MoneyEarningModel *)model;

@end
