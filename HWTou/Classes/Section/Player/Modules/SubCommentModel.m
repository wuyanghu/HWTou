//
//  SubCommentModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SubCommentModel.h"
#import "PublicHeader.h"

@implementation SubCommentModel

- (void)bindWithDic:(NSDictionary *)dic {
    self.replyAvater = [dic objectForKey:@"replyAvater"];
    self.replyNickName = [dic objectForKey:@"replyNickName"];
    self.createTime = [dic objectForKey:@"createTime"];
    self.toUid = [[dic objectForKey:@"toUid"] intValue];
    self.toNickName = [dic objectForKey:@"toNickName"];
    self.fromUid = [[dic objectForKey:@"fromUid"] intValue];
    self.replyText = [dic objectForKey:@"replyText"];
    self.replyUrl = [dic objectForKey:@"replyUrl"];
    self.commentLocation = [dic objectForKey:@"commentLocation"];
    self.praiseNum = [[dic objectForKey:@"praiseNum"] intValue];
    self.replyCommentId = [[dic objectForKey:@"replyCommentId"] intValue];
    self.state = [[dic objectForKey:@"state"] intValue];
    self.showState = [[dic objectForKey:@"showState"] intValue];
    self.isPraise = [[dic objectForKey:@"isPraise"] intValue];
    
    if (self.showState) {
        self.replyString = [NSString stringWithFormat:@"@%@：%@",self.toNickName,self.replyText];
    }
    else {
        self.replyString = [NSString stringWithFormat:@"%@：%@",self.replyNickName,self.replyText];
    }
    CGRect rect = [self.replyString boundingRectWithSize:CGSizeMake(kMainScreenWidth - 92, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.replyHeight = rect.size.height;
    
    CGRect subRect = [self.replyString boundingRectWithSize:CGSizeMake(kMainScreenWidth - 62, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.subReplyHeight = subRect.size.height;
    
    CGRect dateRect = [self.createTime boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    self.dateWidth = dateRect.size.width;
    self.subCellHeight = 52 + self.subReplyHeight + 15 + 25;
}

@end
