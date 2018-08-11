//
//  UIButton+AutoLoginRequest.m
//  HWTou
//
//  Created by Reyna on 2018/3/6.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "UIButton+AutoLoginRequest.h"
#import "AccountManager.h"

@implementation UIButton (AutoLoginRequest)

- (void)bindAutoLoginTip {
    
    if ([AccountManager shared].account.isVisitorMode == YES) {
        
        
    }
    
}



@end
