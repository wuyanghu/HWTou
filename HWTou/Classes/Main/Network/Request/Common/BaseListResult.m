//
//  BaseListResult.m
//  HWTou
//
//  Created by PP on 16/8/18.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "BaseListResult.h"

@interface BaseListResult ()

+ (Class)getObjectClassInArray;

@end

@implementation BaseListModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [BaseListResult getObjectClassInArray]};
}

@end

@implementation BaseListResult

+ (Class)getObjectClassInArray
{
    Class clazz = nil;
    if ([self respondsToSelector:@selector(objectClassInList)]) {
        clazz = [self objectClassInList];
    }
    return clazz;
}

@end
