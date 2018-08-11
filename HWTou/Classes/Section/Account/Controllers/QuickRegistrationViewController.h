//
//  QuickRegistrationViewController.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "RegisterView.h"
#import "ForgetPwdView.h"



@interface QuickRegistrationViewController : BaseViewController

@property (nonatomic, assign) QuickRegistrationType type;
@property (nonatomic, strong) RegisterView * m_RegisterView;//注册
@property (nonatomic, strong) ForgetPwdView * m_QuickRegView;//忘记密码
@end
