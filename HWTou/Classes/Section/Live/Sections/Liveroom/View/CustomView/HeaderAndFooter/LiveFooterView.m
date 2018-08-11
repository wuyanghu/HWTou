//
//  LiveFooterView.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "LiveFooterView.h"

@interface LiveFooterView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playOrPuaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *printBtn;

@end

@implementation LiveFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - delegate

- (IBAction)chatAction:(id)sender {
    [_liveDelegate liveFooterViewAction:NoLiveFooterViewTypeSend];
}

#pragma mark - Action

- (IBAction)playOrStopAction:(id)sender {
    if (self.playOrPuaseBtn.selected) {//播放
        NSLog(@"播放");
        if (_liveDelegate) {
            [_liveDelegate liveFooterViewAction:NoLiveFooterViewTypePlay];
        }
    }else{
        NSLog(@"暂停");
        if (_liveDelegate) {
            [_liveDelegate liveFooterViewAction:NoLiveFooterViewTypePause];
        }
    }
    self.playOrPuaseBtn.selected = !self.playOrPuaseBtn.selected;
    
}

- (IBAction)redPacketAction:(id)sender {
    NSLog(@"红包");
     [_liveDelegate liveFooterViewAction:NoLiveFooterViewTypeRed];
}

- (IBAction)giftAction:(id)sender {
    NSLog(@"礼物");
    [_liveDelegate liveFooterViewAction:NoLiveFooterViewTypeGift];
}

- (IBAction)moreAction:(id)sender {
    if (_liveDelegate) {
        [_liveDelegate liveFooterViewAction:NoLiveFooterViewTypeMore];
    }
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.playOrPuaseBtn setImage:[UIImage imageNamed:@"zb_btn_zt"] forState:UIControlStateNormal];
    [self.playOrPuaseBtn setImage:[UIImage imageNamed:@"zb_btn_play1"] forState:UIControlStateSelected];
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
