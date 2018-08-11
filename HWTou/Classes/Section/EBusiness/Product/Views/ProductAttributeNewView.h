//
//  ProductAttributeNewView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/5/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailDM;
@class ProductAttListDM;
@class ProductAttStockDM;
@class ProductAttributeDM;

/**
 商品数量改变
 @param number 数量
 */
typedef void(^ProductAttrNumberBlock)(NSInteger number);

/**
 商品规格改变
 @param stock  商品组合属性
 @param selAtt 已选择的规格
 */
typedef void(^ProductAttributeBlock)(ProductAttStockDM *stock, NSArray<ProductAttributeDM *> *selAtt);

@interface ProductAttributeNewView : UIView

@property (nonatomic, strong) ProductDetailDM   *dmProduct;
@property (nonatomic, copy) NSArray<ProductAttListDM *>  *listAttribute;
@property (nonatomic, copy) NSArray<ProductAttStockDM *> *listStock;

@property (nonatomic, copy) ProductAttributeBlock blockAttribute;
@property (nonatomic, copy) ProductAttrNumberBlock blockNubmer;
@property (nonatomic, assign) NSInteger startNum;

@end
