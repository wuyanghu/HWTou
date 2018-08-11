//
//  AccountModel.h
//  HWTou
//
//  Created by 彭鹏 on 16/8/16.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject

//是否是游客模式
@property (nonatomic, assign) BOOL isVisitorMode;

// 用户名
@property (nonatomic, copy) NSString *userName;//手机号

// 密码
@property (nonatomic, copy) NSString *passWord;

// accessToken
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *imToken;//网易云凭证
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString * nickName;//昵称
@end
