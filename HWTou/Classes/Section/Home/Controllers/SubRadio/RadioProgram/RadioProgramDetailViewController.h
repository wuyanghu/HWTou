//
//  RadioProgramDetailViewController.h
//  HWTou
//
//  Created by robinson on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,TIMETYPE) {
    yesterdayType,
    todayType,
    tomorrowType
};

@interface RadioProgramDetailViewController : BaseViewController
- (instancetype)initWithTimeType:(TIMETYPE)timetype;
@property (nonatomic,assign) NSInteger channelId;
@end
