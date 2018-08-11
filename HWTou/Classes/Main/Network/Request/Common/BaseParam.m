//
//  BaseParam.m
//  HWTou
//
//  Created by 彭鹏 on 16/8/16.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "AccountManager.h"
#import "BaseParam.h"

@implementation BaseParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.token = [[AccountManager shared] account].token;
//        self.access_token = [[AccountManager shared] account].token;
    }
    return self;
}
@end
