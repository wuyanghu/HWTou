//
//  AccountManager.m
//  HWTou
//
//  Created by PP on 16/8/14.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "NSNotificationCenterMacro.h"
#import "BusinessConst.h"
#import "AccountManager.h"
#import "SigninRequest.h"
#import "DataStoreTool.h"
#import "AccountModel.h"
#import "SecurityTool.h"
#import "PushManager.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import "VisitorRequest.h"
#import "PublicHeader.h"
#import "NTESService.h"

@interface AccountManager ()

@property (nonatomic, strong) AccountModel *account;

@end

@implementation AccountManager

SingletonM();

#pragma mark - 类方法

+ (NSString *)passwordEncrypt:(NSString *)password
{
    // 密码加密规则
    password = [SecurityTool md5Encode:password encodeType:MD5EncodeType32Lowercase];
    return password;
}

+ (void)loginByVisitorWithComplete:(void (^)(NSInteger, NSString *, NSInteger))complete failure:(void (^)(NSError *))failure {
    
    [VisitorRequest loginByVisitorWithSuccess:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSDictionary *dataDic = [response objectForKey:@"data"];
            
            AccountManager *manager = [AccountManager shared];
//            [manager account].userName = [dataDic objectForKey:@"nickName"];
            [manager account].token = [dataDic objectForKey:@"token"];
            [manager account].uid = [[dataDic objectForKey:@"uid"] integerValue];
            [manager account].isVisitorMode = YES;
            [manager saveAccount];
            [[PushManager shared] setPushAlias:[[dataDic objectForKey:@"uid"] integerValue]];
        }
        
        !complete ?: complete([[response objectForKey:@"status"] intValue], [response objectForKey:@"msg"], [[[response objectForKey:@"data"] objectForKey:@"uid"] integerValue]);
    } failure:failure];
}

+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                 complete:(void (^)(NSInteger, NSString *, NSInteger))complete
                  failure:(void (^)(NSError *))failure
{
    SigninParam *param = [[SigninParam alloc] init];
    param.username = userName;
    param.password = [self passwordEncrypt:password];
    param.password = password;
    param.phoneType = [AccountManager getDevicePlatForm];
    param.phoneDevice = [AccountManager getIFDVCode];
    
    [SigninRequest signinWithParam:param success:^(SigninResponse *response) {
        
        if (response.status == 200)  {
            AccountManager *manager = [AccountManager shared];
            [manager account].userName = userName;
            [manager account].passWord = password;
            [manager account].token = response.data.token;
            [manager account].imToken = response.data.imToken;
            [manager account].uid = response.data.uid;
            [manager account].isVisitorMode = NO;
            [manager saveAccount];
            [[PushManager shared] setPushAlias:response.data.uid];
            
            [self setLoginNim:[NSString stringWithFormat:@"%ld",response.data.uid] imtoken:response.data.imToken];
        }
        
        !complete ?: complete(response.status, response.msg, response.data.uid);
    } failure:failure];
}

+ (void)setLoginNim:(NSString *)account imtoken:(NSString *)token{

    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        loginData.account = account;
        loginData.token = token;
        
        [[[NIMSDK sharedSDK] loginManager] login:account token:token completion:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"登录失败");
                [self showLoginView];
            }else{
                NSLog(@"登录成功");
                [[NTESServiceManager sharedManager] start];
            }
            
        }];
    }
    
}

+ (BOOL)isNeedToken {
    AccountModel *account = [AccountManager shared].account;
    if (account.token.length > 0) {
        return NO;
    }
    return YES;
}

+ (BOOL)isNeedLogin {
    
    AccountModel *account = [AccountManager shared].account;
    if (account.isVisitorMode) {
        return YES;
    }
    if (account.token.length > 0) {
        return NO;
    }
    return YES;
}

+ (void)showLoginView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_SHOWLOGINVIEW object:nil];
}

#pragma mark - 账号操作
- (BOOL)saveAccount {
    
    if (self.account == nil)
        return NO;
    
    return [NSKeyedArchiver archiveRootObject:self.account toFile:[self accountFilePath]];
}

- (AccountModel *)account {
    
    if (_account == nil) {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self accountFilePath]]) {
            _account = [NSKeyedUnarchiver unarchiveObjectWithFile:[self accountFilePath]];
        } else {
            _account = [[AccountModel alloc] init];
        }
    }
    return _account;
}

- (BOOL)deleteAccount {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:[self accountFilePath]]) {
        return [manager removeItemAtPath:[self accountFilePath] error:nil];
    }
    return YES;
}

- (NSString *)accountFilePath {
    
    return [[DataStoreTool getUserDataDir] stringByAppendingPathComponent:@"account.data"];
}

#pragma mark - GetDevicePlatForm

+ (NSString *)getDevicePlatForm {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]
        || [platform isEqualToString:@"iPhone3,2"]
        || [platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]
        || [platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]
        || [platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]
        || [platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]
        || [platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]
        || [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"]
        || [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"]
        || [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"]
        || [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

#pragma mark - GetIFDVCode

+ (NSString *)getIFDVCode {
    
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end

