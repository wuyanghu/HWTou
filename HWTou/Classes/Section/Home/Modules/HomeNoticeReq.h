//
//  HomeNoticeReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"

@interface HomeNoticeResp : BaseResponse

@property (nonatomic, copy) NSArray *data;

@end

@interface HomeNoticeReq : SessionRequest

+ (void)noticeReqSuccess:(void (^)(HomeNoticeResp *response))success
                 failure:(void (^) (NSError *error))failure;
@end
