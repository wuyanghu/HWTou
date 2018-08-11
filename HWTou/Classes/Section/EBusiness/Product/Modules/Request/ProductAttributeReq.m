//
//  ProductAttributeReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/5/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductAttributeReq.h"
#import "ProductAttributeDM.h"

@interface ProductAttStockParam ()

@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@implementation ProductAttListParam

@end

@implementation ProductAttStockParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 接口设计如此，实际不需要分页
        self.start_page = 0;
        self.pages = 1000;
    }
    return self;
}

@end

@implementation ProductAttListResp

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [ProductAttListDM class]};
}

@end

@implementation ProductAttStockResp

@end

@implementation ProductAttStockResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [ProductAttStockDM class]};
}

@end

@implementation ProductAttributeReq

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost{
    return kHomeServerHost;
}

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (void)listWithParam:(ProductAttListParam *)param success:(void (^)(ProductAttListResp *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"shop/prop-api/index";
    [super requestWithParam:param responseClass:[ProductAttListResp class] success:success failure:failure];
}

+ (void)stockWithParam:(ProductAttStockParam *)param success:(void (^)(ProductAttStockResp *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"shop/prop-api/all-list";
    [super requestWithParam:param responseClass:[ProductAttStockResp class] success:success failure:failure];
}

@end
