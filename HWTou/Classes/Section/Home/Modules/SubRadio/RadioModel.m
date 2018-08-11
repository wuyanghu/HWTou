//
//  RadioModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioModel.h"

@implementation RadioModel

- (void)bindWithDic:(NSDictionary *)dic {
    self.channelName = [dic objectForKey:@"channelName"];
    self.channelImg = [dic objectForKey:@"channelImg"];
    self.playing = [dic objectForKey:@"playing"];
    
    self.targetID = [dic objectForKey:@"targetID"];
    self.look = [[dic objectForKey:@"look"] intValue];
    self.channelId = [[dic objectForKey:@"channelId"] intValue];
    self.radioId = [[dic objectForKey:@"radioId"] intValue];
    self.isRed = [[dic objectForKey:@"isRed"] intValue];
}

@end
