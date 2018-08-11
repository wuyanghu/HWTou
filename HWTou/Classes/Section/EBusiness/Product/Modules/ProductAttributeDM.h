//
//  ProductAttributeDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/5/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

// 商品属性状态值
typedef NS_ENUM(NSUInteger, ProductAttrState) {
    ProductAttrStateNormal,     // 正常
    ProductAttrStateDisabled,   // 不可用
    ProductAttrStateSelected,   // 已选择
};

@interface ProductAttributeDM : NSObject

@property (nonatomic, assign) ProductAttrState state;
@property (nonatomic, assign) float width;  // 宽度
@property (nonatomic, assign) float height; // 默认34.0f

@property (nonatomic, assign) NSInteger value_id;
@property (nonatomic, assign) NSInteger prop_id;
@property (nonatomic, copy) NSString    *value_name;
@property (nonatomic, copy) NSArray     *img_url;

@end

@interface ProductAttListDM : NSObject

@property (nonatomic, assign) NSInteger prop_id;
@property (nonatomic, copy) NSString    *prop_name;
@property (nonatomic, copy) NSArray<ProductAttributeDM *> *prop_value_list;

@end

@interface ProductAttStockDM : NSObject

@property (nonatomic, copy  ) NSString  *value_ids;
@property (nonatomic, copy  ) NSString  *value_names;
@property (nonatomic, assign) NSInteger mivid;
@property (nonatomic, assign) NSInteger stock;  // 当前库存
@property (nonatomic, assign) CGFloat   price;  // 商品单价
@property (nonatomic, assign) CGFloat   postage;// 邮费

@end
