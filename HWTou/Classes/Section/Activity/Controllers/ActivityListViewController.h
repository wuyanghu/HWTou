//
//  ActivityListViewController.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@interface ActivityListViewController : BaseViewController

@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, assign) BOOL onlyApplied; // 仅显示报名列表

@end
