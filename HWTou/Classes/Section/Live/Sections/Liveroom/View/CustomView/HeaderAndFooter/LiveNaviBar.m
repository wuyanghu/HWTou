//
//  LiveNaviBar.m
//  HWTou
//
//  Created by robinson on 2018/3/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "LiveNaviBar.h"

@interface LiveNaviBar()

@end

@implementation LiveNaviBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)popAction:(id)sender {
    NSLog(@"返回");
    if (_naviBarDelegate) {
        [_naviBarDelegate popAction:sender];
    }
}

- (IBAction)shareAction:(id)sender {
    NSLog(@"分享");
    if (_naviBarDelegate) {
        [_naviBarDelegate shareAction:sender];
    }
}

@end
