//
//  WinnerListView.m
//  HWTou
//
//  Created by robinson on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "WinnerListView.h"
#import "PublicHeader.h"

@implementation WinnerListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setUserModel:(GetWinUserModel *)userModel{
    self.winnerNum.text = [NSString stringWithFormat:@"%ld获奖者",userModel.total];
    
    if (userModel.userResultModelArr.count == 0) {
        return;
    }
    
    GetWinUserResultModel * resultModel = userModel.userResultModelArr[0];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:resultModel.headUrl]];
    self.nickNameLabel.text = resultModel.nickname;
    self.getMoneyLabel.text = resultModel.money;
    
    if (userModel.userResultModelArr.count == 1) {
        return;
    }
    
    GetWinUserResultModel * resultModel2 = userModel.userResultModelArr[1];
    [self.headerImageView2 sd_setImageWithURL:[NSURL URLWithString:resultModel2.headUrl]];
    self.nickNameLabel2.text = resultModel2.nickname;
    self.getMoneyLabel2.text = resultModel2.money;
}

@end
