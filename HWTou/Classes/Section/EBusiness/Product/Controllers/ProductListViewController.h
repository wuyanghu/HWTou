//
//  ProductListViewController.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@class ProductCategoryList;

@interface ProductListViewController : BaseViewController

@property (nonatomic, strong) ProductCategoryList *category;

/** 当前页面对应的索引 */
@property (nonatomic, assign) NSUInteger currentPage;

@end
