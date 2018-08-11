//
//  ActivityContentCategoryVC.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@class ActivityCategoryDM;

@interface ActivityContentCategoryVC : BaseViewController

@property (nonatomic, copy) NSArray<ActivityCategoryDM *> *category;

/** 当前页面对应的索引 */
@property (nonatomic, assign) NSUInteger currentPage;

@end
