//
//  HomeRadioSignModel.m
//  HWTou
//
//  Created by Reyna on 2018/3/29.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HomeRadioSignModel.h"

@implementation HomeRadioSignModel

- (void)bindWithDic:(NSDictionary *)dic {
    
    self.rtcId = [[dic objectForKey:@"rtcId"] intValue];
    self.name = [dic objectForKey:@"name"];
    self.bmg = [dic objectForKey:@"bmg"];
}

@end
