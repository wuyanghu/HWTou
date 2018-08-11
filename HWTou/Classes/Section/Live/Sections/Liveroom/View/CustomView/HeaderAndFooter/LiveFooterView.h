//
//  LiveFooterView.h
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoLiveFooterViewDelegate.h"
#import "NTESLiveViewDefine.h"

@interface LiveFooterView : UIView
@property (nonatomic,weak) id<LiveFooterViewDelegate> liveDelegate;
- (void)updateMuteView:(NTESLiveMuteType)type;
@end
