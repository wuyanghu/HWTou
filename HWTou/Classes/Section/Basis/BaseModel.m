//
//  BaseModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)bindWithDic:(NSDictionary *)dic {
}

+ (NSString *)safeFromatWithString:(NSString *)string {
    
    if (string) {
        if ([string isKindOfClass:[NSNull class]]) {
            return @"";
        }
        return string;
    }
    return @"";
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
