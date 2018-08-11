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
    self.isM = [[dic objectForKey:@"isM"] intValue];
    self.isTop = [[dic objectForKey:@"isTop"] intValue];
    self.vid = [dic objectForKey:@"vid"];
    self.commentFlag = [[dic objectForKey:@"commentFlag"] intValue];
    self.commentImgUrl = [dic objectForKey:@"commentImgUrl"];
    self.redState = [[dic objectForKey:@"redState"] intValue];
    
    if (![self.commentUrl isEqualToString:@""]) {
        double duration_d = [[dic objectForKey:@"duration"] doubleValue];
        self.duration = (int)round(duration_d);
    }
    self.dateAndReplyNum = [NSString stringWithFormat:@"%@   %d条回复",self.createTime,self.replyNum];
    
    if (self.replyNum){
        NSDictionary *replyDic = [dic objectForKey:@"replayList"];
        [self.subModel bindWithDic:replyDic];
    }
    
    CGRect commentRect = [self.commentText boundingRectWithSize:CGSizeMake(kMainScreenWidth - 62, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.commentHeight = commentRect.size.height;
    
    CGRect locationRect = [self.commentLocation boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    self.locationWidth = locationRect.size.width;
    CGFloat locationHeight = [self.commentLocation isEqualToString:@""] ? 0 : 17.f;
    
    CGRect dateRect = [self.dateAndReplyNum boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    self.dateWidth = dateRect.size.width;
    
    if (self.replyNum) {
        NSString *moreStr = [NSString stringWithFormat:@"查看全部%d条回复",self.replyNum];
        CGRect moreRect = [moreStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        self.moreWidth = moreRect.size.width;
        self.replyTotalHeight = self.subModel.first_replyHeight + 18 + 32;
    }
    else {
        self.replyTotalHeight = 0;
        self.moreWidth = 0;
    }
    
    self.imgHeight = 0;
    self.imgsHeight = 0;
    if (self.commentFlag == 1) {
        //含有语音
        self.cellTotalHeight = 56 + 30 + 10 + locationHeight + 17 + self.replyTotalHeight + 6;
        NSString *cellH_Str = [NSString stringWithFormat:@"%.2f", self.cellTotalHeight];
        self.cellTotalHeight = [cellH_Str floatValue];
    }
    else if (self.commentFlag == 2) {
        
        self.imgHeight = (kMainScreenWidth - 62 - 10 - 20)/3.0;
        //含有图片
        
        [self.commentUrlArray removeAllObjects];
        if (![self.commentUrl isEqualToString:@""]) {
            NSArray *imgsDataArr = [self.commentUrl componentsSeparatedByString:@","];
            for (int i=0; i<imgsDataArr.count; i++) {
                [self.commentUrlArray addObject:imgsDataArr[i]];
            }
        }
        
        NSInteger lines = 0;
        if (self.commentUrlArray.count % 3 == 0) {
            lines = self.commentUrlArray.count / 3;
        }
        else {
            lines = self.commentUrlArray.count / 3 + 1;
        }
        if (lines > 0) {
            self.imgsHeight = lines * self.imgHeight + (lines - 1) * 10;
        }
        else {
            self.imgsHeight = 0;
        }
        
        if ([self.commentText isEqualToString:@""]) {
            self.cellTotalHeight = 56 + self.commentHeight + self.imgsHeight + 10 + locationHeight + 17 + self.replyTotalHeight + 6;
        }
        else {
            self.cellTotalHeight = 56 + self.commentHeight + 15 + self.imgsHeight + 10 + locationHeight + 17 + self.replyTotalHeight + 6;
        }
        NSString *cellH_Str = [NSString stringWithFormat:@"%.2f", self.cellTotalHeight];
        self.cellTotalHeight = [cellH_Str floatValue];
    }
    else if (self.commentFlag == 3) {
        //含有视频
        if ([self.commentText isEqualToString:@""]) {
            self.cellTotalHeight = 56 + self.commentHeight + 110 + 10 + 17 + self.replyTotalHeight + 6;
        }
        else {
            self.cellTotalHeight = 56 + self.commentHeight + 15 + 110 + 10 + locationHeight + 17 + self.replyTotalHeight + 6;
        }
        NSString *cellH_Str = [NSString stringWithFormat:@"%.2f", self.cellTotalHeight];
        self.cellTotalHeight = [cellH_Str floatValue];
    }
    else if (self.commentFlag == 4) {
        //红包
        self.cellTotalHeight = 56 + 91 + 10 + locationHeight + 17 + self.replyTotalHeight + 6;
        NSString *cellH_Str = [NSString stringWithFormat:@"%.2f", self.cellTotalHeight];
        self.cellTotalHeight = [cellH_Str floatValue];
    }
    else {
        //纯文字
        self.cellTotalHeight = 51 + self.commentHeight + 10 + locationHeight + 17 + self.replyTotalHeight + 6;
        NSString *cellH_Str = [NSString stringWithFormat:@"%.2f", self.cellTotalHeight];
        self.cellTotalHeight = [cellH_Str floatValue];
    }
}

- (SubCommentModel *)subModel {
    if (!_subModel) {
        _subModel = [[SubCommentModel alloc] init];
    }
    return _subModel;
}

- (NSMutableArray *)commentUrlArray {
    if (!_commentUrlArray) {
        _commentUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _commentUrlArray;
}

@end
