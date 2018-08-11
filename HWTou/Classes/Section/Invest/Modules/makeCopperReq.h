//
//  makeCopperReq.h
//  HWTou
//
//  Created by 张维扬 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseResponse.h"
#import "InvestParam.h"

@interface makeCopperListReq : BaseResponse
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *images;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *t_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *url;
@end


@interface makeCopperDataReq : BaseResponse
@property (nonatomic, copy) NSArray *list;
@end

@interface makeCopperConfigReq : BaseResponse
@property (nonatomic, strong) makeCopperDataReq *data;
@end

@interface makeCopperReq : BaseRequest
+ (void)requestWithParam:(BaseParam *)param
                 success:(void (^)(makeCopperConfigReq *result))success
                 failure:(void (^)(NSError *error))failure;
@end
