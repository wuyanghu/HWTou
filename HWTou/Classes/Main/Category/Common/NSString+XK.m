//
//  NSString+XK.m
//  mapgo
//
//  Created by shenliping on 17/2/28.
//  Copyright © 2017年 xiaoku. All rights reserved.
//

#import "NSString+XK.h"

@implementation NSString (XK)

+ (BOOL)isNullOrEmpty:(NSString*)str {
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    if(str == nil)
        return true;
    
    return [str isEqualToString:@""];
}

+ (NSString*)unescapes:(NSString*)str {
    return [NSString unescapes:str def:nil];
}

+ (NSString*)unescapes:(id)str def:(NSString*)def {
    if(str && str!= [NSNull null])
        return [str stringByRemovingPercentEncoding];
    else
        return def;
}

- (NSInteger)lastIndexOf:(NSString *)searchstring {
    
    NSRange start=[self rangeOfString:searchstring options:NSBackwardsSearch];
    if (start.location == NSNotFound)
        return -1;
    else
        return self.length - start.location - searchstring.length;
}

- (NSInteger)lastIndexOfI:(NSString *)searchstring {
    
    NSRange start=[self rangeOfString:searchstring options:NSBackwardsSearch+NSCaseInsensitiveSearch];
    if (start.location == NSNotFound)
        return -1;
    else
        return start.location;
}

- (NSInteger)indexOf:(NSString *)searchstring {
    NSRange start=[self rangeOfString:searchstring];
    if (start.location == NSNotFound)
        return -1;
    else
        return start.location;
}


- (NSInteger)indexOfI:(NSString *)searchstring {
    NSRange start=[self rangeOfString:searchstring options:NSCaseInsensitiveSearch];
    if (start.location == NSNotFound)
        return -1;
    else
        return start.location;
}

- (NSInteger)indexOf:(NSString *)searchstring start:(int)start {
    NSRange start2=[self rangeOfString:searchstring options:NSCaseInsensitiveSearch range:NSMakeRange(start, self.length-start) ];
    
    if (start2.location == NSNotFound)
        return -1;
    else
        return start2.location;
}

- (NSString *)subString:(NSInteger)start {
    NSRange srange=NSMakeRange(start,[self length]-start);
    
    return [self substringWithRange:srange];
}


- (NSString *)subString:(NSInteger)start length:(NSInteger)length {
    NSRange srange=NSMakeRange(start,length);
    
    return [self substringWithRange:srange];
}

- (NSString *)replace:(NSString *)what with:(NSString *)with {
    return [self stringByReplacingOccurrencesOfString:what withString:with];
}

- (NSString *)replaceI:(NSString *)what with:(NSString *)with {
    NSRange range = NSMakeRange(0, [self length]);
    return [self stringByReplacingOccurrencesOfString:what withString:with options:NSCaseInsensitiveSearch range:range];
}

- (NSString *)remove:(NSString *)what {
    return [self stringByReplacingOccurrencesOfString:what withString:@""];
}

- (NSString *)removeI:(NSString *)what {
    NSRange range = NSMakeRange(0, [self length]);
    return [self stringByReplacingOccurrencesOfString:what withString:@"" options:NSCaseInsensitiveSearch range:range];
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)lTrim {
    
    if ([self length]==0) return self;
    NSInteger i=0;
    
    while (i<[self length])
    {
        unichar thechar = [self characterAtIndex:i];
        if (thechar==' ' || thechar=='\n')
        {
            i++;
        }
        else
        {
            break;
        }
        
    }
    
    return [self subString:i];
}

- (NSString *)rTrim {
    
    NSInteger i=[self length]-1;
    if (i==-1) return self;
    
    while (i>0)
    {
        unichar thechar = [self characterAtIndex:i];
        if (thechar==' ' || thechar=='\n')
        {
            i--;
        }
        else
        {
            break;
        }
        
    }
    
    return [self subString:0 length:i+1];
}

- (NSArray *)split:(NSString *)withwhat {
    NSArray *chunks = [self componentsSeparatedByString: withwhat];
    return chunks;
}

- (NSString*)padRight:(NSInteger)totallength {
    if ([self length]>=totallength) return self;
    return [self stringByPaddingToLength:totallength withString: @" " startingAtIndex:0];
}

- (NSString *)padLeft:(NSInteger)totallength {
    if ([self length]>=totallength) return self;
    
    NSString *emptyString = @"";
    NSString *padString = [emptyString stringByPaddingToLength:totallength-[self length] withString:@" " startingAtIndex:0];
    return [padString stringByAppendingString:self];
}

- (BOOL)startsWith:(NSString*)subString {
    return [self indexOf:subString]==0;
}


- (BOOL)endsWith:(NSString*)subString {
    NSInteger idx = [self lastIndexOf:subString];
    return idx==0;
}

- (BOOL)isArchivePath {
    NSString* name = [self lowercaseString];
    
    return ([name endsWith:@".zip"] || [name endsWith:@".rar"] || [name endsWith:@".7z"]||
            [name endsWith:@".cbz"] || [name endsWith:@".cbr"] || [name endsWith:@".cb7"]);
}

- (BOOL)isImagePath {
    NSString* name = [self lowercaseString];
    
    return ([name endsWith:@".jpg"] || [name endsWith:@".png"] || [name endsWith:@".gif"]);
}

- (id)jsonValue {
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (CGFloat)heightOfText:(UIFont*)font {
    return [self sizeWithAttributes:@{ NSFontAttributeName : font}].height;
}

- (CGFloat)heightOfText:(UIFont*)font inSize:(CGSize)size {
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil];
    
    return rect.size.height;
}


- (NSString *)subStringFirst:(void(^)(NSString *word))callback {
    NSRange fullRange = NSMakeRange(0, [[self trim] length]);
    [[self trim] enumerateSubstringsInRange:fullRange
                                    options:NSStringEnumerationByComposedCharacterSequences
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         if (substringRange.location == 0) {
             if (callback) {
                 callback(substring);
             }
         }
     }];
    return nil;
}

+ (NSString *)replacePublishTextWithText:(NSString *)text {
    // 先将所有换行符替换成空格
    NSString *str = text;
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSString *pattern = @"[\" \"]+";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive error: &error];
    NSArray *match = [regex matchesInString: str options: NSMatchingReportCompletion range: NSMakeRange(0, [str length])];
    if (!error) {
        if (match.count != 0) {
            for (NSInteger i = match.count - 1; i >= 0; i --) {
                NSTextCheckingResult *result = match[i];
                str = [str stringByReplacingCharactersInRange:result.range withString:@" "];
            }
        }
        return str;
    } else {
        NSLog(@"%@", error);
        return nil;
    }
}

+ (NSString *)deleteOtherSymbolWithString:(NSString *)string {
    NSString *str1 = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    return str3;
}

+ (NSString *)stringWithTenThousandNumber:(NSInteger)fansNumber {
    NSString *string;
    if (fansNumber > 10000) {
        string = [NSString stringWithFormat:@"%.1fw", fansNumber/10000.0];
    } else {
        string = [NSString stringWithFormat:@"%ld", fansNumber];
    }
    return string;
}

+ (NSString *)debase64FromString:(NSString *)baseStr {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:baseStr options:0];
    NSString *jsonStr = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+ (NSDictionary *)translationJsontoDict:(NSString *)json {
    if (json == nil) {
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    ;
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}

+ (NSString *)removeSpaceAndNewline:(NSString *)str {
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

+ (NSString *)generationStringFromBirthday:(NSString *)birthday andSex:(NSInteger)sex {
    NSString *result = @"";
    NSString *year = [birthday componentsSeparatedByString:@"-"].firstObject;
    if (year) {
        NSInteger num = [year integerValue];
        NSString *suffix = @"";
        if (sex == 2) {
            suffix = @"女生";
        }
        if (sex == 1) {
            suffix = @"男生";
        }
        if (num>2000) {
            result = @"00后";
        } else if (num > 1995) {
            result = @"95后";
        } else if (num > 1990) {
            result = @"90后";
        } else if (num > 1980) {
            result = @"80后";
        } else {
            result = @"80前";
            if (sex == 2) {
                suffix = @"女神";
            }
            if (sex == 1) {
                suffix = @"男神";
            }
        }
        result = [NSString stringWithFormat:@"%@%@", result, suffix];
    }
    return result;
}

@end
