//
//  TopNavBarView.h
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopNavBarDelegate <NSObject>

- (void)topNavBackBtnAction;

@end

@interface TopNavBarView : UIView

@property (nonatomic, weak) __weak id<TopNavBarDelegate> delegate;

//type = 0 “排行榜”  type = 1 “邀请好友” type = 2 “我的钱包”
- (instancetype)initWithFrame:(CGRect)frame type:(int)type;

- (void)setNavBarAlpha:(CGFloat)alpha;

@end
