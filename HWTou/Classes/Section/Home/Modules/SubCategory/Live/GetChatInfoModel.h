//
//  GetChatInfoModel.h
//  HWTou
//
//  Created by robinson on 2018/3/13.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetChatInfoModel : BaseModel
@property (nonatomic,copy) NSString * chatName;//聊吧名
@property (nonatomic,assign) NSInteger online;//现在在线人数
@property (nonatomic,assign) NSInteger lookNum;//总累计观看人数
@property (nonatomic,assign) NSInteger collectNum;// 收藏量
@property (nonatomic,assign) NSInteger yestLookNum;//昨日累计观看人数
@property (nonatomic,assign) NSInteger yestComment;//昨日评论数
@property (nonatomic,copy) NSString * bmgUrls;//背景图
@property (nonatomic,copy) NSString * labelName;//分类名
@property (nonatomic,copy) NSString * chatTitle;//公告标题
@property (nonatomic,copy) NSString * chatContent;//公告内容
@property (nonatomic,assign) NSInteger isAnchor;//是否有主播：0：否，1：是
@property (nonatomic,copy) NSString * avater;//主播头像
@property (nonatomic,copy) NSString * nickname ;//主播昵称
@property (nonatomic,copy) NSString * sign;//主播签名
@property (nonatomic,assign) NSInteger isFocus;//是否关注：0：否1：是
@property (nonatomic,assign) NSInteger tipNum;//打赏人数
@property (nonatomic,assign) NSInteger tipAllNum;//聊吧总共打赏次数
@property (nonatomic,assign) NSInteger isChatM;//该用户是否是该聊吧的普通管理员，1：是，0：否
@property (nonatomic,assign) NSInteger isMuteUser;//是否是禁言用户，1：是，0：否;
@end
