//
//  WeedOutView.m
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "WeedOutView.h"
#import "UIApplication+Extension.h"
#import "PublicHeader.h"

@implementation WeedOutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)popView:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)goLookView:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)inviteFriendAction:(id)sender {
    if (_outViewDelegate) {
        [_outViewDelegate inviteMyFriend];
    }
}

@end
