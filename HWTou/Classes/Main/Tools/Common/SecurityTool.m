//
//  SecurityTool.h
//
//  Created by 彭鹏 on 14-9-20.
//  Copyright (c) 2014年 PP. All rights reserved.
//

#import "SecurityTool.h"
#import <CommonCrypto/CommonCrypto.h>
#import "PublicHeader.h"

@implementation SecurityTool

#pragma mark - MD5加密算法
+ (NSString *)md5Encode:(NSString *)input encodeType:(MD5EncodeType)encodeType
{
    if (input.length > 0)
    {
        const char *cStr = [input UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        switch (encodeType)
        {
            case MD5EncodeType16Lowercase:
            case MD5EncodeType32Lowercase:
                for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                {
                    [output appendFormat:@"%02x", digest[i]];
                }
                break;
            case MD5EncodeType16Capital:
            case MD5EncodeType32Capital:
                for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                {
                    [output appendFormat:@"%02X", digest[i]];
                }
                break;
                
            default:
                break;
        }
        
        NSString *result = output;
        
        if (MD5EncodeType16Lowercase == encodeType || MD5EncodeType16Capital == encodeType)
        {
            // 16位取的是32位字符串中间16位
            result = [output substringWithRange:NSMakeRange(8, 16)];
        }
        return result;
    }
    return nil;
}

#pragma mark - AES加解密算法
+ (NSString *)aesDecode:(NSString *)input secretKey:(NSString *)secretKey
{
    if (input.length > 0)
    {
        // 先进行Base64解码
        NSData *inputData = [[NSData alloc] initWithBase64EncodedString:input options:0];
        NSData *decodeData = [self aes256Decrypt:inputData secretKey:secretKey];
        
        NSString *strResult = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
        
        return strResult;
    }
    
    return nil;
}

+ (NSString *)aesEncode:(NSString *)input secretKey:(NSString *)secretKey
{
    if (input.length > 0)
    {
        NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encodeData = [self aes256Encrypt:inputData secretKey:secretKey];
        
        // Base64编码
        NSString *strResult = [encodeData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        
        return strResult;
    }
    
    return nil;
}

#pragma mark AES加密
+ (NSData *)aes256Encrypt:(NSData *)inputData secretKey:(NSString *)secretKey
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    // fetch key data
    [secretKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [inputData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [inputData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

#pragma mark AES解密
+ (NSData *)aes256Decrypt:(NSData *)inputData secretKey:(NSString *)secretKey
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    // fetch key data
    [secretKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [inputData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [inputData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

#pragma mark - SHA256加密
+ (NSString *)sha256Encode:(NSString *)input
{
    const char *cstr = [input UTF8String];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x",digest[i]];
    }
    
    return output;
}

#pragma mark - 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

+ (NSDictionary *)getAesDict:(NSDictionary *)paramsDict{
    
//    NSLog(@"请求参数 : %@",paramsDict);

    NSString * jsonParams = [self convertToJsonData:paramsDict];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeInterval timeSp = [datenow timeIntervalSince1970];
    
    NSDictionary * key_valueDict = [self getRandomDict];
    
    NSString * secretKey = [SecurityTool md5Encode:[NSString stringWithFormat:@"Rbson412%@%ld",key_valueDict[@"appSecret"],(long)timeSp/60] encodeType:MD5EncodeType16Lowercase];
    jsonParams = [self aesEncode:jsonParams secretKey:secretKey];
    NSDictionary * params = @{@"appKey":key_valueDict[@"appKey"],@"aesStr":jsonParams};
    return params;
}

+ (NSDictionary *)getRandomDict{
    NSArray * keyValueArray = @[
     @{
         @"appKey": @"026e31f8458b4a4ca71c4a85f85e87a3",
         @"appSecret": @"c7d1a18a835a4c1e9d6cc03e65a9cfeb"
     },
     @{
         @"appKey": @"0b0848546f6d4009a75c59f2f1057fa8",
         @"appSecret": @"8f08ebbff5e44d2fb0f4bd98b9968206"
     },
     @{
         @"appKey": @"0c25ca25a892473eab684213452ca145",
         @"appSecret": @"e47af29cc6e144ae8f24ce159f61818a"
     },
     @{
         @"appKey": @"0d2180dc698a4179a3307064d89045dc",
         @"appSecret": @"9e55d3e93693418fa9c8ad5192697ccc"
     },
     @{
         @"appKey": @"0f02f8fee2fd41dc82013bf238104fb5",
         @"appSecret": @"cc1bd86466d54efaae6f625f2a303aa0"
     },
     @{
         @"appKey": @"168d45bc54644baa9b3f1fefad8cbe33",
         @"appSecret": @"72bac007ef774db6ab244676727b5d60"
     },
     @{
         @"appKey": @"178d55a084b14fb7b523ff849d7bca7d",
         @"appSecret": @"00cd6d7ffe1d492b9fa870f5daddfb27"
     },
     @{
         @"appKey": @"28aa18a8e06e43c490f2a7644ae9c0be",
         @"appSecret": @"009c5265173a4e218484e03e67e88c2b"
     },
     @{
         @"appKey": @"2a7fd47bcb6a462791d482a29224ce31",
         @"appSecret": @"dcf5980db6134552af73b4e6248a6588"
     },
     @{
         @"appKey": @"370eb975295f47589f2125728ac1d8a3",
         @"appSecret": @"a1138ececf604e2699bdd28625cbf32a"
     },
     @{
         @"appKey": @"3cf28a3c27d64e9ea50e7696dcc790c0",
         @"appSecret": @"44e6307a51284785848d804193d37d6f"
     },
     @{
         @"appKey": @"40981c2479294069be96e1495c79494d",
         @"appSecret": @"55a95b3579d94f1684073c51c141b237"
     },
     @{
         @"appKey": @"5a2c93e500e34312b326155e2a57161b",
         @"appSecret": @"3c2c98eb3c554e9a98450642c06a4a95"
     },
     @{
         @"appKey": @"65a58f30fc4449ddb31ba6648a770015",
         @"appSecret": @"4f15c341f4024780a021f72b926fa4ab"
     },
     @{
         @"appKey": @"68f8a8075dcf42da8a575d38c0f298b7",
         @"appSecret": @"9ef6b014dc4a438191f156e4b677f2a9"
     },
     @{
         @"appKey": @"6d871fea406f41ea93c636fa4d9b7f7b",
         @"appSecret": @"4a384bb9b4534b148d38956fdacc7b0a"
     },
     @{
         @"appKey": @"6db0af4f13f54767b274eebc95c8c923",
         @"appSecret": @"13889ca616394b6cabf63c7d33ddd5f0"
     },
     @{
         @"appKey": @"756f12ac4fbd4fbbbb6b3f45099b456a",
         @"appSecret": @"596e478bc145496f8837d1e361f2572a"
     },
     @{
         @"appKey": @"8643f51c1fe24e67aaf5ccd5e6894a20",
         @"appSecret": @"4cf79fda837545e69f0c436203679e91"
     },
     @{
         @"appKey": @"8a4d020c1bd84c4f9809e2347e4c0d73",
         @"appSecret": @"02662f2fa8464de0a62c3b45f97e3e6d"
     },
     @{
         @"appKey": @"8dea279f03bb4d6ea0c84cd4527c7fdd",
         @"appSecret": @"ba153706e1044f68bd2c4dca84e96ab7"
     },
     @{
         @"appKey": @"9f634eddc71145db99e7f5115b4fd881",
         @"appSecret": @"79a12df8b9ae4b6fb880c4688548d630"
     },
     @{
         @"appKey": @"a0299478fcdf4ff4815ce450d1e739c4",
         @"appSecret": @"78e029d90b7f41a989c90bb67c000235"
     },
     @{
         @"appKey": @"abb43fdb23dd41689a504657e82ec70a",
         @"appSecret": @"e2fd06e6e60d4cf8a99379332be6b9f9"
     },
     @{
         @"appKey": @"abd9416bda8b4296aeaa1674a76f9b15",
         @"appSecret": @"c3460448e6104ce995554931c4d443e5"
     },
     @{
         @"appKey": @"ad64afb14f2a4f4c8e681581f8c67bb4",
         @"appSecret": @"90b82bcb2c4e49cfa23673180502ae64"
     },
     @{
         @"appKey": @"b0b72e5dfeb248349460506be96ad04d",
         @"appSecret": @"8d3ef79904414ffcb5a11581d283685c"
     },
     @{
         @"appKey": @"b4124980579846f9bf69e4a806d80b7a",
         @"appSecret": @"8b816bf574814b92a247779628f1928f"
     },
     @{
         @"appKey": @"b78ddeda8e9341e19c898e9d966342c1",
         @"appSecret": @"4bbcc5bc08c34d4eaeece9d40aec5e99"
     },
     @{
         @"appKey": @"ba9181b102b34395b1722f44a733f3a2",
         @"appSecret": @"89c5e795222043efacf3bd0e3b5e0b3a"
     },
     @{
         @"appKey": @"bdfc2d101d2d4803809a49c06cbedb5d",
         @"appSecret": @"9a3e042a296c41179df13878c6ab57e0"
     },
     @{
         @"appKey": @"cb71fb0e6ea640b7b6badc3f23180db9",
         @"appSecret": @"4955e5d954a04e88b95ab82f514c99d8"
     },
     @{
         @"appKey": @"cd435fc136264cd8a50a7a5fad5937c0",
         @"appSecret": @"8c8245a7e7494125bdde6ae7035f0d60"
     },
     @{
         @"appKey": @"cf61552cc59b46259001a9d08cb24823",
         @"appSecret": @"0da28bd8c10f4fcfaf77f417f75c2c78"
     },
     @{
         @"appKey": @"d2406800f71642b5b06eebf782801a89",
         @"appSecret": @"2e73a5670ffa404ba6f05e22734a964c"
     },
     @{
         @"appKey": @"d5c761deecda4bbd986ee97cdf76b0e2",
         @"appSecret": @"3eccae551a6e44118e86e0fc993110c6"
     },
     @{
         @"appKey": @"e45b05df77d64793ad4232fd36925bed",
         @"appSecret": @"891123ee7ad34575a4b0c666bf0a024f"
     },
     @{
         @"appKey": @"e6b412b87d7d440c82412978b67b5c46",
         @"appSecret": @"876336abc3bb49a3bc128ca783dc6f4e"
     },
     @{
         @"appKey": @"e8d4fe461b89409eb5d1114ee49a91a3",
         @"appSecret": @"34c5c6d46f834ceabff0ec0fdd586218"
     },
     @{
         @"appKey": @"f109e820ae524002a0a5764b3783026f",
         @"appSecret": @"e7ad63f108fd4e2e95404a388d6db0c3"
     },
     ];
    
    NSInteger index = arc4random()%keyValueArray.count;
    return keyValueArray[index];
}

@end
