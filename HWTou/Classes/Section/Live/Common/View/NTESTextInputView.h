//
//  NTESTextInputView.h
//  NIMLiveDemo
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESGrowingTextView.h"
@class NTESGrowingInternalTextView;
#import "SZTextView.h"

@protocol NTESTextInputViewDelegate <NSObject>

@optional

- (void)didSendText:(NSString *)text;

- (void)willChangeHeight:(CGFloat)height;

- (void)didChangeHeight:(CGFloat)height;

@end

@interface NTESTextInputView : UIView

@property (nonatomic,strong) SZTextView *textView;

@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,assign) id<NTESTextInputViewDelegate> delegate;

@end
