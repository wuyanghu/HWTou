//
//  ProductCategoryCell.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCategoryDM;

@interface ProductCategoryTabCell : UITableViewCell

@property (nonatomic, strong) ProductCategoryDM *dmCategory;

@end

@interface ProductCategoryCollCell : UICollectionViewCell

@property (nonatomic, strong) ProductCategoryDM *dmCategory;

@end
