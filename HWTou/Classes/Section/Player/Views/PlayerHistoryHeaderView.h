//
//  PlayerHistoryHeaderView.h
//  HWTou
//
//  Created by robinson on 2017/12/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlayerHistoryHeaderViewDelegate
- (void)allSelected;
- (void)cancelSelected;
@end

@interface PlayerHistoryHeaderView : UIView
@property (nonatomic,assign) BOOL isCheck;
@property (nonatomic,weak) id<PlayerHistoryHeaderViewDelegate> historyDelegate;
@end
