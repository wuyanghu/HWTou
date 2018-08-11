//
//  RegularExTool.m
//
//  Created by PP on 16/7/12.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "RegularExTool.h"

@implementation RegularExTool

//昵称 4-20个字符，包含汉字，字母，下划线
+ (BOOL)validateNickName:(NSString *)nickName{
    NSInteger strLength = [self textLength:nickName];
    
    NSString *regex = @"[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if((strLength>=4 && strLength<=20) && [pred evaluateWithObject: nickName]){
        return YES;
    }
    return NO;
}
//签名
+ (BOOL)validateSign:(NSString *)sign{
    NSInteger signLength = [self textLength:sign];
    if (signLength<200) {
        return YES;
    }
    return NO;
}

//判断一段字符串长度(汉字2字节)
+ (NSUInteger)textLength:(NSString *) text{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
    
}

// 身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

// 邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13, 15, 18开头, 八个 \d 数字字符
    NSString *phoneRegex = @"^1[3|4|5|7|8]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

// 车牌号验证
+ (BOOL)validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}

// 校验IP地址
+ (BOOL)validateIPAddress:(NSString *)ipAddress
{
    if ([ipAddress isEqualToString:@"0.0.0.0"] ||
        [ipAddress isEqualToString:@"255.255.255.255"])
    {
        return NO;
    }
    NSString *ipRegex = @"^((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))$";
    NSPredicate *ipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ipRegex];
    return [ipTest evaluateWithObject:ipAddress];
}

// 校验端口号
+ (BOOL)validatePort:(NSString *)port
{
    NSString *portRegex = @"^([1-9]\\d{0,3}|[1-5]\\d{4}|6[0-5]{2}[0-3][0-5])(-([1-9]\\d{0,3}|[1-5]\\d{4}|6[0-5]{2}[0-3][0-5]))?$";
    NSPredicate *portTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",portRegex];
    return [portTest evaluateWithObject:port];
}

// 校验是否只包含数字或字母(不能输入特殊字符)
+ (BOOL)validateLetterOrNumber:(NSString *)input
{
    NSString *inputRegex = @"^[a-zA-Z0-9]+$";
    NSPredicate *inputPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", inputRegex];
    return [inputPredicate evaluateWithObject:input];
}

// 校验是否只包含数字
+ (BOOL)validateOnlyIsNumber:(NSString *)input
{
    NSString *inputRegex = @"^[0-9]*$";
    NSPredicate *inputPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", inputRegex];
    return [inputPredicate evaluateWithObject:input];
}

// 校验是否只包含字母
+ (BOOL)validateOnlyIsLetter:(NSString *)input
{
    NSString *inputRegex = @"^[a-zA-Z]*$";
    NSPredicate *inputPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", inputRegex];
    return [inputPredicate evaluateWithObject:input];
}

// 验证输入的密码是否符合标准 (6位以上的数字和字母组成)
+ (BOOL)validatePassWord:(NSString *)input{

    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:input];
    
}

@end
