//
//  OrderMailCell.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderMailDM;

@interface OrderMailCell : UITableViewCell

@property (nonatomic, strong) OrderMailDM *dmMail;

/**
 设置当前行数

 @param row 当前行
 @param total 总行数
 */
- (void)setCellRow:(NSInteger)row total:(NSInteger)total;

@end
