//
//  ProductCartDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ProductCartDM : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *strPrice;
@property (nonatomic, copy) NSString *value_names;
@property (nonatomic, assign) NSInteger cart_id;
@property (nonatomic, assign) NSInteger item_id;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) NSInteger mivid;

@property (nonatomic, assign) CGFloat   postage;
@property (nonatomic, assign) CGFloat   price;
@property (nonatomic, assign) BOOL    selected;
@property (nonatomic, assign) int     num;

@end
