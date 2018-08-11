//
//  FloorListReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

typedef NS_ENUM(NSInteger, FloorListType)
{
    FloorListHome = 1,
    FloorListShop = 2,
};

@interface FloorListParam : BaseParam

@property (nonatomic, assign) FloorListType type;
@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface FloorListResult : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy  ) NSArray   *list;

@end

@interface FloorListResp : BaseResponse

@property (nonatomic, strong) FloorListResult *data;

@end

@interface FloorListReq : SessionRequest

+ (void)floorWithParam:(FloorListParam *)param
               success:(void (^)(FloorListResp *response))success
               failure:(void (^) (NSError *error))failure;

@end
