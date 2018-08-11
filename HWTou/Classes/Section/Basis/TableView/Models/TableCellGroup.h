//
//  TableCellGroup.h
//
//  Created by pengpeng on 15/10/23.
//  Copyright (c) 2015年 PP. All rights reserved.
//
//  用一个TableCellGroup模型来描述每组的信息: 组头、组尾、这组的所有行模型

#import <UIKit/UIKit.h>

@interface TableCellGroup : NSObject

/** 组头 */
@property (nonatomic, copy) NSString *header;

/** 组尾 */
@property (nonatomic, copy) NSString *footer;

/** 头视图 */
@property (nonatomic, strong) UIView *headerView;

/** 脚视图 */
@property (nonatomic, strong) UIView *footerView;

/** 头视图的高度 */
@property (nonatomic, assign) CGFloat  footerHeight;

/** 脚视图的高度 */
@property (nonatomic, assign) CGFloat  headerHeight;

/** 这组数据所有Cell数据的模型(存放TableCellItem模型) */
@property (nonatomic, strong) NSArray *cellItems;

+ (instancetype)tableGroup;

@end
