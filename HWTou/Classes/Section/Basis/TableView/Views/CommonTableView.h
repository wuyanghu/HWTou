//
//  CommonTableView.h
//  HWTou
//
//  Created by pengpeng on 17/3/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableCellGroup;

@interface CommonTableView : UITableView

/**
 *  @brief  存放Table每组要显示的数据模型TableCellGroup
 *
 *  @return tableGroups模型数组
 */
- (NSMutableArray<TableCellGroup *> *)tableGroups;

@end
