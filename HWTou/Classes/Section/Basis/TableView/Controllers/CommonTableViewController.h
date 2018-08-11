//
//  CommonTableViewController.h
//
//  Created by pengpeng on 15/10/23.
//  Copyright (c) 2015年 PP. All rights reserved.
//
//  公共的UITableViewController封装数据源、代理等基本操作
//  需要用到基本TableView时只需提供要显示的数据模型

#import <UIKit/UIKit.h>

@interface CommonTableViewController : UITableViewController

/**
 *  @brief  存放Table每组要显示的数据模型TableCellGroup
 *
 *  @return tableGroups模型数组
 */
- (NSMutableArray *)tableGroups;

@end
