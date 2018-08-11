//
//  CommonTableViewCell.h
//
//  Created by pengpeng on 15/10/23.
//  Copyright (c) 2015年 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableCellItem;

@interface CommonTableViewCell : UITableViewCell

/**
 *  @brief 通过类方法实例化CommonTableViewCell对象
 *
 *  @param tableView 表示图
 *  @param cellItem  cell数据模型
 *
 *  @return CommonTableViewCell对象
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView cellItem:(TableCellItem *)cellItem;

@end
