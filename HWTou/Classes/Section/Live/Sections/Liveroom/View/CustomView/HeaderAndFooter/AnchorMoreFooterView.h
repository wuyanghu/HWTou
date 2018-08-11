//
//  AnchorMoreFooterView.h
//  HWTou
//
//  Created by robinson on 2018/3/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoLiveFooterViewDelegate.h"

typedef enum : NSUInteger{
    LiveFooterMoreTypeSuper,//超级管理员
    LiveFooterMoreTypeAnchor,//主播
    LiveFooterMoreTypeAudience,//观众端有主播
    LiveFooterMoreTypeAudienceNo,//观众端没有主播
}LiveFooterMoreType;

@interface AnchorMoreFooterView : UIControl
@property (nonatomic,assign) BOOL isAllReliseMute;
@property (nonatomic,weak) id<AnchorMoreFooterViewDelegate> anchorMoreDelegate;
- (void)show:(LiveFooterMoreType)moreType;
- (void)dismiss;
@end
