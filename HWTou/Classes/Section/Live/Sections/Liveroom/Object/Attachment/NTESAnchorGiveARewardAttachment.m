//
//  NTESAnchorGiveARewardAttachment.m
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "NTESAnchorGiveARewardAttachment.h"
#import "NTESCustomKeyDefine.h"

@implementation NTESAnchorGiveARewardAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *attach = @{
                             NTESCMType:@(NTESCustomAttachTypeGiveAReward),
                        NTESCMData:@{NTESCMGiftMoney:self.money}
                             };
    NSData *data = [NSJSONSerialization dataWithJSONObject:attach options:0 error:nil];
    NSString *str = @"{}";
    if (data) {
        str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return str;
}

@end
