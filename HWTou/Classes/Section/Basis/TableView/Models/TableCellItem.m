//
//  TableCellItem.m
//
//  Created by pengpeng on 15/10/23.
//  Copyright (c) 2015年 PP. All rights reserved.
//

#import "TableCellItem.h"

@implementation TableCellItem

+ (instancetype)tableItemWithTitle:(NSString *)title
{
    return [self tableItemWithTitle:title icon:nil];
}

+ (instancetype)tableItemWithTitle:(NSString *)title icon:(NSString *)icon
{
    TableCellItem *tableItem = [[self alloc] init];
    tableItem.centerNumberOfLines = 1;
    tableItem.title = title;
    tableItem.icon  = icon;
    
    return tableItem;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.isSelectionState = YES;
        self.cellHeight = 44.0f;
    }
    
    return self;
}

@end
