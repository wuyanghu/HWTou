//
//  ComImageUpload.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComImageUpload : NSObject

/**
 单个图片文件上传

 @param image 图片对象
 @param success 上传成功
 @param failure 上传失败
 */
+ (void)singleWithImage:(UIImage *)image
                success:(void (^)(NSString *url))success
                failure:(void (^)(NSString *errMsg))failure;

/**
 图片批量文件上传
 
 @param images 图片对象数组
 @param success 上传成功
 @param failure 上传失败
 */
+ (void)batchWithImages:(NSArray<UIImage *> *)images
                success:(void (^)(NSArray<NSString *> *url))success
                failure:(void (^)(NSString *errMsg))failure;

/**
 单个图片文件上传
 
 @param data 图片文件数据
 @param success 上传成功
 @param failure 上传失败
 */
+ (void)singleWithData:(NSData *)data
               success:(void (^)(NSString *url))success
               failure:(void (^)(NSString *errMsg))failure;

/**
 图片批量文件上传
 
 @param data 图片文件数据数组
 @param success 上传成功
 @param failure 上传失败
 */
+ (void)batchWithMultData:(NSArray<NSData *> *)data
                  success:(void (^)(NSArray<NSString *> *url))success
                  failure:(void (^)(NSString *errMsg))failure;

@end
