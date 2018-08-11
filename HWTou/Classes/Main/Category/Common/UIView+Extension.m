//
//  UIView+Extension.m
//
//  Created by PP on 15/11/4.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setRoundWithCorner:(CGFloat)corner
{
    self.layer.cornerRadius = corner;
    self.layer.masksToBounds = YES;
}

- (UIViewController *)viewController
{
    // 获得当前View的UIViewController对象
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
