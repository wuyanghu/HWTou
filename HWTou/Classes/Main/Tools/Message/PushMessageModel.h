//
//  PushMessageModel.h
//  HWTou
//
//  Created by Reyna on 2018/1/10.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMessageModel : NSObject

//1.互动消息。2.非互动消息
@property (nonatomic, copy) NSString *tag;

//对应链接的标志
//<1-互动消息> 1:话题被评论。 2:广播评论被回复。3: 话题评论被回复。4:聊吧评论被回复。5: 被关注消息。6:关注的用户发布了话题。7: 广播评论点赞。8:话题评论点赞。9:聊吧评论点赞
//<2-非互动消息> 1:APP首页。 2:链接。3: 话题详情页面。4:聊吧详情页面。5: 广播详情页面。6：达人主播审核通过。7：达人主播审核未通过
@property (nonatomic, assign) int type;

//链接跳转对应 type 的详情ID
//<1-互动消息> 1：话题ID， 2：广播ID,评论父ID,评论父UID，3：话题ID,评论父ID,评论父UID，4：聊吧ID,评论父ID,评论父UID，5：用户ID，6：话题ID，7：广播ID，8：话题ID，9：聊吧ID
//<2-非互动消息>  1：空， 2：链接地址，3：话题ID，4：聊吧ID，5：广播ID，6：空，7：空
@property (nonatomic, copy) NSString *msg_link;

//推送来源的用户昵称
@property (nonatomic, copy) NSString *nickname;

//1：推送消息。2：系统消息
@property (nonatomic, copy) NSString *msg_type;

+ (PushMessageModel *)bindMessageDic:(NSDictionary *)dic;

@end
