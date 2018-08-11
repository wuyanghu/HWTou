//
//  LoginView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LoginMode){
    
    LoginMode_Default = 0,      // 默认登录
    LoginMode_ExistingAcc = 1,  // 已有账号登录
    
};

@protocol LoginViewDelegate <NSObject>

- (void)onToRegister;
- (void)onLoginSuccessful;
- (void)onForgetPassword:(NSString *)phone;

@end

@interface LoginView : UIView

@property (nonatomic, weak) id<LoginViewDelegate> m_Delegate;

- (void)setLoginWay:(LoginMode)mode;

@end
