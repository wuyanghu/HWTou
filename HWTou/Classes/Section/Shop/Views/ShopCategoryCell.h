//
//  ShopCategoryCell.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCategoryList;
@class ActivityCategoryDM;

@interface ShopCategoryCell : UICollectionViewCell

@property (nonatomic, strong) ProductCategoryList *category;
@property (nonatomic, strong) ActivityCategoryDM  *actCategory;

@end
