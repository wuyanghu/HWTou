//
//  ProductCommentListView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCommentListView : UIView

@property (nonatomic, copy) NSArray *listData;
@property (nonatomic, readonly) UITableView *tableView;

@end
