//
//  TableCellSwitchItem.h
//
//  Created by pengpeng on 15/10/23.
//  Copyright (c) 2015年 PP. All rights reserved.
//

#import "TableCellItem.h"
#import <UIKit/UIKit.h>

@interface TableCellSwitchItem : TableCellItem

/** 点击开关按钮需要处理的block */
@property (nonatomic, copy) void (^cellClickSwitchHandle) (BOOL on);

/** 开关打开时的颜色 */
@property (nonatomic, strong) UIColor *onTintColor;

/** 开关是否打开 */
@property (nonatomic, assign) BOOL    isOn;

@end
