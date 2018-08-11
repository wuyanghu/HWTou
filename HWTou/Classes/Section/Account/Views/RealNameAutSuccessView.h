//
//  RealNameAutSuccessView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RealNameAutSuccessViewDelegate <NSObject>

- (void)onGoToShopping;
- (void)onGoToBindingBankCard;

@end

@interface RealNameAutSuccessView : UIView

@property (nonatomic, weak) id<RealNameAutSuccessViewDelegate> m_Delegate;

@end
