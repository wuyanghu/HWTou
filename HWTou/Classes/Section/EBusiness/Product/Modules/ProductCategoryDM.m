//
//  ProductCategoryDM.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCategoryDM.h"

@implementation ProductCategoryDM

@end

@implementation ProductCategoryList

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"children" : [ProductCategoryDM class]};
}

@end
