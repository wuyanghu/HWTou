//
//  MessageReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

#pragma mark - 请求参数
@interface MessageListParam : BaseParam

@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface MessageMarkParam : BaseParam

@property (nonatomic, assign) NSInteger muid;

@end

@interface MessageNumParam : BaseParam

// 0:未读,1:已读,2全部(可选,默认为未读数量)
@property (nonatomic, assign) NSInteger type;

@end

#pragma mark - 请求响应
@interface MessageListDM : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy  ) NSArray   *list;

@end

@interface MessageResp : BaseResponse

@property (nonatomic, strong) MessageListDM *data;

@end

@interface MessageNumDM : NSObject

@property (nonatomic, assign) NSInteger number;

@end

@interface MessageNumResp : BaseResponse

@property (nonatomic, strong) MessageNumDM *data;

@end

#pragma mark - 请求执行
@interface MessageReq : SessionRequest

// 消息列表
+ (void)listWithParam:(MessageListParam *)param
              success:(void (^)(MessageResp *response))success
              failure:(void (^)(NSError *error))failure;

// 标记已读
+ (void)markWithParam:(MessageMarkParam *)param
              success:(void (^)(BaseResponse *response))success
              failure:(void (^)(NSError *error))failure;

// 消息数目
+ (void)numberWithParam:(MessageNumParam *)param
                success:(void (^)(MessageNumResp *response))success
                failure:(void (^)(NSError *error))failure;

@end
