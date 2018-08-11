//
//  NoLiveFooterView.h
//  HWTou
//
//  Created by robinson on 2018/3/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoLiveFooterViewDelegate.h"
#import "NTESLiveViewDefine.h"

@interface NoLiveFooterView : UIView
@property (nonatomic,weak) id<NoLiveFooterViewDelegate> liveDelegate;

- (void)updateMuteView:(NTESLiveMuteType)type;
@end
