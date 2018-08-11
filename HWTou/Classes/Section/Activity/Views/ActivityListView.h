//
//  ActivityListView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityListView : UIView

@property (nonatomic, copy) NSArray<NSArray *> *listData;

@property (nonatomic, readonly) UITableView *tableView;

- (void)reloadTableData;

@end
