//
//  QuickRegistrationProtocol.h
//  HWTou
//
//  Created by robinson on 2018/4/13.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger{
    QuickRegistrationTypeRegister,//注册
    QuickRegistrationTypeForgetPswd,//忘记密码
    QuickRegistrationTypePayPswd,//支付密码
}QuickRegistrationType;


@protocol QuickRegistrationProtocol <NSObject>

@end
