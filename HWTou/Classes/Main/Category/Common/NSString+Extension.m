//
//  NSString+Extension.m
//
//  Created by PP on 16/5/21.
//  Copyright © 2016年 PP. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)convertToGBK
{
    NSStringEncoding enc = CFStringConvertNSStringEncodingToEncoding(kCFStringEncodingGB_18030_2000);
    NSString *ret = [[NSString alloc] initWithFormat:@"%@", [self stringByAddingPercentEscapesUsingEncoding:enc]];
    return ret;
}

- (NSString *)trimming
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)urlEncode
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedString;
}

- (BOOL)isContainEmoji
{
    __block BOOL isEmoji = NO;
    
    NSStringEnumerationOptions options = NSStringEnumerationByComposedCharacterSequences;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:options usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
        const unichar hs = [substring characterAtIndex:0];
        
        if (0xd800 <= hs && hs <= 0xdbff)
        {
            if (substring.length > 1)
            {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                
                if (0x1d000 <= uc && uc <= 0x1f77f)
                {
                    isEmoji = YES;
                }
            }
        }
        else if (substring.length > 1)
        {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3)
            {
                isEmoji = YES;
            }
        }
        else
        {
            if (0x2100 <= hs && hs <= 0x27ff && hs !=0x263b)
            {
                isEmoji = YES;
            }
            else if (0x2B05 <= hs && hs <= 0x2b07)
            {
                isEmoji = YES;
            }
            else if (0x2934 <= hs && hs <= 0x2935)
            {
                isEmoji = YES;
            }
            else if (0x3297 <= hs && hs <= 0x3299)
            {
                isEmoji = YES;
            }
            else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0x231a)
            {
                isEmoji = YES;
            }
        }
        
        if (isEmoji) {
            *stop = YES;
        }
    }];
    
    return isEmoji;
}

@end
