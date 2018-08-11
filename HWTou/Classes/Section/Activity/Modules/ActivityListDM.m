//
//  ActivityListDM.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityListDM.h"
#import "DateFormatTool.h"

@implementation ActivityListDM

- (void)setEnd_time:(NSString *)end_time
{
    _end_time = end_time;
    self.endDate = [DateFormatTool dateFormatFromString:end_time withFormat:nil];
}

- (void)setStart_time:(NSString *)start_time
{
    _start_time = start_time;
    self.startDate = [DateFormatTool dateFormatFromString:start_time withFormat:nil];
}

@end
