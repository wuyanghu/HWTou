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
    self.isTop = [[dic objectForKey:@"isTop"] intValue];
    self.isM = [[dic objectForKey:@"isM"] intValue];
    self.vid = [dic objectForKey:@"vid"];
    self.commentFlag = [[dic objectForKey:@"commentFlag"] intValue];
    self.commentImgUrl = [dic objectForKey:@"commentImgUrl"];
    
    if (![self.replyUrl isEqualToString:@""]) {
        double duration_d = [[dic objectForKey:@"duration"] doubleValue];
        self.duration = (int)round(duration_d);
    }
    
    if (!self.state && !self.showState) {
        self.replyString = self.replyText;
    }
    if (self.showState) {
        self.replyString = [NSString stringWithFormat:@"@%@：%@",self.toNickName,self.replyText];
    }
    if (self.state) {
        self.replyString = self.replyText;
    }
    
    //回复高度
    CGRect subRect = [self.replyString boundingRectWithSize:CGSizeMake(kMainScreenWidth - 62, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.subReplyHeight = subRect.size.height;
    
    CGRect locationRect = [self.commentLocation boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    self.locationWidth = locationRect.size.width;
    CGFloat locationHeight = [self.commentLocation isEqualToString:@""] ? 0 : 17.f;
    
    //日期宽度
    CGRect dateRect = [self.createTime boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    self.dateWidth = dateRect.size.width;
    
    
    self.imgHeight = 0;
    self.imgsHeight = 0;
    if (self.commentFlag == 1) {
        //语音评论
        
        self.subCellHeight = 57 + 30 + 15 + locationHeight +25;
        NSString *cellT_Str = [NSString stringWithFormat:@"%.2f", self.subCellHeight];
        self.subCellHeight = [cellT_Str floatValue];
        self.first_replyHeight = 30;
        
        self.first_replyString = [NSString stringWithFormat:@"%@：%@",self.replyNickName,self.replyText];
        CGRect first_rect = [self.first_replyString boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        self.first_replyWidth = first_rect.size.width > kMainScreenWidth - 92 - 178 ? kMainScreenWidth - 92 - 178 : first_rect.size.width;
    }
    else if (self.commentFlag == 2) {
        //含有图片
        
        self.imgHeight = (kMainScreenWidth - 62 - 10 - 20)/3.0;
        
        [self.commentUrlArray removeAllObjects];
        if (![self.replyUrl isEqualToString:@""]) {
            NSArray *imgsDataArr = [self.replyUrl componentsSeparatedByString:@","];
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
        
        if ([self.replyText isEqualToString:@""]) {
            self.subCellHeight = 52 + self.imgsHeight + 15 + locationHeight + 25;
        }
        else {
            self.subCellHeight = 52 + self.subReplyHeight + 15 + self.imgsHeight + 15 + locationHeight + 25;
        }
        NSString *cellH_Str = [NSString stringWithFormat:@"%.2f", self.subCellHeight];
        self.subCellHeight = [cellH_Str floatValue];
        
        self.first_replyString = [NSString stringWithFormat:@"%@：%@ [图片]",self.replyNickName,self.replyText];
        CGRect first_rect = [self.first_replyString boundingRectWithSize:CGSizeMake(kMainScreenWidth - 92, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        self.first_replyHeight = first_rect.size.height;
        self.first_replyWidth = kMainScreenWidth - 92;
    }
    else if (self.commentFlag == 3) {
        //含有视频
        
        if ([self.replyText isEqualToString:@""]) {
            self.subCellHeight = 52 + 110 + 15 + locationHeight + 25;
        }
        else {
            self.subCellHeight = 52 + self.subReplyHeight + 15 + 110 + 15 + locationHeight + 25;
        }
        NSString *cellH_Str = [NSString stringWithFormat:@"%.2f", self.subCellHeight];
        self.subCellHeight = [cellH_Str floatValue];
        
        self.first_replyString = [NSString stringWithFormat:@"%@：%@ [视频]",self.replyNickName,self.replyText];
        CGRect first_rect = [self.first_replyString boundingRectWithSize:CGSizeMake(kMainScreenWidth - 92, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        self.first_replyHeight = first_rect.size.height;
        self.first_replyWidth = kMainScreenWidth - 92;
    }
    else {
        //纯文字评论
        
        self.subCellHeight = 52 + self.subReplyHeight + 15 + locationHeight + 25;
        NSString *cellH_Str = [NSString stringWithFormat:@"%.2f", self.subCellHeight];
        self.subCellHeight = [cellH_Str floatValue];
        
        self.first_replyString = [NSString stringWithFormat:@"%@：%@",self.replyNickName,self.replyText];
        CGRect first_rect = [self.first_replyString boundingRectWithSize:CGSizeMake(kMainScreenWidth - 92, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        self.first_replyHeight = first_rect.size.height;
        self.first_replyWidth = kMainScreenWidth - 92;
    }
}

- (NSMutableArray *)commentUrlArray {
    if (!_commentUrlArray) {
        _commentUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _commentUrlArray;
}

@end
