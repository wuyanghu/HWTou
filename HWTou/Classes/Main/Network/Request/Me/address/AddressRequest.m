//
//  AddressRequest.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AddressRequest.h"

#import "AddressGoodsDM.h"

typedef NS_ENUM(NSInteger, AddressRequestType){
    
    AddressRequestType_Index,   // 地址列表
    AddressRequestType_Add,     // 新增
    AddressRequestType_Delete,  // 删除收货地址
    AddressRequestType_Top,     // 设置默认收货地址
    AddressRequestType_Modify,  // 修改收货地址
    
};

#pragma mark - 请求参数
@implementation AddressParam
@synthesize token;
@synthesize maid,p_id,city_id,d_id;
@synthesize name,tel,address,post_code;



@end

#pragma mark - 请求响应
@implementation AddressResponse
@synthesize data;

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"data" : [AddressGoodsDM class]};
    
}

@end

@implementation AddressAddResp

@end

@implementation AddressAddResult

@end

#pragma mark - 请求执行
@implementation AddressRequest

static AddressRequestType requestType;

+ (NSString *)requestApiPath{
    
    NSString *apiStr;
    
    switch (requestType) {
        case AddressRequestType_Index:{
            
            apiStr = @"shop/address-api/index";
            
            break;}
        case AddressRequestType_Add:{
            
            apiStr = @"shop/address-api/add";
            
            break;}
        case AddressRequestType_Delete:{
            
            apiStr = @"shop/address-api/delete";
            
            
            break;}
        case AddressRequestType_Top:{
            
            apiStr = @"shop/address-api/top";
            
            break;}
        case AddressRequestType_Modify:{
            
            apiStr = @"shop/address-api/modify";
            
            break;}
        default:
            break;
    }
    
    return apiStr;
    
}

+ (void)addConsigneeAddressWithParam:(AddressParam *)param
                             success:(void (^)(AddressAddResp *response))success
                             failure:(void (^)(NSError *error))failure{

    requestType = AddressRequestType_Add;
    
    [super requestWithParam:param responseClass:[AddressAddResp class]
                    success:success failure:failure];
    
}

+ (void)obtainConsigneeAddressList:(void (^)(AddressResponse *response))success
                           failure:(void (^)(NSError *error))failure{

    requestType = AddressRequestType_Index;
    [super requestWithParam:[BaseParam new] responseClass:[AddressResponse class]
                    success:success failure:failure];
    
}

+ (void)deleteConsigneeAddressWithParam:(AddressParam *)param
                                success:(void (^)(BaseResponse *response))success
                                failure:(void (^)(NSError *error))failure{

    requestType = AddressRequestType_Delete;
    [super requestWithParam:param responseClass:[BaseResponse class]
                    success:success failure:failure];
    
}

+ (void)topConsigneeAddressWithParam:(AddressParam *)param
                             success:(void (^)(BaseResponse *response))success
                             failure:(void (^)(NSError *error))failure{

    requestType = AddressRequestType_Top;
    [super requestWithParam:param responseClass:[BaseResponse class]
                    success:success failure:failure];
    
}

+ (void)modifyConsigneeAddressWithParam:(AddressParam *)param
                                success:(void (^)(BaseResponse *response))success
                                failure:(void (^)(NSError *error))failure{

    requestType = AddressRequestType_Modify;
    [super requestWithParam:param responseClass:[BaseResponse class]
                    success:success failure:failure];
    
}

@end
