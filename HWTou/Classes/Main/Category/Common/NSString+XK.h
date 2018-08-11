//
//  NSString+XK.h
//  mapgo
//
//  Created by shenliping on 17/2/28.
//  Copyright © 2017年 xiaoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (XK)

+ (BOOL)isNullOrEmpty:(NSString*)str;
+ (NSString*)unescapes:(NSString*)str;
+ (NSString*)unescapes:(NSString*)str def:(NSString*)def;

- (NSInteger)lastIndexOf:(NSString *)searchstring;
- (NSInteger)lastIndexOfI:(NSString *)searchstring;

- (NSInteger)indexOf:(NSString *)searchstring;
- (NSInteger)indexOfI:(NSString *)searchstring;
- (NSInteger)indexOf:(NSString *)searchstring start:(int)start;

- (NSString*)padLeft:(NSInteger)totallength;
- (NSString*)padRight:(NSInteger)totallength;

- (NSString*)remove:(NSString *)what;
- (NSString*)removeI:(NSString *)what;

- (NSString*)replace:(NSString *)what with:(NSString *)with;
- (NSString*)replaceI:(NSString *)what with:(NSString *)with;

- (NSString*)subString:(NSInteger)start;
- (NSString*)subString:(NSInteger)start length:(NSInteger)length;

- (NSString*)trim;
- (NSString*)lTrim;
- (NSString*)rTrim;

- (NSArray*)split:(NSString *)withwhat;

- (BOOL)startsWith:(NSString*)subString;
- (BOOL)endsWith:(NSString*)subString;

- (BOOL)isArchivePath;
- (BOOL)isImagePath;

- (id)jsonValue;

- (CGFloat)heightOfText:(UIFont*)font;
- (CGFloat)heightOfText:(UIFont*)font inSize:(CGSize)size;


- (NSString *)subStringFirst:(void(^)(NSString *word))callback;

// 处理冒泡内容（将换行符用空格替换）
+ (NSString *)replacePublishTextWithText:(NSString *)text;

// 处理读取通讯录数据(删除"-"" ""+86")
+ (NSString *)deleteOtherSymbolWithString:(NSString *)string;

// 处理粉丝数，关注数的显示
+ (NSString *)stringWithTenThousandNumber:(NSInteger)fansNumber;

+ (NSString *)debase64FromString:(NSString *)baseStr;

+ (NSDictionary *)translationJsontoDict:(NSString *)json;

/**  去除所有换行符和空格*/
+ (NSString *)removeSpaceAndNewline:(NSString *)str;

/**  such as 1980-01-01*/
+ (NSString *)generationStringFromBirthday:(NSString *)birthday andSex:(NSInteger)sex;

@end
