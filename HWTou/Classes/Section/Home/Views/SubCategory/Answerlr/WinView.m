//
//  WinView.m
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "WinView.h"

@implementation WinView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)shareAction:(id)sender {
    if (_winDelegate) {
        [_winDelegate shareWinViewAction];
    }
}

- (IBAction)finishAnswerAction:(id)sender {
    if (_winDelegate) {
        [_winDelegate finishAnswerAction];
    }
}

- (IBAction)closeView:(id)sender {
    if (_winDelegate) {
        [_winDelegate finishAnswerAction];
    }
}



@end
