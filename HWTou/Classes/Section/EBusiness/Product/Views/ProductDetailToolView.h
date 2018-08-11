//
//  ProductDetailToolView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailDelegate.h"

@interface ProductDetailToolView : UIView

@property (nonatomic, weak) id<ProductDetailDelegate> delegate;

/** 购物车数量 */
@property (nonatomic, assign) NSInteger cartNumber;

@property (nonatomic, assign) BOOL collect;

@end
