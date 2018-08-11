//
//  SetPasswordViewController.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

#import "SetPwdView.h"

@interface SetPasswordViewController : BaseViewController

- (id)initWithOperationType:(OperationType)type withPhone:(NSString *)phone
                withVerCode:(NSString *)verCode;

@end
