//
//  ProductAttributeView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailDM;

/**
 商品数量发生改变

 @param result 数量值
 */
typedef void(^ProductNumberChangeBlock)(int result);

@interface ProductAttributeView : UIView

@property (nonatomic, assign) int startNum;

@property (nonatomic, strong) ProductDetailDM   *dmProduct;

@property (nonatomic, copy) ProductNumberChangeBlock changeBlock;

@end
