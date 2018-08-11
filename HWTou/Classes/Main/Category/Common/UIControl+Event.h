//
//  UIControl+Event.h
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Event)
- (void)addClick:(dispatch_block_t)callback;
- (void)addEvent:(UIControlEvents)event callback:(dispatch_block_t)callback;
- (void)addEvent:(UIControlEvents)event handler:(void(^)(id sender))handler;
@end

