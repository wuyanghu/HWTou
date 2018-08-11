//
//  VerifyCodeViewController.h
//  HWTou
//
//  Created by LeoSteve on 2017/3/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

#import "VerifyCodeView.h"

@interface VerifyCodeViewController : BaseViewController

- (id)initWithVerifyCodeObtainType:(VerifyCodeType)type withPhone:(NSString *)phone pwd:(NSString *)pwd imgCode:(NSString *)imgCode;

@end
