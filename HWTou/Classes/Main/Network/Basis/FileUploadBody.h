//
//  FileUploadBody.h
//
//  Created by PP on 15/12/22.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FileUploadDataType)
{
    FileUploadDataTypeData,     // 二进制数据
    FileUploadDataTypeFileURL,  // 文件地址
    FileUploadDataTypeStream    // 输入流
};

@interface FileUploadBody : NSObject

/** 上传文件的数据格式类型 */
@property (nonatomic, assign) FileUploadDataType dataType;

/** 文件输入流(TypeStream 有效) */
@property (nonatomic, strong) NSInputStream *inputStream;

/** 文件流的长度(TypeStream 用到) */
@property (nonatomic, assign) int64_t       lengthStream;

/** 文件URL(TypeFileURL 有效) */
@property (nonatomic, strong) NSURL *fileURL;

/** 二进制数据(TypeData 有效) */
@property (nonatomic, strong) NSData *data;

/** 上传的参数名称 */
@property (nonatomic, copy) NSString *name;

/** 上传到服务器的文件名称 */
@property (nonatomic, copy) NSString *fileName;

/** 上传文件的类型 */
@property (nonatomic, copy) NSString *mimeType;

@end
