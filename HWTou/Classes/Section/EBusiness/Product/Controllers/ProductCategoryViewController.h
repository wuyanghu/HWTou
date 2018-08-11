//
//  ProductCategoryViewController.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@class ProductCategoryList;

@interface ProductCategoryViewController : BaseViewController

@property (nonatomic, copy) NSArray<ProductCategoryList *> *categorys;

@end
