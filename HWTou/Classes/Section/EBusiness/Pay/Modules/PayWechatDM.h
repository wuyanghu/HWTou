//
//  PayWechatDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayWechatDM : NSObject

@property (nonatomic, copy) NSString *appid;

@property (nonatomic, copy) NSString *partnerid;

@property (nonatomic, copy) NSString *prepayid;

@property (nonatomic, copy) NSString *package;

@property (nonatomic, copy) NSString *noncestr;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) UInt32 timestamp;

@end
