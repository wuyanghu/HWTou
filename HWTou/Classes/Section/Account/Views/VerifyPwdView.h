//
//  VerifyPwdView.h
//  HWTou
//
//  Created by Alan Jiang on 2017/4/18.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VerifyPwdViewDelegate <NSObject>

- (void)onVerifyPwdSuccessful;

@end

@interface VerifyPwdView : UIView

@property (nonatomic, weak) id<VerifyPwdViewDelegate> m_Delegate;

@end
