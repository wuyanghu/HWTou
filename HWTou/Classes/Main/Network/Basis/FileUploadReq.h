//
//  FileUploadReq.h
//
//  Created by 彭鹏 on 16/9/5.
//  Copyright © 2016年 PP. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "FileUploadBody.h"

#pragma mark - 请求参数
@interface FileUploadParam : NSObject

@property (nonatomic, copy) NSArray *name;

@end

#pragma mark - 请求响应
@interface FileUploadRespDM : BaseResponse

@property (nonatomic, copy) NSString  *url;

@end

@interface FileUploadResp : BaseResponse

@property (nonatomic, strong) FileUploadRespDM  *data;

@end

@interface FileBatchUploadResult : NSObject

@property (nonatomic, copy) NSArray  * urlList;

@end

@interface FileBatchUploadResp : BaseResponse

@property (nonatomic, strong) FileBatchUploadResult  *data;

@end

#pragma mark - 请求执行
@interface FileUploadReq : BaseRequest

// 单个文件上传
+ (void)uploadWithParam:(FileUploadParam *)param
               fileBody:(FileUploadBody *)fileBody
                success:(void (^)(FileUploadResp *response))success
                failure:(void (^)(NSError *error))failure;

// 批量文件上传
+ (void)batchUploadWithParam:(FileUploadParam *)param
                   filesBody:(NSArray<FileUploadBody *> *)fileBody
                     success:(void (^)(FileBatchUploadResp *response))success
                     failure:(void (^)(NSError *error))failure;
@end
