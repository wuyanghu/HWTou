//
//  SocialShareDM.h
//
//  Created by 彭鹏 on 2017/4/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

// 社交分享类型
typedef NS_ENUM(NSInteger, SocialShareType)
{
    SocialShareWXFriend,       // 微信好友
    SocialShareWXTimeline,     // 微信朋友圈
    SocialShareQQFriend,       // QQ好友
    SocialShareQQZone,         // QQ空间
    SocialShareWeibo,          // 微博
};

@interface SocialShareDM : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgNor;
@property (nonatomic, copy) NSString *imgHlt;
@property (nonatomic, assign) BOOL   disable;
@property (nonatomic, assign) SocialShareType shareType;

@end
