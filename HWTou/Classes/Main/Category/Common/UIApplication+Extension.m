//
//  UIApplication+Extension.m
//
//  Created by PP on 16/1/6.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import "UIApplication+Extension.h"

@implementation UIApplication (Extension)

+ (UIWindow *)keyWindow
{
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (window.isKeyWindow)
        {
            return window;
        }
    }
    return [self firstWindow];
}

+ (UIWindow *)firstWindow
{
    return [[[UIApplication sharedApplication] windows] firstObject];
}

+ (UIViewController *)topViewController
{
    return [self topViewControllerWithRootViewController:self.keyWindow.rootViewController];
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else
    {
        return rootViewController;
    }
}

@end
