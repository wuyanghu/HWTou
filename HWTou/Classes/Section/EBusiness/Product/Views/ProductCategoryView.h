//
//  ProductCategoryView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCategoryList;

@interface ProductCategoryView : UIView

@property (nonatomic, copy) NSArray<ProductCategoryList *> *listData;

@end
