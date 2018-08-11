//
//  AccountModel.m
//  HWTou
//
//  Created by 彭鹏 on 16/8/16.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "AccountModel.h"
#import "PersonHomeReq.h"

@implementation AccountModel

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.isVisitorMode = [decoder decodeBoolForKey:@"isVisitorMode"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.passWord = [decoder decodeObjectForKey:@"passWord"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.uid = [decoder decodeIntegerForKey:@"uid"];
        _nickName = [decoder decodeObjectForKey:@"nickName"];
        self.imToken = [decoder decodeObjectForKey:@"imToken"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeBool:self.isVisitorMode forKey:@"isVisitorMode"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.passWord forKey:@"passWord"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeInteger:self.uid forKey:@"uid"];
    [encoder encodeObject:_nickName forKey:@"nickName"];
    [encoder encodeObject:self.imToken forKey:@"imToken"];
}

- (NSString *)nickName{
    if (!_nickName) {
        [self requestInfo];
    }
    return _nickName;
}

- (void)requestInfo{
    UserInfoParam * homeParam = [UserInfoParam new];
    homeParam.uid = 0;
    //个人资料
    [PersonHomeRequest getUserInfo:homeParam Success:^(PersonHomeResponse *response) {
        if (response.status == 200) {
            PersonHomeDM * personHomeModel = response.data;
            _nickName = personHomeModel.nickname;
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
