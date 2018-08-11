//
//  AnchorFooterView.h
//  HWTou
//
//  Created by robinson on 2018/3/21.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoLiveFooterViewDelegate.h"

@interface AnchorFooterView : UIView
@property (nonatomic,assign) BOOL isInit;
@property (nonatomic,weak) id<AnchorFooterViewDelegate> anchorDelegate;
@end
