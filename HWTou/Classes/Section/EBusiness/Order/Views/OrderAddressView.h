//
//  OrderAddressView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressGoodsDM;

@interface OrderAddressView : UIView

@property (nonatomic, strong) AddressGoodsDM *address;

// 是否隐藏箭头(默认NO)
@property (nonatomic, assign) BOOL hideArrow;

@end
