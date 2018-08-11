//
//  LiveHeaderView.h
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetChatInfoModel.h"
#import "NoLiveFooterViewDelegate.h"

@interface LiveHeaderView : UIView
@property (nonatomic,strong) GetChatInfoModel * chatInfoModel;
@property (nonatomic,weak) id<LiveHeaderViewDelegate> liveDelegate;
@end