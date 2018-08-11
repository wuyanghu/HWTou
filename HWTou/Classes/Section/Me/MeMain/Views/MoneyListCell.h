//
//  MoneyListCell.h
//  HWTou
//
//  Created by Reyna on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyListModel.h"

@interface MoneyListCell : UITableViewCell

+ (NSString *)cellReuseIdentifierInfo;

+ (CGFloat)singleCellHeight;

- (void)bind:(MoneyListModel *)model;

@end
