//
//  UIView+NTES.m
//  NIMDemo
//
//  Created by ght on 15-1-31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "UIView+NTES.h"
#import <objc/runtime.h>
@implementation UIView (NTES)

- (CGFloat)ntesLeft {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesLeft:(CGFloat)ntesLeft {
    CGRect frame = self.frame;
    frame.origin.x = ntesLeft;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ntesTop {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesTop:(CGFloat)ntesTop {
    CGRect frame = self.frame;
    frame.origin.y = ntesTop;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ntesRight {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesRight:(CGFloat)ntesRight {
    CGRect frame = self.frame;
    frame.origin.x = ntesRight - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ntesBottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesBottom:(CGFloat)ntesBottom {
    CGRect frame = self.frame;
    frame.origin.y = ntesBottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ntesCenterX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesCenterX:(CGFloat)ntesCenterX {
    self.center = CGPointMake(ntesCenterX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ntesCenterY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesCenterY:(CGFloat)ntesCenterY {
    self.center = CGPointMake(self.center.x, ntesCenterY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ntesWidth {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesWidth:(CGFloat)ntesWidth {
    CGRect frame = self.frame;
    frame.size.width = ntesWidth;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ntesHeight {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesHeight:(CGFloat)ntesHeight {
    CGRect frame = self.frame;
    frame.size.height = ntesHeight;
    self.frame = frame;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)ntesOrigin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesOrigin:(CGPoint)ntesOrigin {
    CGRect frame = self.frame;
    frame.origin = ntesOrigin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)ntesSize {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNtesSize:(CGSize)ntesSize {
    CGRect frame = self.frame;
    frame.size = ntesSize;
    self.frame = frame;
}


- (UIViewController *)viewController{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end



@implementation UIView(NTESPresent)


static char PresentedViewAddress;   //被Present的View
static char PresentingViewAddress;  //正在Present其他视图的view
#define AnimateDuartion .25f
- (void)presentView:(UIView*)view animated:(BOOL)animated complete:(void(^)(void)) complete{
    if (!self.window) {
        return;
    }
    [self.window addSubview:view];
    objc_setAssociatedObject(self, &PresentedViewAddress, view, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(view, &PresentingViewAddress, self, OBJC_ASSOCIATION_RETAIN);
    if (animated) {
        [self doAlertAnimate:view complete:complete];
    }else{
        view.center = self.window.center;
    }
}

- (UIView *)presentedView{
    UIView * view =  objc_getAssociatedObject(self, &PresentedViewAddress);
    return view;
}

- (void)dismissPresentedView:(BOOL)animated complete:(void(^)(void)) complete{
    UIView * view =  objc_getAssociatedObject(self, &PresentedViewAddress);
    if (animated) {
        [self doHideAnimate:view complete:complete];
    }else{
        [view removeFromSuperview];
        [self cleanAssocaiteObject];
    }
}

- (void)hideSelf:(BOOL)animated complete:(void(^)(void)) complete{
    UIView * baseView =  objc_getAssociatedObject(self, &PresentingViewAddress);
    if (!baseView) {
        return;
    }
    [baseView dismissPresentedView:animated complete:complete];
    [self cleanAssocaiteObject];
}


- (void)onPressBkg:(id)sender{
    [self dismissPresentedView:YES complete:nil];
}

#pragma mark - Animation
- (void)doAlertAnimate:(UIView*)view complete:(void(^)(void)) complete{
    CGRect bounds = view.bounds;
    // 放大
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scaleAnimation.duration  = AnimateDuartion;
    scaleAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    scaleAnimation.toValue   = [NSValue valueWithCGRect:bounds];
    
    // 移动
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.duration   = AnimateDuartion;
    moveAnimation.fromValue  = [NSValue valueWithCGPoint:[self.superview convertPoint:self.center toView:nil]];
    moveAnimation.toValue    = [NSValue valueWithCGPoint:self.window.center];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime                = CACurrentMediaTime();
    group.duration                = AnimateDuartion;
    group.animations            = [NSArray arrayWithObjects:scaleAnimation,moveAnimation,nil];
    group.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode                = kCAFillModeForwards;
    group.removedOnCompletion    = NO;
    group.autoreverses            = NO;
    
    [self hideAllSubView:view];
    
    [view.layer addAnimation:group forKey:@"groupAnimationAlert"];
    
    __weak UIView * wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimateDuartion * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.layer.bounds    = bounds;
        view.layer.position  = wself.superview.center;
        [wself showAllSubView:view];
        if (complete) {
            complete();
        }
    });
    
}

- (void)doHideAnimate:(UIView*)alertView complete:(void(^)()) complete{
    if (!alertView) {
        return;
    }
    // 缩小
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scaleAnimation.duration = AnimateDuartion;
    scaleAnimation.toValue  = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    
    CGPoint position   = self.center;
    // 移动
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.duration = AnimateDuartion;
    moveAnimation.toValue  = [NSValue valueWithCGPoint:[self.superview convertPoint:self.center toView:nil]];
    
    CAAnimationGroup *group   = [CAAnimationGroup animation];
    group.beginTime           = CACurrentMediaTime();
    group.duration            = AnimateDuartion;
    group.animations          = [NSArray arrayWithObjects:scaleAnimation,moveAnimation,nil];
    group.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode            = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.autoreverses        = NO;
    
    
    alertView.layer.bounds    = self.bounds;
    alertView.layer.position  = position;
    alertView.layer.needsDisplayOnBoundsChange = YES;
    
    [self hideAllSubView:alertView];
    alertView.backgroundColor = [UIColor clearColor];
    
    [alertView.layer addAnimation:group forKey:@"groupAnimationHide"];
    
    __weak UIView * wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimateDuartion * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView removeFromSuperview];
        [wself cleanAssocaiteObject];
        [wself showAllSubView:alertView];
        if (complete) {
            complete();
        }
    });
}


static char *HideViewsAddress = "hideViewsAddress";
- (void)hideAllSubView:(UIView*)view{
    for (UIView * subView in view.subviews) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if (subView.hidden) {
            [array addObject:subView];
        }
        objc_setAssociatedObject(self, &HideViewsAddress, array, OBJC_ASSOCIATION_RETAIN);
        subView.hidden = YES;
    }
}

- (void)showAllSubView:(UIView*)view{
    NSMutableArray *array = objc_getAssociatedObject(self,&HideViewsAddress);
    for (UIView * subView in view.subviews) {
        subView.hidden = [array containsObject:subView];
    }
}

- (void)cleanAssocaiteObject{
    objc_setAssociatedObject(self,&PresentedViewAddress,nil,OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self,&PresentingViewAddress,nil,OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self,&HideViewsAddress,nil, OBJC_ASSOCIATION_RETAIN);
}

@end

