//
//  PushMessageModel.m
//  HWTou
//
//  Created by Reyna on 2018/1/10.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "PushMessageModel.h"

@implementation PushMessageModel

+ (PushMessageModel *)bindMessageDic:(NSDictionary *)dic {
    PushMessageModel *m = [[PushMessageModel alloc] init];
    
    m.tag = [dic objectForKey:@"tag"];
    m.type = [[dic objectForKey:@"type"] intValue];
    m.msg_link = [dic objectForKey:@"msg_link"];
    m.nickname = [dic objectForKey:@"nickname"];
    m.msg_type = [dic objectForKey:@"msg_type"];

    return m;
}

@end
