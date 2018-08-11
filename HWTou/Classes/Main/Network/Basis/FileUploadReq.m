//
//  FileUploadReq.m
//
//  Created by 彭鹏 on 16/9/5.
//  Copyright © 2016年 PP. All rights reserved.
//

#import "FileUploadReq.h"

@implementation FileUploadParam

@end

@implementation FileUploadRespDM

@end

@implementation FileBatchUploadResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"uploaded_files" : [FileUploadRespDM class]};
}

@end

@implementation FileBatchUploadResp

@end

@implementation FileUploadResp

@end

@implementation FileUploadReq

static NSString *sApiPath = nil;

// 临时保存上传文件数据
static NSArray<FileUploadBody *> *sFileBody;

+ (NSString *)requestServerHost
{
    return kFileUrlHost;
}

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (void)uploadWithParam:(FileUploadParam *)param
               fileBody:(FileUploadBody *)fileBody
                success:(void (^)(FileUploadResp *))success
                failure:(void (^)(NSError *))failure{
    
    if (fileBody == nil) {
        NSError *error = [NSError errorWithDomain:@"fileBody is nil" code:-30000 userInfo:nil];
        !failure ?: failure(error);
        return;
        
    }
    sFileBody = @[fileBody];
    sApiPath = kApiFileUpload;
    [super requestWithParam:param responseClass:[FileUploadResp class] success:^(id result) {
        !success ?: success(result);
        [self clearTempData];
    } failure:^(NSError *error) {
        !failure ?: failure(error);
        [self clearTempData];
    }];
}

+ (void)batchUploadWithParam:(FileUploadParam *)param
                   filesBody:(NSArray<FileUploadBody *> *)fileBody
                     success:(void (^)(FileBatchUploadResp *))success
                     failure:(void (^)(NSError *))failure
{
    sFileBody = fileBody;
    sApiPath = kApiFileBatchUpload;
    [super requestWithParam:param responseClass:[FileBatchUploadResp class] success:^(id result) {
        !success ?: success(result);
        [self clearTempData];
    } failure:^(NSError *error) {
        
        !failure ?: failure(error);
        [self clearTempData];
    }];
    
}

+ (HttpResponseSerializerType)responseSerializerType{
    
    return HttpResponseSerializerTypeData;
    
}

+ (NSArray<FileUploadBody *> *)fileUploadBody{
    
    return sFileBody;
    
}

+ (void)clearTempData
{
    sApiPath = nil;
    sFileBody = nil;
}
@end
