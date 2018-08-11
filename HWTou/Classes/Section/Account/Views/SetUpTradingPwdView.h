//
//  SetUpTradingPwdView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetUpTradingPwdViewDelegate <NSObject>

- (void)onBindingSuccess;

@end

@interface SetUpTradingPwdView : UIView

@property (nonatomic, weak) id<SetUpTradingPwdViewDelegate> m_Delegate;

@end
