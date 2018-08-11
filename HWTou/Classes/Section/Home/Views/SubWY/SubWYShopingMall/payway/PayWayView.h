//
//  PayWayView.h
//  HWTou
//
//  Created by robinson on 2018/4/24.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayWayViewDelegate
- (void)payWaySuccess;
@end

@interface PayWayView : UIControl
@property (nonatomic,weak) id<PayWayViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *bgView;

- (void)show;
- (void)dismiss;
@end
