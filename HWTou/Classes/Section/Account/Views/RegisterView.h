//
//  QuickRegView.h
//  HWTou
//  忘记密码
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickRegistrationProtocol.h"

typedef enum : NSUInteger {
    RegisterGetCodeBtnTag,//获取短信验证码
    RegisterGoLoginBtnTag,//已有账号去登录
    RegistercipherBtnTag,//隐藏密码
} RegisterButtonTag;

@protocol RegisterViewDelegate <NSObject>

@optional
- (void)onToLogIn;
- (void)onNextStepWithRegPhone:(NSString *)regPhone pwd:(NSString *)pwd imgCode:(NSString *)imgCode;
- (void)visitorLoginMode;

@end

@interface RegisterView : UIView

@property (nonatomic, weak) id<RegisterViewDelegate> m_Delegate;

@property (nonatomic,copy) NSString * phone;//手机号

@end
