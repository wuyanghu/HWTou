//
//  WinView.h
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WinViewDelegate
- (void)shareWinViewAction;
- (void)finishAnswerAction;
@end

@interface WinView : UIView

@property (nonatomic,weak) id<WinViewDelegate> winDelegate;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;

@end
