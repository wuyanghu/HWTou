//
//  NoLiveFooterView.m
//  HWTou
//
//  Created by robinson on 2018/3/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "NoLiveFooterView.h"

@interface NoLiveFooterView()

@property (weak, nonatomic) IBOutlet UIButton *playOrStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *printBtn;

@end

@implementation NoLiveFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.playOrStopBtn setImage:[UIImage imageNamed:@"zb_btn_zt"] forState:UIControlStateNormal];
    [self.playOrStopBtn setImage:[UIImage imageNamed:@"zb_btn_play1"] forState:UIControlStateSelected];
    
}

#pragma mark - Action

- (IBAction)playOrStopAction:(id)sender {
    if (self.playOrStopBtn.selected) {//播放
        NSLog(@"播放");
        if (_liveDelegate) {
            [_liveDelegate noLiveFooterViewAction:NoLiveFooterViewTypePlay];
        }
    }else{
        NSLog(@"暂停");
        if (_liveDelegate) {
            [_liveDelegate noLiveFooterViewAction:NoLiveFooterViewTypePause];
        }
    }
    self.playOrStopBtn.selected = !self.playOrStopBtn.selected;
    
}

- (IBAction)redPacketAction:(id)sender {
    [_liveDelegate noLiveFooterViewAction:NoLiveFooterViewTypeRed];
}

- (IBAction)giftAction:(id)sender {
    [_liveDelegate noLiveFooterViewAction:NoLiveFooterViewTypeGift];
}
- (IBAction)sendAction:(id)sender {
    [_liveDelegate noLiveFooterViewAction:NoLiveFooterViewTypeSend];
}

- (IBAction)moreAction:(id)sender {
    [_liveDelegate noLiveFooterViewAction:NoLiveFooterViewTypeMore];
}


- (void)updateMuteView:(NTESLiveMuteType)type{
    NSString * title = @"";
    switch (type) {
        case NTESLiveTempMuteType:
            {
                title = @"您已被禁言";
                [self.printBtn setEnabled:NO];
                [self.printBtn setBackgroundColor:UIColorFromRGB(0xC4C3C4)];
            }
            break;
        case NTESLiveRelieveMuteType:
        case NTESLiveRelieveAllMuteType:
        {
            title = @"聊点什么吧";
            [self.printBtn setEnabled:YES];
            [self.printBtn setBackgroundColor:UIColorFromRGB(0x525354)];
        }
            break;
        case NTESLiveAllMuteType:
        {
            title = @"全员禁言";
            [self.printBtn setEnabled:NO];
            [self.printBtn setBackgroundColor:UIColorFromRGB(0xC4C3C4)];
        }
            break;
        default:
            break;
    }

    [self.printBtn setTitle:title forState:UIControlStateNormal];
}

@end
