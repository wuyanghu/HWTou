//
//  QuickRegView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuickRegViewDelegate <NSObject>

@optional
- (void)onToLogIn;
- (void)onNextStepWithRegPhone:(NSString *)regPhone;

@end

@interface QuickRegView : UIView

@property (nonatomic, weak) id<QuickRegViewDelegate> m_Delegate;
@property (nonatomic, assign) BOOL isForget;

@end
