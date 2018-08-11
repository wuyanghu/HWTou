//
//  BannerAdReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

typedef NS_ENUM(NSInteger, BannerAdType)
{
    BannerAdHome,       // 首页
    BannerAdShop,       // 花钱
    BannerAdActivity,   // 美好
    BannerAdCalabash,   // 乐葫芦
    BannerAdInvset      // 赚铜钱
};

@interface BannerAdParam : BaseParam

@property (nonatomic, assign) BannerAdType type;

@end

@interface BannerAdList : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy  ) NSArray   *list;

@end

@interface BannerAdResp : BaseResponse

@property (nonatomic, strong) BannerAdList *data;

@end

@interface BannerAdReq : SessionRequest

+ (void)bannerWithParam:(BannerAdParam *)param
                success:(void (^)(BannerAdResp *response))success
                failure:(void (^) (NSError *error))failure;

@end
