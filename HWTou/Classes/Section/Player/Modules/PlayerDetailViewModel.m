//
//  PlayerDetailViewModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerDetailViewModel.h"
#import "PublicHeader.h"

@implementation PlayerDetailViewModel

- (void)bindWithDic:(NSDictionary *)dic {
    if (![dic objectForKey:@"data"]) {
        return;
    }
    if ([[dic objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
        return;
    }
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    
    self.playingUrl = [BaseModel safeFromatWithString:[dataDic objectForKey:@"playingUrl"]];
    self.bmgs = [BaseModel safeFromatWithString:[dataDic objectForKey:@"bmgs"]];
    self.avater = [BaseModel safeFromatWithString:[dataDic objectForKey:@"avater"]];
    self.title = [BaseModel safeFromatWithString:[dataDic objectForKey:@"title"]];
    self.name = [BaseModel safeFromatWithString:[dataDic objectForKey:@"name"]];
    self.content = [BaseModel safeFromatWithString:[dataDic objectForKey:@"content"]];
    self.createTime = [BaseModel safeFromatWithString:[dataDic objectForKey:@"createTime"]];
    
    self.praiseNum = [[dataDic objectForKey:@"praiseNum"] intValue];
    self.lookNum = [[dataDic objectForKey:@"lookNum"] intValue];
    self.commentNum = [[dataDic objectForKey:@"commentNum"] intValue];
    self.giftNum = [[dataDic objectForKey:@"giftNum"] intValue];
    self.radioId = [[dataDic objectForKey:@"radioId"] intValue];
    self.rtcId = [[dataDic objectForKey:@"rtcId"] intValue];
    self.isCollected = [[dataDic objectForKey:@"isCollected"] intValue];
    
    [self.bmgsArr removeAllObjects];
    if ([self.bmgs containsString:@","]) {
        NSArray *arr = [self.bmgs componentsSeparatedByString:@","];
        for (int i=0; i<arr.count; i++) {
                [self.bmgsArr addObject:arr[i]];
            
        }
    }
    else {
        [self.bmgsArr addObject:self.bmgs];
    }
    CGRect rect = [self.content boundingRectWithSize:CGSizeMake(kMainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.infoCellHeight = 161 + rect.size.height;
}

- (NSMutableArray *)bmgsArr {
    if (!_bmgsArr) {
        _bmgsArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _bmgsArr;
}

@end
