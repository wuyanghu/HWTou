//
//  PlayerHistoryModel.m
//  HWTou
//
//  Created by Reyna on 2017/12/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerHistoryModel.h"
#import "RadioModel.h"
#import "TopicWorkDetailModel.h"
#import "PersonHomeDM.h"
#import "GuessULikeModel.h"
#import "HomeBannerListModel.h"

@implementation PlayerHistoryModel

- (void)bindWithDic:(NSDictionary *)dic {
    self.bmg = [dic objectForKey:@"bmg"];
    self.title = [dic objectForKey:@"title"];
    self.rtcId = [[dic objectForKey:@"rtcId"] intValue];
    self.flag = [[dic objectForKey:@"flag"] intValue];
    self.name = [dic objectForKey:@"name"];
    
    self.content = [dic objectForKey:@"content"];
    self.lookNum = [[dic objectForKey:@"lookNum"] intValue];
    self.playing = [dic objectForKey:@"playing"];
    self.lookTime = [dic objectForKey:@"lookTime"];
    self.listenUrl = [dic objectForKey:@"listenUrl"];
    self.roomId = [[dic objectForKey:@"roomId"] intValue];
}

- (void)contentSelfWithPlayerModel:(id)PlayerModel {
    if ([PlayerModel isKindOfClass:[RadioModel class]]) {
        
        RadioModel *radioModel = (RadioModel *)PlayerModel;
        self.bmg = radioModel.channelImg;
        self.title = radioModel.channelName;
        self.rtcId = radioModel.channelId;
        self.flag = 1;
        self.name = @"";
        
        self.content = @"";
        self.lookNum = radioModel.look;
        self.playing = radioModel.playing;
        self.lookTime = @"";
        self.listenUrl = @"";
    }
    else if ([PlayerModel isKindOfClass:[MyTopicListModel class]]) {
        
        MyTopicListModel *topicModel = (MyTopicListModel *)PlayerModel;
        self.bmg = topicModel.bmg;
        self.title = topicModel.title;
        self.rtcId = (int)topicModel.topicId;
        self.flag = 2;
        self.name = @"";
        
        self.content = topicModel.content;
        self.lookNum = (int)topicModel.lookNum;
        self.playing = @"";
        self.lookTime = @"";
        self.listenUrl = @"";
    }else if ([PlayerModel isKindOfClass:[UserDetailModel class]]){
        UserDetailModel * detailModel = (UserDetailModel *)PlayerModel;
        self.bmg = detailModel.bmg;
        self.title = detailModel.title;
        self.rtcId = (int)detailModel.rtcId;
        self.flag = (int)detailModel.flag;
        self.name = @"";
        
        self.content = detailModel.markText;
        self.lookNum = (int)detailModel.lookNum;
        self.playing = @"";
        self.lookTime = @"";
        self.listenUrl = @"";
    }else if ([PlayerModel isKindOfClass:[GuessULikeModel class]]){
        GuessULikeModel * likeModel = (GuessULikeModel *)PlayerModel;
        self.bmg = likeModel.bmgs;
        self.title = likeModel.title;
        self.rtcId = (int)likeModel.rtcId;
        self.flag = (int)likeModel.flag;
        self.name = likeModel.name;
        self.isWorkChat = likeModel.isWorkChat;
        
        self.content = likeModel.content;
        self.lookNum = (int)likeModel.lookNum;
        self.playing = likeModel.playing;
        self.lookTime = likeModel.createTime;
        self.listenUrl = likeModel.playingUrl;
    }else if ([PlayerModel isKindOfClass:[HomeBannerListModel class]]){
        HomeBannerListModel * bannerModel = (HomeBannerListModel *)PlayerModel;
//        self.bmg = bannerModel.bmgs;
        self.bmg = @"";
        self.title = bannerModel.title;
        self.rtcId = (int)bannerModel.rtcId;
        if (bannerModel.clickType == 3) {//广播
            self.flag = 1;
        }else if (bannerModel.clickType == 5){//聊吧
            self.flag = 3;
        }else if (bannerModel.clickType == 7){//话题
            self.flag = 2;
        }

//        self.name = bannerModel.name;
        self.name = @"";
//        self.content = bannerModel.content;
        self.content = @"";
        self.lookNum = (int)bannerModel.lookNum;
//        self.playing = bannerModel.playing;
//        self.lookTime = bannerModel.createTime;
//        self.listenUrl = bannerModel.playingUrl;
        self.playing = @"";
        self.lookTime = @"";
        self.listenUrl = @"";
    }
    else {
        
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.bmg = [aDecoder decodeObjectForKey:@"bmg"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.rtcId = [[aDecoder decodeObjectForKey:@"rtcId"] intValue];
        self.flag = [[aDecoder decodeObjectForKey:@"flag"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.lookNum = [[aDecoder decodeObjectForKey:@"lookNum"] intValue];
        self.playing = [aDecoder decodeObjectForKey:@"playing"];
        self.lookTime = [aDecoder decodeObjectForKey:@"lookTime"];
        self.listenUrl = [aDecoder decodeObjectForKey:@"listenUrl"];
        self.roomId = [[aDecoder decodeObjectForKey:@"roomId"] intValue];
        
        self.isPause = [[aDecoder decodeObjectForKey:@"isPause"] boolValue];
        self.isWorkChat = [[aDecoder decodeObjectForKey:@"isWorkChat"] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.bmg forKey:@"bmg"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.rtcId] forKey:@"rtcId"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.flag] forKey:@"flag"];
    [aCoder encodeObject:self.name forKey:@"name"];
    
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.lookNum] forKey:@"lookNum"];
    [aCoder encodeObject:self.playing forKey:@"playing"];
    [aCoder encodeObject:self.lookTime forKey:@"lookTime"];
    [aCoder encodeObject:self.listenUrl forKey:@"listenUrl"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.roomId] forKey:@"roomId"];
    
    [aCoder encodeObject:[NSNumber numberWithBool:self.isPause] forKey:@"isPause"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isWorkChat] forKey:@"isWorkChat"];
}

@end
