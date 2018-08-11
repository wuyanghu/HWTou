//
//  RadioClassModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioClassModel.h"

@implementation RadioClassModel

- (void)bindWithDic:(NSDictionary *)dic {
    self.className = [dic objectForKey:@"className"];
    self.classId = [[dic objectForKey:@"classId"] integerValue];
}

@end
