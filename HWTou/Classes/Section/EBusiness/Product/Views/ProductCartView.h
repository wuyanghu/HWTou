//
//  ProductCartView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCartDM;

@interface ProductCartView : UIView

@property (nonatomic, strong) NSMutableArray *cartList;
@property (nonatomic, assign) BOOL  isEdit;

@end
