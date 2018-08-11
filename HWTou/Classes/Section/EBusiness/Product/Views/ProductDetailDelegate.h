//
//  ProductDetailDelegate.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DetailAction)
{
    DetailActionNowBuy,     // 立即购买
    DetailActionCartList,   // 购物车
    DetailActionCollect,    // 收藏/取消
    DetailActionCartAdd,    // 加入购物车
};

@class ProductDetailView;

@protocol ProductDetailDelegate <NSObject>

@optional
- (void)productDetailAction:(DetailAction)action;

@end
