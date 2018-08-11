//
//  VerifyCodeView.h
//  HWTou
//
//  Created by LeoSteve on 2017/3/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,  VerifyCodeType){
    
    VerifyCodeType_Register = 0,    // 发送注册短信验证码
    VerifyCodeType_Forget,          // 发送找回密码短信验证码
    VerifyCodeType_BindPhone,       // 发送绑定手机短信验证码
    VerifyCodeType_CheckPhone,      // 验证手机短信验证码
    VerifyCodeType_PayPswd,      // 验证支付密码
};

@protocol VerifyCodeViewDelegate <NSObject>

- (void)onModifyPhoneSuccessful;
- (void)onNextStepWithVerCode:(NSString *)verCode withVerifyCodeType:(VerifyCodeType)type;

@end

@interface VerifyCodeView : UIView

@property (nonatomic, weak) id<VerifyCodeViewDelegate> m_Delegate;

- (void)closeTimer;

- (void)setVerifyCodeObtainType:(NSString *)phone withVerifyCodeType:(VerifyCodeType)type;

@end
