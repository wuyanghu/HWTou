//
//  ProductListView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailDM;

@interface ProductListView : UIView

@property (nonatomic, copy) NSArray<ProductDetailDM *> *listData;

@property (nonatomic, readonly) UICollectionView *collectionView;

@end
