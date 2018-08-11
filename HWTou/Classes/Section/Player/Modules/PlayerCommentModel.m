//
//  PlayerCommentModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerCommentModel.h"
#import "PublicHeader.h"

@implementation PlayerCommentModel

- (void)bindWithDic:(NSDictionary *)dic {
    self.avater = [dic objectForKey:@"avater"];
    self.nickName = [dic objectForKey:@"nickName"];
    self.createTime = [dic objectForKey:@"createTime"];
    self.replyNum = [[dic objectForKey:@"replyNum"] intValue];
    self.praiseNum = [[dic objectForKey:@"praiseNum"] intValue];
    self.parentUid = [[dic objectForKey:@"parentUid"] intValue];
    self.commentText = [dic objectForKey:@"commentText"];
    self.commentUrl = [dic objectForKey:@"commentUrl"];
    self.commentLocation = [dic objectForKey:@"commentLocation"];
    self.parentCommentId = [[dic objectForKey:@"parentCommentId"] intValue];
    self.state = [[dic objectForKey:@"state"] intValue];
    self.isPraise = [[dic objectForKey:@"isPraise"] intValue];
    
    self.dateAndReplyNum = [NSString stringWithFormat:@"%@   %d条回复",self.createTime,self.replyNum];
    
    if (self.replyNum){
        NSDictionary *replyDic = [dic objectForKey:@"replayList"];
        [self.subModel bindWithDic:replyDic];
    }
    
    CGRect commentRect = [self.commentText boundingRectWithSize:CGSizeMake(kMainScreenWidth - 62, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.commentHeight = commentRect.size.height;
    
    CGRect dateRect = [self.dateAndReplyNum boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    self.dateWidth = dateRect.size.width;
    
    if (self.replyNum) {
        
        if (self.replyNum > 1) {
            NSString *moreStr = [NSString stringWithFormat:@"查看全部%d条回复",self.replyNum];
            CGRect moreRect = [moreStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            self.moreWidth = moreRect.size.width;
            self.replyTotalHeight = self.subModel.replyHeight + 18 + 32;
        }
        else {
            self.replyTotalHeight = self.subModel.replyHeight + 18 + 15;
            self.moreWidth = 0;
        }
    }
    else {
        self.replyTotalHeight = 0;
        self.moreWidth = 0;
    }
    
    self.cellTotalHeight = 51 + self.commentHeight + 10 + 17 + self.replyTotalHeight + 6;
    NSString *cellH_Str = [NSString stringWithFormat:@"%.2f", self.cellTotalHeight];
    self.cellTotalHeight = [cellH_Str floatValue];
//    self.cellTotalHeight = self.commentHeight + self.replyTotalHeight + 100;
}

- (SubCommentModel *)subModel {
    if (!_subModel) {
        _subModel = [[SubCommentModel alloc] init];
    }
    return _subModel;
}

@end
