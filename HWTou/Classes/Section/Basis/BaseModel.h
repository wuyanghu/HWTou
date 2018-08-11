//
//  BaseModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (void)bindWithDic:(NSDictionary *)dic;

+ (NSString *)safeFromatWithString:(NSString *)string;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (id)valueForUndefinedKey:(NSString *)key;
@end
