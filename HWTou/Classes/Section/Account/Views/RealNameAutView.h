//
//  RealNameAutView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RealNameAutViewDelegate <NSObject>

- (void)onShowAlertController;
- (void)onRealNameAutSuccessful;

@end

@interface RealNameAutView : UIView

@property (nonatomic, weak) id<RealNameAutViewDelegate> m_Delegate;

- (void)realNameAuthentication;

@end
