//
//  AutoLifeView.m
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AutoLifeView.h"

@implementation AutoLifeView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self performSelector:@selector(removeView) withObject:nil afterDelay:3];
}

- (void)removeView{
    [self removeFromSuperview];
}

- (IBAction)popVIewAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)goAnswerActon:(id)sender {
    [self removeFromSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
