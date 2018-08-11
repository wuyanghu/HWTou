//
//  NetworkProxy.m
//
//  Created by PP on 15/11/3.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import "FileUploadBody.h"
#import "NetworkProxy.h"
#import "AFNetworking.h"
#import "BaseRequest.h"
#import "SecurityTool.h"

@implementation NetworkProxy

+ (NSURLSessionTask *) requestWithClass:(Class)requestClass
                              params:(NSDictionary *)params
                             success:(void (^)(id))success
                             failure:(void (^)(NSError *))failure
{
    // HTTP请求类必须是BaseRequest或其子类
    NSAssert([requestClass isSubclassOfClass:[BaseRequest class]], @"requestClass is BaseRequest or subClass");
    
    NSString *serverHost = [requestClass requestServerHost];
    NSString *apiPath = [requestClass requestApiPath];
    // 主机地址和API路径不能为空
    NSParameterAssert(serverHost);
    NSParameterAssert(apiPath);
    
//    NSLog(@"==================================================");
//    NSLog(@"请求地址 : %@", [NSString stringWithFormat:@"%@/%@",serverHost,apiPath]);
//    NSLog(@"请求参数 : %@", params);
//    NSLog(@"==================================================");

    HttpRequestMethod method = [requestClass requestMethod];
    HttpRequestSerializerType requestType = [requestClass requestSerializerType];
    HttpResponseSerializerType responseType = [requestClass responseSerializerType];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:serverHost]];
    
    //[self monitorNetworkReachability:manager];
    [self setupSerializerParam:manager requestType:requestType responseType:responseType];
    
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = [requestClass timeoutInterval];
    
    // 设置请求头数据
    NSDictionary *dictHeader = [requestClass setRequestHeader];
    [dictHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    NSURLSessionTask *session = nil;
    // 跟进方法类型具体执行响应请求
    switch (method)
    {
        case HttpRequestMethodGet:
            {
                session =
                [manager GET:apiPath parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    [self requestSuccess:success response:responseObject];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [self requestFailure:failure error:error];
                }];
            }
            break;
        case HttpRequestMethodPost:
            {
                NSArray<FileUploadBody *> *fileBody = [requestClass fileUploadBody];
                if (fileBody.count > 0)
                {
                    session =
                    [manager POST:apiPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        [self setupConstructingBodyWithBlock:formData fileBody:fileBody];
                    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        [self requestSuccess:success response:responseObject];
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        [self requestFailure:failure error:error];
                    }];
                }
                else
                {
                    session =
                    [manager POST:apiPath parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        [self requestSuccess:success response:responseObject];
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        [self requestFailure:failure error:error];
                    }];
                }
            }
            break;
        case HttpRequestMethodDelete:
            {
                session =
                [manager DELETE:apiPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    [self requestSuccess:success response:responseObject];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [self requestFailure:failure error:error];
                }];
            }
            break;
        case HttpRequestMethodPatch:
            {
                session =
                [manager PATCH:apiPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    [self requestSuccess:success response:responseObject];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [self requestFailure:failure error:error];
                }];
            }
            break;
        case HttpRequestMethodPut:
            {
                session =
                [manager PUT:apiPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    [self requestSuccess:success response:responseObject];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [self requestFailure:failure error:error];
                }];
            }
            break;
        case HttpRequestMethodHead:
            {
                session =
                [manager HEAD:apiPath parameters:params success:^(NSURLSessionDataTask *task) {
                    [self requestSuccess:success response:nil];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [self requestFailure:failure error:error];
                }];
            }
            break;
        default:
            NSLog(@"Error, unsupport method type!");
            break;
    }
    return session;
}

+ (void)setupConstructingBodyWithBlock:(id <AFMultipartFormData>)formData
                              fileBody:(NSArray<FileUploadBody *> *)fileBody
{
    [fileBody enumerateObjectsUsingBlock:^(FileUploadBody *file, NSUInteger idx, BOOL *stop) {
        switch (file.dataType)
        {
            case FileUploadDataTypeData:
                NSAssert(file.data != nil, @"file data not is nil");
                if (file.fileName.length > 0 && file.mimeType.length > 0)
                {
                    [formData appendPartWithFileData:file.data name:file.name fileName:file.fileName mimeType:file.mimeType];
                }
                else
                {
                    [formData appendPartWithFormData:file.data name:file.name];
                }
                break;
            case FileUploadDataTypeFileURL:
                NSAssert(file.fileURL != nil, @"file URL not is nil");
                [formData appendPartWithFileURL:file.fileURL name:file.name fileName:file.fileName mimeType:file.mimeType error:nil];
                break;
            case FileUploadDataTypeStream:
                NSAssert(file.inputStream != nil, @"file input stream not is nil");
                [formData appendPartWithInputStream:file.inputStream name:file.name fileName:file.fileName length:file.lengthStream mimeType:file.mimeType];
                break;
        }
    }];
}

/**
 *  @brief 配置请求和响应的序列化
 */
+ (void)setupSerializerParam:(AFHTTPSessionManager *)manager
                 requestType:(HttpRequestSerializerType)requestType
                responseType:(HttpResponseSerializerType)responseType
{
    // 设置请求发送数据类型
    switch (requestType)
    {
        case HttpRequestSerializerTypeData:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case HttpRequestSerializerTypeJSON:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case HttpRequestSerializerTypePlist:
            manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
            break;
        default:
            break;
    }
    
    // 设置响应数据可接受类型
    switch (responseType)
    {
        case HttpResponseSerializerTypeData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case HttpResponseSerializerTypeJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case HttpResponseSerializerTypeXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case HttpResponseSerializerTypePlist:
            manager.responseSerializer = [AFPropertyListResponseSerializer serializer];
            break;
        case HttpResponseSerializerTypeImage:
            manager.responseSerializer = [AFImageResponseSerializer serializer];
            break;
        default:
            break;
    }
}

/**
 *  @brief 请求成功统一处理
 */
+ (void)requestSuccess:(void (^)(id))success response:(id)responseObj
{
    !success ?: success(responseObj);
}

/**
 *  @brief 请求失败统一处理
 */
+ (void)requestFailure:(void (^)(NSError *))failure error:(NSError *)error
{
    !failure ?: failure(error);
    
    if (error.code == NSURLErrorNotConnectedToInternet) {
        NSLog(@"网络不给力");
    } else if (error.code == NSURLErrorCannotConnectToHost) {
        NSLog(@"无法连接服务器");
    }
}

/**
 *  @brief 监听网络
 */
+ (void)monitorNetworkReachability:(AFHTTPSessionManager *)manager
{
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"AFNetworkReachabilityStatus: %d", (int)status);
        switch (status)
        {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown:
                [operationQueue setSuspended:YES];
            default:
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
}

@end
