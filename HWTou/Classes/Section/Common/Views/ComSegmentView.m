//
//  ComSegmentView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ComSegmentView.h"
#import "PublicHeader.h"

@interface ComSegmentView ()

@property (nonatomic,strong) UIButton *btnPlus;
@property (nonatomic,strong) UIButton *btReduce;
@property (nonatomic,strong) UITextField *tfInput;

@end

@implementation ComSegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.btnPlus = [[UIButton alloc] init];
    self.btReduce = [[UIButton alloc] init];
    
    self.tfInput = [[UITextField alloc] init];
    self.tfInput.keyboardType = UIKeyboardTypeNumberPad;
}

- (UIButton *)createUIButton:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)actionButton:(UIButton *)button
{
    
}

@end
