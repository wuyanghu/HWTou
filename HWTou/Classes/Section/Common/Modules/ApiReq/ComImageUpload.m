//
//  ComImageUpload.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "NSError+URLErrorCode.h"
#import "ComImageUpload.h"
#import "FileUploadReq.h"

@implementation ComImageUpload

+ (void)singleWithImage:(UIImage *)image success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = UIImageJPEGRepresentation(image, 0.9);
        [self singleWithData:data success:success failure:failure];
    });
}

+ (void)batchWithImages:(NSArray<UIImage *> *)images success:(void (^)(NSArray<NSString *> *))success failure:(void (^)(NSString *))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *imgsData = [NSMutableArray arrayWithCapacity:images.count];
        [images enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL *stop) {
            NSData *data = UIImageJPEGRepresentation(obj, 0.9);
            [imgsData addObject:data];
        }];
        
        [self batchWithMultData:imgsData success:success failure:failure];
    });
}

+ (void)singleWithData:(NSData *)data success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    FileUploadBody *fileBody = [self createFileBody:data];
    [FileUploadReq uploadWithParam:nil fileBody:fileBody success:^(FileUploadResp *response) {
        if (response.status == 200) {
            !success ?: success(response.data.url);
        } else {
            !failure ?: failure(response.msg);
        }
    } failure:^(NSError *error) {
        !failure ?: failure([error urlErrorCodeDescribe]);
    }];
}

+ (void)batchWithMultData:(NSArray<NSData *> *)data success:(void (^)(NSArray<NSString *> *))success failure:(void (^)(NSString *))failure
{
    NSMutableArray *filesBody = [NSMutableArray arrayWithCapacity:data.count];
    [data enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
        FileUploadBody *fileBody = [self createFileBody:obj];
        fileBody.name = @"imgs";
        [filesBody addObject:fileBody];
    }];
    
    [FileUploadReq batchUploadWithParam:nil filesBody:filesBody success:^(FileBatchUploadResp *response) {
        if (response.status == 200) {
            NSMutableArray *url_files = [NSMutableArray arrayWithCapacity:data.count];
            [url_files addObjectsFromArray:response.data.urlList];
            !success ?: success(url_files);
        } else {
            !failure ?: failure(response.msg);
        }
    } failure:^(NSError *error) {
        !failure ?: failure([error urlErrorCodeDescribe]);
    }];
}

+ (FileUploadBody *)createFileBody:(NSData *)data
{
    FileUploadBody *fileBody = [[FileUploadBody alloc] init];
    fileBody.dataType = FileUploadDataTypeData;
    fileBody.data = data;
    fileBody.name = @"img";
    
    // 取时间戳作为文件名
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    fileBody.fileName = [NSString stringWithFormat:@"%ld.jpg", (long)timestamp];
    fileBody.mimeType = @"image/jpeg";
    
    return fileBody;
}
@end
