//
//  DiscloseawardView.h
//  HWTou
//
//  Created by robinson on 2018/4/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTESMessageModel;

@protocol DiscloseawardViewDelegate
- (void)discloseawardViewAction:(NSString *)text messageModel:(NTESMessageModel *)messageModel payType:(NSInteger)payType;
@end

@interface DiscloseawardView : UIControl
@property (nonatomic,weak) id<DiscloseawardViewDelegate> discloseawardViewDelegate;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *switchPayBtn;


- (void)show:(NTESMessageModel *)messageModel;
- (void)dismiss;
@end
