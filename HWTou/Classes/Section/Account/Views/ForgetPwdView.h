//
//  QuickRegView.h
//  HWTou
//  忘记密码
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickRegistrationProtocol.h"

@protocol ForgetPwdViewDelegate <NSObject>

@optional
- (void)onToLogIn;
- (void)onNextStepWithRegPhone:(NSString *)regPhone pwd:(NSString *)pwd imgCode:(NSString *)imgCode;

@end

@interface ForgetPwdView : UIView
@property (nonatomic, assign) QuickRegistrationType type;
@property (nonatomic, weak) id<ForgetPwdViewDelegate> m_Delegate;
@property (nonatomic,copy) NSString * phone;
@end
