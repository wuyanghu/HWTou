//
//  TableCellTextFieldItem.h
//
//  Created by pengpeng on 15/11/24.
//  Copyright (c) 2015年 PP. All rights reserved.
//

#import "TableCellItem.h"
#import <UIKit/UIKit.h>

/**
 *  输入框文本编辑改变时block
 *
 *  @param text 文本内容
 */
typedef void (^CellTextFieldChanged)(NSString *text);

/**
 *  输入框文本编辑改变时替换内容
 *
 *  @param text 文本内容
 *
 *  @return 替换自定义文本内容
 */
typedef NSString* (^CellTextReplaceChanged)(NSString *text);

@interface TableCellTextFieldItem : TableCellItem

/** 输入框文本 */
@property (nonatomic, strong) NSString *text;

/** 占位字符串 */
@property (nonatomic, strong) NSString *placeholder;

/** 文本颜色 */
@property (nonatomic, strong) UIColor  *textColor;

/** 键盘类型 */
@property(nonatomic, assign)  UIKeyboardType keyboardType;

/** 禁用文字输入 */
@property (nonatomic, assign) BOOL isDisableEdit;

/** 安全输入框 */
@property (nonatomic, assign) BOOL secureTextEntry;

/** 文本框输入最大字符长度(0则不限制字符长度) */
@property (nonatomic, assign) NSUInteger textMaxLength;

/** 输入框文本编辑改变时回调 */
@property (nonatomic, copy) CellTextFieldChanged cellTextFieldChanged;

/** 输入框文本编辑改变时替换文本 */
@property (nonatomic, copy) CellTextReplaceChanged cellTextReplaceChanged;

@end
