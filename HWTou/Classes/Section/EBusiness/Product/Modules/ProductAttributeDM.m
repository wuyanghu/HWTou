//
//  ProductAttributeDM.m
//  HWTou
//
//  Created by 彭鹏 on 2017/5/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductAttributeDM.h"

@implementation ProductAttListDM

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"prop_value_list" : [ProductAttributeDM class]};
}

@end

@implementation ProductAttStockDM

@end

@implementation ProductAttributeDM

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.height = 34.0f;
    }
    return self;
}

@end
