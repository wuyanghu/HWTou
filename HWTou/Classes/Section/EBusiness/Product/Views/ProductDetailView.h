//
//  ProductDetailView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailDelegate.h"

@class ProductDetailDM;
@class ProductCommentDM;
@class ProductAttListDM;
@class ProductAttStockDM;
@class ProductAttributeDM;

@interface ProductDetailView : UIView

@property (nonatomic, weak) id<ProductDetailDelegate> delegate;

/** 商品数据 */
@property (nonatomic, strong) ProductDetailDM *dmProduct;

@property (nonatomic, copy) NSArray<ProductAttListDM *>  *listAttribute;

@property (nonatomic, copy) NSArray<ProductAttStockDM *> *listStock;

/** 评论数据 */
@property (nonatomic, strong) ProductCommentDM *dmComment;

/** 购物车数量 */
@property (nonatomic, assign) NSInteger cartNumber;

/** 商品数量 */
@property (nonatomic, assign) NSInteger productNum;

/** 是否收藏 */
@property (nonatomic, assign) BOOL collect;

@property (nonatomic, assign) BOOL isShowAttribute;

@property (nonatomic, strong) ProductAttStockDM *dmStock;

@property (nonatomic, copy) NSArray<ProductAttributeDM *> *selAtt;

- (void)showProductAttribute;

@end
