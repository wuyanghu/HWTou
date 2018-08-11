//
//  ScreenRotateTool.m
//
//  Created by PP on 15/8/20.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "ScreenRotateTool.h"

@implementation ScreenRotateTool

+ (void)screenRotateForceOrientation:(UIInterfaceOrientation)orientation
{
#if 0
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget: [UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
#else
    
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
#endif
}
@end
