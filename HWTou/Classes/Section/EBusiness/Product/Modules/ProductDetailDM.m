//
//  ProductDetailDM.m
//  HWTou
//
//  Created by pengpeng on 17/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductDetailDM.h"

@implementation ProductDetailDM

- (NSString *)strPrice
{
    return [NSString stringWithFormat:@"¥%.2f", self.price];
}

@end
