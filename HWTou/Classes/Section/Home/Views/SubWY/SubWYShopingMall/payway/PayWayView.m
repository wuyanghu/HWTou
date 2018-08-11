//
//  PayWayView.m
//  HWTou
//
//  Created by robinson on 2018/4/24.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "PayWayView.h"
#import "WCLPassWordView.h"
#import "UIView+NTES.h"
#import "MuteRequest.h"
#import "UIView+Toast.h"

@interface PayWayView()<WCLPassWordViewDelegate>
@property (weak, nonatomic) IBOutlet WCLPassWordView *setPayPswdView;
@end

@implementation PayWayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.setPayPswdView.delegate = self;
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.bgView addGestureRecognizer:tapGesturRecognizer];
}

- (void)tapAction:(UIGestureRecognizer *)recognizer{
    [self dismiss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop -= self.ntesHeight;
    }];
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop += self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - WCLPassWordViewDelegate
/**
*  监听输入的改变
*/
- (void)passWordDidChange:(WCLPassWordView *)passWord {
    NSLog(@"======密码改变：%@",passWord.textStore);
}

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(WCLPassWordView *)passWord {
    IsPayPwdParam * param = [IsPayPwdParam new];
    param.payPwd = passWord.textStore;
    [MuteRequest isPayPwd:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self.delegate payWaySuccess];
            [self dismiss];
        }else{
            [self makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
    
}

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(WCLPassWordView *)passWord {
    NSLog(@"-------密码开始输入");
}

@end
