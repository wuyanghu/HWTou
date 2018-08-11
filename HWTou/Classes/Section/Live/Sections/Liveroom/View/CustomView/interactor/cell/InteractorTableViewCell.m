//
//  InteractorTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/3/21.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "InteractorTableViewCell.h"
#import "NTESMicConnector.h"
#import "NTESMicConnector.h"

@interface InteractorTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation InteractorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.muteBtn setBackgroundImage:[UIImage imageNamed:@"zb_btn_qxjy"] forState:UIControlStateSelected];
    [self.connectBtn setBackgroundImage:[UIImage imageNamed:@"zb_btn_gd-1"] forState:UIControlStateSelected];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMicConnector:(NTESMicConnector *)micConnector{
    _micConnector = micConnector;
    self.nickNameLabel.text = micConnector.nick;
    if (micConnector.state == NTESLiveMicStateNone || micConnector.state == NTESLiveMicStateWaiting) {
        [self.connectBtn setSelected:NO];
    }else{
        [self.connectBtn setSelected:YES];
    }
}

#pragma mark - action

- (IBAction)muteAction:(id)sender {
    UIButton * button = sender;
    if (button.selected) {
        NSLog(@"打开静音");
        [_cellDelegate muteAction:_micConnector flag:2];
    }else{
        NSLog(@"取消静音");
        [_cellDelegate muteAction:_micConnector flag:1];
    }
    self.muteBtn.selected = !self.muteBtn.selected;
    
}

- (IBAction)connectAction:(id)sender {
    UIButton * button = sender;
    if (button.selected) {
        NSLog(@"接通");
        [_cellDelegate connectAction:_micConnector flag:2];
    }else{
        NSLog(@"挂断");
        [_cellDelegate connectAction:_micConnector flag:1];
    }
    self.connectBtn.selected = !self.connectBtn.selected;
    
}



@end
