//
//  ProductDetailDM.h
//  HWTou
//
//  Created by pengpeng on 17/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@interface ProductDetailDM : NSObject

@property (nonatomic, assign) NSInteger item_id;        // 商品编号
@property (nonatomic, assign) NSInteger stock;          // 当前库存
@property (nonatomic, assign) BOOL      collected_flag; // 收藏标识
@property (nonatomic, assign) CGFloat   price;          // 商品单价
@property (nonatomic, assign) CGFloat   postage;        // 邮费

@property (nonatomic, copy) NSString    *strPrice;

@property (nonatomic, copy) NSString    *title;         // 标题
@property (nonatomic, copy) NSString    *remark;        // 标题描述
@property (nonatomic, copy) NSString    *img_url;       // 展示图片
@property (nonatomic, copy) NSArray     *img_urls;      // 商品图片 list<url>

@end
