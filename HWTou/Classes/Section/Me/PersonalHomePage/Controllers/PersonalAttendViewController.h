//
//  PersonalAttendViewController.h
//  HWTou
//  Ta的关注
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PersonalAttendType) {
    personalAttendType,//关注
    personalFansType,//粉丝
};

@interface PersonalAttendViewController : UIViewController
@property (nonatomic,assign) NSInteger uid;//关注用户ID
@property (nonatomic,assign) PersonalAttendType personalAttendType;
@end
