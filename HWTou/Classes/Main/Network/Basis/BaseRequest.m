//
//  BaseRequest.m
//
//  Created by PP on 15/11/3.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import "BaseRequest.h"
#import "NetworkProxy.h"
#import "YYModel.h"
#import "DeviceInfoTool.h"
#import "AccountManager.h"

@implementation BaseRequest

+ (NSURLSessionTask *)requestWithParam:(id)param
                         responseClass:(Class)response
                               success:(RequestSuccessBlock)success
                               failure:(RequestFailureBlock)failure
{
//    NSDictionary *params = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([param isKindOfClass:[NSDictionary class]])
    {
//        params = param;
        [params addEntriesFromDictionary:param];
    }
    else
    {
        // 取出参数(模型转字典)
//        params = [param yy_modelToJSONObject];
        [params addEntriesFromDictionary:[param yy_modelToJSONObject]];
    }
    
    [params addEntriesFromDictionary:[BaseRequest getTheCommonDeviceEnvironment]];
    
    NSURLSessionTask *session =
    [NetworkProxy requestWithClass:[self class] params:params success:^(id responseObj) {
        
        id result = responseObj;
        
        if (response) {
            
            result = [response yy_modelWithJSON:responseObj];
            
        }
        else {
            result = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:NULL];
        }
        
        // 调试使用
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:NULL];
//        NSLog(@"response: %@", dict);
        
        !success ?: success(result);
        
    } failure:^(NSError *error) {
        NSLog(@"==================================================");
        NSLog(@"加载数据失败 Error: %@", [error localizedDescription]);
        NSLog(@"Class:: %@", NSStringFromClass([self class]));
        NSLog(@"==================================================");
        
        !failure ?: failure(error);
    }];
    return session;
}

+ (NSString *)requestServerHost
{
    return nil;
}

+ (HttpRequestMethod)requestMethod
{
    return HttpRequestMethodPost;
}

+ (HttpRequestSerializerType)requestSerializerType
{
    return HttpRequestSerializerTypeData;
}

+ (HttpResponseSerializerType)responseSerializerType
{
    return HttpResponseSerializerTypeData;
}

+ (NSTimeInterval)timeoutInterval
{
    return 10.0f;
}

+ (NSString *)requestApiPath
{
    return nil;
}

+ (NSDictionary *)setRequestHeader
{
    return nil;
}

+ (NSArray<FileUploadBody *> *)fileUploadBody
{
    return nil;
}

#pragma mark - Get The Common Device Environment

+ (NSMutableDictionary *)getTheCommonDeviceEnvironment {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@"AppStore" forKey:@"channel"]; //渠道
    
    NSString *netWorkStatus = [DeviceInfoTool getNetworkStatus];
    [dic setObject:netWorkStatus forKey:@"ac"]; //网络环境
    
    [dic setObject:@"简体中文" forKey:@"language"]; //语言
    
    CGSize screenPixel = [DeviceInfoTool getScreenPixel];
    NSString *pixelString = [NSString stringWithFormat:@"%f*%f",screenPixel.width,screenPixel.height];
    [dic setObject:pixelString forKey:@"resolution"]; //分辨率
    
    NSString *IFDVCode = [AccountManager getIFDVCode];
    [dic setObject:IFDVCode forKey:@"phoneDevice"]; //设备码
    
    NSString *deviceModel = [AccountManager getDevicePlatForm];
    [dic setObject:deviceModel forKey:@"phoneType"]; //设备类型
    
    [dic setObject:@"Apple" forKey:@"deviceBrand"]; //设备品牌
    
    [dic setValue:@(2) forKey:@"devicePlatform"]; //设备平台 1: android ,2:ios, 0:未知
    
    NSString *app_Version = [DeviceInfoTool getApplicationVersion];
    [dic setObject:app_Version forKey:@"versionCode"]; //接口版本号
    
    [dic setObject:@"" forKey:@"lng"]; //经度
    [dic setObject:@"" forKey:@"lat"]; //纬度

    return dic;
}

@end
