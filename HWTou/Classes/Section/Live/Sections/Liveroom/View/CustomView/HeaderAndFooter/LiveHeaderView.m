//
//  LiveHeaderView.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "LiveHeaderView.h"
#import "PublicHeader.h"
#import "NTESDataManager.h"
#import "UIView+NTES.h"

@interface LiveHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@end

@implementation LiveHeaderView

- (IBAction)headerAction:(id)sender {
    [_liveDelegate liveHeaderViewAction:LiveHeaderViewTypeHeader];
}


- (IBAction)attendAction:(id)sender {
    [_liveDelegate liveHeaderViewAction:LiveHeaderViewTypeAttend];
}

- (IBAction)noticeAction:(id)sender {
    [_liveDelegate liveHeaderViewAction:LiveHeaderViewTypeNotice];
}
- (IBAction)giftAction:(id)sender {
    [_liveDelegate liveHeaderViewAction:LiveHeaderViewTypeGift];
}

- (void)setChatInfoModel:(GetChatInfoModel *)chatInfoModel{
    _chatInfoModel = chatInfoModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:chatInfoModel.avater] forState:UIControlStateNormal placeholderImage:[NTESDataManager sharedInstance].defaultUserAvatar];
    self.titleLabel.text = chatInfoModel.nickname;
    
    self.onlineLabel.text = [NSString stringWithFormat:@"在线:%ld 累计:%ld",chatInfoModel.online,chatInfoModel.lookNum];
    self.rewardLabel.text = [NSString stringWithFormat:@"%ld人打赏",chatInfoModel.tipAllNum];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
