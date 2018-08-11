//
//  AnchorMoreFooterView.h
//  HWTou
//
//  Created by robinson on 2018/3/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoLiveFooterViewDelegate.h"
#import "NTESMessageModel.h"

@interface SuperManagerView : UIControl
@property (nonatomic,assign) BOOL isSuperManager;
@property (nonatomic,weak) id<SuperManagerViewDelegate> superDelegate;
@property (nonatomic,strong) NTESMessageModel * messageModel;
- (void)show;
- (void)dismiss;
@end
