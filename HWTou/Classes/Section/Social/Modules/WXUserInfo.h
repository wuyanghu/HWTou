//
//  WXUserInfo.h
//
//  Created by pengpeng on 16/8/22.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXUserInfo : NSObject

@property (nonatomic, copy) NSString *openid;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *headimgurl;

@property (nonatomic, copy) NSString *unionid;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, assign) NSInteger sex;

@end
