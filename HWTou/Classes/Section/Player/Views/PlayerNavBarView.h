//
//  PlayerNavBarView.h
//  HWTou
//
//  Created by Reyna on 2017/11/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerNavBarDelegate <NSObject>

- (void)playerNavBackBtnAction;
- (void)playerNavShareBtnAction;

@end

@interface PlayerNavBarView : UIView

@property (nonatomic, weak) __weak id<PlayerNavBarDelegate> delegate;

- (void)setNavBarAlpha:(CGFloat)alpha;

@end
