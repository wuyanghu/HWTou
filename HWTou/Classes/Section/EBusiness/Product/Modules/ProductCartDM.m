//
//  ProductCartDM.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCartDM.h"

@implementation ProductCartDM

- (NSString *)strPrice
{
    return [NSString stringWithFormat:@"¥%.2f", self.price];
}

@end
