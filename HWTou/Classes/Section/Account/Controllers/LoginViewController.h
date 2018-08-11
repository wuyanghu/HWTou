//
//  LoginViewController.h
//  HWTou
//  
//  Created by 彭鹏 on 2017/3/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

// 登录成功回调block
typedef void(^LoginSuccessBlock)(void);

@interface LoginViewController : BaseViewController

/**
 登录成功回调block，如果设置后默认不进首页
 */
@property (nonatomic, copy) LoginSuccessBlock loginSuccess;

@end
