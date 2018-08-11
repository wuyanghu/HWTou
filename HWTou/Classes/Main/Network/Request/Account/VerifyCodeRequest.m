//
//  VerifyCodeRequest.m
//  HWTou
//
//  Created by 彭鹏 on 16/8/13.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "VerifyCodeRequest.h"
#import "NetworkProxy.h"
#import "SecurityTool.h"
#import "YYModel.h"

#pragma mark - 请求参数
@implementation VerifyCodeParam

@synthesize phone;

@end

@implementation VerifyPhoneCodeParam

@synthesize smsCode;

@end

@implementation CodeValidImageParam

@end

@implementation SMSCodeParam

@end

#pragma mark - 请求执行
@implementation VerifyCodeRequest

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost {
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath{

    return sApiPath;
    
}

// 发送注册短信验证码
+ (void)singupWithParam:(SMSCodeParam *)param success:(void (^)(BaseResponse *))success
                failure:(void (^)(NSError *))failure{
    
    sApiPath = @"sms/sendSmsCodeAes";
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    [super requestWithParam:paramDict responseClass:[BaseResponse class] success:success failure:failure];
    
}

// 发送找回密码短信验证码
+ (void)forgetPWWithParam:(SMSCodeParam *)param success:(void (^)(BaseResponse *))success
                  failure:(void (^)(NSError *))failure{
    
    sApiPath = @"user/findPwd";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

// 发送绑定手机短信验证码
+ (void)bindingPhoneWithParam:(SMSCodeParam *)param
                      success:(void (^)(BaseResponse *response))success
                      failure:(void (^)(NSError *error))failure{

    sApiPath = @"sms/index/bind-phones";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

// 验证手机短信验证码
+ (void)verifyPhoneCodeWithParam:(VerifyPhoneCodeParam *)param
                         success:(void (^)(BaseResponse *response))success
                         failure:(void (^)(NSError *error))failure{

    sApiPath = @"sms/checkSmsCode";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

+ (void)imgCodeWithParam:(VerifyCodeParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"code/code-img/index";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

@end


@implementation CodeValidImageRequest

+ (NSString *)requestServerHost {
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath
{
    return @"/imgcode/captchaImage.jpg";
}

+ (HttpRequestMethod)requestMethod
{
    return HttpRequestMethodGet;
}

+ (void)getCodeValidImageWithParam:(void (^) (CodeValidImageParam *response))success
                       failure:(void (^) (NSError *error))failure
{
    [NetworkProxy requestWithClass:[self class] params:nil success:^(id responseObj) {
        CodeValidImageParam * validImageParam = [CodeValidImageParam new];
        validImageParam.imageData = (NSData *)responseObj;
        
        NSString * baseUrlString = [NSString stringWithFormat:@"%@%@",[self requestServerHost],[self requestApiPath]];
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:baseUrlString]];
        NSDictionary * request = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        NSString * cookieString = request[@"Cookie"];
        NSArray *array = [cookieString componentsSeparatedByString:@"="];
        if (array.count>1) {
            validImageParam.codeImage = array[1];
        }
        !success ?: success(validImageParam);
    } failure:^(NSError *error) {
        !failure ?: failure(error);
    }];
}
@end

