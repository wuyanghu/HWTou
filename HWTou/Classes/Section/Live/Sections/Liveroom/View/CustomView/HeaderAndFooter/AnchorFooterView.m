//
//  AnchorFooterView.m
//  HWTou
//
//  Created by robinson on 2018/3/21.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnchorFooterView.h"

@interface AnchorFooterView()

@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *interactBtn;
@property (weak, nonatomic) IBOutlet UIButton *specialMusicBtn;
@property (weak, nonatomic) IBOutlet UIButton *bmgMusicBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end

@implementation AnchorFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
    _isInit = YES;
}

- (IBAction)voiceAction:(id)sender {
    if (_isInit) {
        _isInit = NO;
        [self.voiceBtn setImage:[UIImage imageNamed:@"gl_btn_km"] forState:UIControlStateNormal];
        [self.voiceBtn setImage:[UIImage imageNamed:@"gl_btn_jy"] forState:UIControlStateSelected];
        [_anchorDelegate anchorFooterViewAction:startLiveType];
    }else{
        if (self.voiceBtn.selected) {
            NSLog(@"开启声音");
            [[NIMAVChatSDK sharedSDK].netCallManager setMute:NO];
            [[NIMAVChatSDK sharedSDK].netCallManager resumeAudioMix];
            [_anchorDelegate anchorFooterViewAction:voiceType];
        }else{
            NSLog(@"静音");
            [[NIMAVChatSDK sharedSDK].netCallManager setMute:YES];
            [[NIMAVChatSDK sharedSDK].netCallManager pauseAudioMix];
            [_anchorDelegate anchorFooterViewAction:noVoiceType];
        }
        self.voiceBtn.selected = !self.voiceBtn.selected;
    }
}
- (IBAction)interactAction:(id)sender {
    if (_anchorDelegate) {
        [_anchorDelegate anchorFooterViewAction:interactType];
    }
}

- (IBAction)specialMusicAction:(id)sender {
    if (_anchorDelegate) {
        [_anchorDelegate anchorFooterViewAction:specialMusicType];
    }
}

- (IBAction)bmgMusicAction:(id)sender {
    if (_anchorDelegate) {
        [_anchorDelegate anchorFooterViewAction:bmgMusicType];
    }
}

- (IBAction)moreAction:(id)sender {
    if (_anchorDelegate) {
        [_anchorDelegate anchorFooterViewAction:moreType];
    }
}


@end
