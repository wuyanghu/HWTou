//
//  NTESAnchorDiscloseAttachment.m
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "NTESAnchorDiscloseAttachment.h"
#import "NTESCustomKeyDefine.h"

@implementation NTESAnchorDiscloseAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *attach = @{
                             NTESCMType:@(NTESCustomAttachTypeDiscloseReward),
                             NTESCMData:@{NTESCMGiftMoney:self.money,NTESCMConnectMicName:self.nickName}
                             };
    NSData *data = [NSJSONSerialization dataWithJSONObject:attach options:0 error:nil];
    NSString *str = @"{}";
    if (data) {
        str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return str;
}

@end
