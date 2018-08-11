//
//  WithdrawAccountInfoModel.m
//  HWTou
//
//  Created by Reyna on 2018/2/6.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "WithdrawAccountInfoModel.h"

@implementation WithdrawAccountInfoModel

- (void)bindWithDic:(NSDictionary *)dic {
    
    self.tureNameString = [dic objectForKey:@"realname"];
    self.idCardString = [dic objectForKey:@"idCard"];
    self.accountString = [dic objectForKey:@"account"];
}

@end
