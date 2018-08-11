//
//  ShopView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerAdDM;
@class FloorListDM;
@class ProductCategoryList;

@interface ShopView : UIView

@property (nonatomic, readonly) UICollectionView  *collectionView;

// 横幅广告
@property (nonatomic, copy) NSArray<BannerAdDM *> *banners;

// 商品分类
@property (nonatomic, copy) NSArray<ProductCategoryList *> *categorys;

// 楼层信息
@property (nonatomic, copy) NSArray<FloorListDM *> *floors;

@end
