//
//  TableCellItem.h
//
//  Created by pengpeng on 15/10/23.
//  Copyright (c) 2015年 PP. All rights reserved.
//
//  用TableCommonItem模型来控制UITableView的显示
//  TableView每行显示的信息包括: 图标、标题、子标题、右边样式(箭头、文字、开关、数字提醒)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TableCellItem : NSObject

/** 图标 */
@property (nonatomic, copy) NSString    *icon;

/** 标题 */
@property (nonatomic, copy) NSString    *title;

/** 标题 (属性字符串) */
@property (nonatomic, copy) NSAttributedString  *titleAttributed;

/** 文本内容(中间位置标题后面) */
@property (nonatomic, copy) NSString    *textCenter;

/** 文本内容行数(default 1) */
@property(nonatomic, assign) NSInteger  centerNumberOfLines;

/** 子标题(显示到第二行) */
@property (nonatomic, copy) NSString    *subTitle;

/** 正标题与子标题间距(显示到第二行) */
@property (nonatomic, assign) CGFloat   subTitleSpace;

/** 副标题(显示在右边) */
@property (nonatomic, copy) NSString    *detailTitle;

/** 右边样式(数字提醒值) */
@property (nonatomic, copy) NSString    *badgeValue;

/** 点击Cell跳转的目标控制器 */
@property (nonatomic, assign) Class     destViewController;

/** cell是否需要选中状态默认为YES */
@property (nonatomic, assign) BOOL      isSelectionState;

/** 是否隐藏分割线默认为NO */
@property (nonatomic, assign) BOOL      isHideSeparator;

/** 文本输入框x坐标(对齐作用) */
@property (nonatomic, assign) CGFloat   textCoordX;

/** cell的高度(默认为44) */
@property (nonatomic, assign) CGFloat   cellHeight;

/** 点击Cell后向做的操作 */
@property (nonatomic, copy) void (^cellDidSelectHandle)(void);

/** 副标题颜色(显示在右边) */
@property (nonatomic, strong) UIColor   *detailTitleColor;

/** 中间文本颜色 */
@property (nonatomic, strong) UIColor   *textCenterColor;

#pragma mark - 类方法实例化对象
+ (instancetype)tableItemWithTitle:(NSString *)title;
+ (instancetype)tableItemWithTitle:(NSString *)title icon:(NSString *)icon;

@end
