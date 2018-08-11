//
//  ProductEnjoyCell.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCartDM;
@class OrderProductDM;
@class ProductCollectDM;

@class ProductCartCell;
@class ProductEnjoyCell;

@protocol CartCellDelegate <NSObject>

@optional
- (void)cartCell:(ProductCartCell *)cell didSelectItem:(BOOL)select;

@end

@protocol ProductCellDelegate <NSObject>

@optional
- (void)onRefundEventOrder:(OrderProductDM *)order;

@end

// 属于用户的商品（已在购物车、订单、收藏中）
@interface ProductEnjoyCell : UITableViewCell

@property (nonatomic, strong) ProductCartDM *cartProduct;

@property (nonatomic, strong) OrderProductDM *orderProduct;

@property (nonatomic, strong) ProductCollectDM *collectProduct;

/**
 是否隐藏分割线，默认显示
 */
@property (nonatomic, assign) BOOL hideSeparator;

@end

// 购物车
@interface ProductCartCell : ProductEnjoyCell

@property (nonatomic, weak) id<CartCellDelegate> delegate;

@end

// 购物车编辑
@interface ProductCartEditCell : ProductCartCell

@end

// 商品退款
@interface ProductRefundCell : ProductEnjoyCell

@property (nonatomic, weak) id<ProductCellDelegate> delegate;

@end

@interface ProductCollectCell : ProductEnjoyCell

@end
