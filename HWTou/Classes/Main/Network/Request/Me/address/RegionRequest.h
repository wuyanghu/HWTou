//
//  RegionRequest.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

#define kDIC_Region_Province    (@"Province")
#define kDIC_Region_City        (@"City")
#define kDIC_Region_Area        (@"Area")

typedef NS_ENUM(NSInteger, RegionType){
    
    RegionType_Province = 1,    // 省
    RegionType_City,            // 市
    RegionType_Area,            // 区
    RegionType_End,
    
};

#pragma mark - 请求参数
@interface RegionParam : BaseParam

@property (nonatomic, assign) NSInteger type;           // 1：省,2:市，3:区
@property (nonatomic, assign) NSInteger region_id;      // 区域编号,Type为2、3时必填

@end

#pragma mark - 请求响应 结果
@interface RegionResult : NSObject

@property (nonatomic, assign) NSInteger id;             // 区域编号
@property (nonatomic, strong) NSString *name;           // 区域名称

@end

#pragma mark - 请求响应
@interface RegionResponse : BaseResponse

@property (nonatomic, strong) NSArray<RegionResult *> *data;

@end

#pragma mark - 请求执行
@interface RegionRequest : SessionRequest

/**
 *  @brief 获取地区列表
 *
 *  @param param    RegionParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)obtainRegionListWithParam:(RegionParam *)param
                          success:(void (^)(RegionResponse *response))success
                          failure:(void (^)(NSError *error))failure;

@end
