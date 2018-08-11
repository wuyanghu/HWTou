//
//  HUDProgressTool.m
//
//  Created by PP on 15/12/8.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "HUDProgressTool.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define HUDProgressSrcName(file) [@"HUDProgress.bundle" stringByAppendingPathComponent:file]

@implementation HUDProgressTool

static const NSTimeInterval kMinHideTime = 1.0f;

#pragma mark - public method
+ (UIWindow *)keyWindow
{
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (window.isKeyWindow && window.windowLevel == UIWindowLevelNormal)
        {
            return window;
        }
    }
    return [[[UIApplication sharedApplication] windows] firstObject];
}

+ (void)initialize
{
    [super initialize];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}

// 计算文字长度,字符越长显示越久
+ (NSTimeInterval)calculateHideTime:(NSString *)text
{
//    return text.length * 0.05 + kMinHideTime;
    return kMinHideTime;
}

#pragma mark - OnlyText status
+ (void)showOnlyText:(NSString *)text
{
    [self showOnlyText:text inView:[self keyWindow]];
}

+ (void)showOnlyText:(NSString *)text inView:(UIView *)inView
{
    [self dismiss];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
    [inView addSubview:hud];
    
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    
    hud.margin = 10.0f;
    hud.bezelView.layer.cornerRadius = 2.0f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:12.0f];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.userInteractionEnabled = NO;
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:[self calculateHideTime:text]];
}

#pragma mark - Indicator status
+ (void)showIndicatorWithText:(NSString *)text
{
    [self showIndicatorWithText:text inView:[self keyWindow]];
}

+ (void)showIndicatorWithText:(NSString *)text inView:(UIView *)inView
{
    [self dismiss];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
    [inView addSubview:hud];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.margin = 10.0f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.label.font = [UIFont systemFontOfSize:12.0f];
    hud.label.textColor = [UIColor whiteColor];
    hud.label.text = text;
    [hud showAnimated:YES];
}

#pragma mark - Success status
+ (void)showSuccessWithText:(NSString *)text
{
    [self showSuccessWithText:text inView:[self keyWindow]];
}

+ (void)showSuccessWithText:(NSString *)text inView:(UIView *)view
{
#if 1
    [self showOnlyText:text inView:view];
#else
    UIImage *image = [UIImage imageNamed:HUDProgressSrcName(@"hud_succeed")];
    UIImageView *customView = [[UIImageView alloc] initWithImage:image];
    
    [self showWithCustomView:customView text:text inView:view];
#endif
}

#pragma mark - Error status
+ (void)showErrorWithText:(NSString *)text
{
    [self dismiss];
    [self showErrorWithText:text inView:[self keyWindow]];
}

+ (void)showErrorWithText:(NSString *)text inView:(UIView *)view
{
#if 1
    [self showOnlyText:text inView:view];
#else
    UIImage *image = [UIImage imageNamed:HUDProgressSrcName(@"hud_failed")];
    UIImageView *customView = [[UIImageView alloc] initWithImage:image];
    
    [self showWithCustomView:customView text:text inView:view];
#endif
}

#pragma mark - Custom View
+ (void)showWithCustomView:(UIView *)customView text:(NSString *)text inView:(UIView *)inView
{
    [self dismiss];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
    [inView addSubview:hud];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    hud.label.text = text;
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:[self calculateHideTime:text]];
}

#pragma mark - dismiss
+ (void)dismiss
{
    [self dismissFormView:[self keyWindow] animated:YES];
}

+ (void)dismissFormView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}
@end
