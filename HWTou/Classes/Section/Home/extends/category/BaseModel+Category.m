//
//  BaseModel+Category.m
//  HWTou
//
//  Created by robinson on 2018/4/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel+Category.h"

@implementation BaseModel (Category)
- (NSString *)getCountDownTime:(NSInteger)squInterVal{
    if (squInterVal<0) {
        return @"0小时0分钟0秒";
    }
    NSInteger hour = squInterVal/3600;
    NSInteger minute = squInterVal%3600/60;
    NSInteger second = squInterVal%60;
    
    NSString * hourStr;
    if (hour<10) {
        hourStr = [NSString stringWithFormat:@"%ld",hour];
    }else{
        hourStr = [NSString stringWithFormat:@"%ld",hour];
    }
    
    NSString * minuteStr;
    if (minute<10) {
        minuteStr = [NSString stringWithFormat:@"0%ld",minute];
    }else{
        minuteStr = [NSString stringWithFormat:@"%ld",minute];
    }
    
    NSString * secondStr;
    if (second<10) {
        secondStr = [NSString stringWithFormat:@"0%ld",second];
    }else{
        secondStr = [NSString stringWithFormat:@"%ld",second];
    }
    
    NSString * countDownTime = [NSString stringWithFormat:@"%@小时%@分钟%@秒",hourStr,minuteStr,secondStr];
    
    return countDownTime;
}
@end
