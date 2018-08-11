//
//  LiveSuperManagerFooterView.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "LiveSuperManagerFooterView.h"

@interface LiveSuperManagerFooterView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playOrPuaseBtn;

@end

@implementation LiveSuperManagerFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - delegate

- (IBAction)chatAction:(id)sender {
    [_superDelegate liveSuperManagerFooterViewAction:NoLiveFooterViewTypeSend];
}

#pragma mark - Action

- (IBAction)playOrStopAction:(id)sender {
    if (self.playOrPuaseBtn.selected) {//播放
        NSLog(@"播放");
        if (_superDelegate) {
            [_superDelegate liveSuperManagerFooterViewAction:NoLiveFooterViewTypePlay];
        }
    }else{
        NSLog(@"暂停");
        if (_superDelegate) {
            [_superDelegate liveSuperManagerFooterViewAction:NoLiveFooterViewTypePause];
        }
    }
    self.playOrPuaseBtn.selected = !self.playOrPuaseBtn.selected;
    
}

- (IBAction)redPacketAction:(id)sender {
    NSLog(@"红包");
    [_superDelegate liveSuperManagerFooterViewAction:NoLiveFooterViewTypeRed];
}

- (IBAction)giftAction:(id)sender {
    NSLog(@"礼物");
    [_superDelegate liveSuperManagerFooterViewAction:NoLiveFooterViewTypeGift];
}
- (IBAction)joinAction:(id)sender {
    NSLog(@"更多");
    [_superDelegate liveSuperManagerFooterViewAction:NoLiveFooterViewTypeSuperMore];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.playOrPuaseBtn setImage:[UIImage imageNamed:@"zb_btn_play1"] forState:UIControlStateNormal];
    [self.playOrPuaseBtn setImage:[UIImage imageNamed:@"zb_btn_zt"] forState:UIControlStateSelected];
}

@end
