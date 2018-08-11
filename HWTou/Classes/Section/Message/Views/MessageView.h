//
//  MessageView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView

@property (nonatomic, copy) NSArray *listData;

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
