//
//  RegSuccessView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegSuccessViewDelegate <NSObject>

- (void)onGoToShopping;
- (void)onGoToRealNameAuthentication;

@end

@interface RegSuccessView : UIView

@property (nonatomic, weak) id<RegSuccessViewDelegate> m_Delegate;

@end
