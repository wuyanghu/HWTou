//
//  WeedOutView.h
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeedOutViewDelegate
- (void)inviteMyFriend;
@end

@interface WeedOutView : UIView
@property (nonatomic,weak) id<WeedOutViewDelegate> outViewDelegate;
@end
