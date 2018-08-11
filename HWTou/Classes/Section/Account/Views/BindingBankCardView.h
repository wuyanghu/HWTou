//
//  BindingBankCardView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BindingBankCardViewDelegate <NSObject>

- (void)onNextStepWithBankName:(NSString *)name withBankCardNumber:(NSString *)cardNumber;

@end

@interface BindingBankCardView : UIView

@property (nonatomic, weak) id<BindingBankCardViewDelegate> m_Delegate;

@end
