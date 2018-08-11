//
//  TopicSignSelectView.m
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicSignSelectView.h"
#import "PublicHeader.h"
#import "TopicWorkDetailModel.h"
#import "UIControl+Event.h"
#import "AppDelegate.h"

@interface TopicSignSelectView () {
    
    CGFloat VIEW_WIDTH;
    CGFloat VIEW_HEIGHT;
    CGFloat CONTENT_HEIGHT;
}

@property (nonatomic, strong) UIControl *backImageView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation TopicSignSelectView

- (instancetype)initWithLabelListArray:(NSArray *)array {
    if (self = [super init]) {
        
        self.dataArr = array;
        
        VIEW_WIDTH = 320.f;
        CONTENT_HEIGHT = array.count/2 * 60 + 44 + 20;
        VIEW_HEIGHT = CONTENT_HEIGHT > kMainScreenHeight - 200 ? kMainScreenHeight - 200 : CONTENT_HEIGHT;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    scrollView.contentSize = CGSizeMake(VIEW_WIDTH, CONTENT_HEIGHT);
    [self addSubview:scrollView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, CONTENT_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10.f;
    bgView.layer.masksToBounds = YES;
    [scrollView addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, VIEW_WIDTH - 20, 12)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"请选择您的话题标签";
    titleLab.font = SYSTEM_FONT(12);
    titleLab.textColor = UIColorFromHex(0x646665);
    [bgView addSubview:titleLab];
    
    for (int i=0; i<self.dataArr.count; i++) {
        TopicLabelListModel *m = [self.dataArr objectAtIndex:i];
        
        UIButton *segOne = [UIButton buttonWithType:UIButtonTypeCustom];
        segOne.frame = CGRectMake(i%2 * 168 + 18, i/2 * 60 + 44, 122, 30);
        [segOne setTitle:m.labelName forState:UIControlStateNormal];
        segOne.titleLabel.font = SYSTEM_FONT(17);
        [segOne setTitleColor:UIColorFromHex(0x2b2b2b) forState:UIControlStateNormal];
        segOne.tag = 100 + i;
        segOne.layer.cornerRadius = 15.f;
        segOne.layer.borderColor = UIColorFromHex(0xbfbfbf).CGColor;
        segOne.layer.borderWidth = 1.f;
        [segOne addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:segOne];
    }
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
}

#pragma mark - BtnClickBlock

- (void)btnClicked:(UIButton *)btn {
    
    TopicLabelListModel *labelM = [self.dataArr objectAtIndex:btn.tag - 100];
    [self dismiss];
    if (self.selectBlock) {
        self.selectBlock(labelM);
    }
}

#pragma mark - Custom

- (void)show {
    
    UIViewController *topVC = [self appRootViewController];
    
    topVC.view.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT) * 0.5 - kMainScreenHeight, VIEW_WIDTH, VIEW_HEIGHT);
    
    [topVC.view addSubview:self];
}

- (void)dismiss {
    
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController {
    UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//    while (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
    return window.rootViewController;
}


- (void)removeFromSuperview {
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, kMainScreenHeight + (kMainScreenHeight - VIEW_HEIGHT) * 0.5, VIEW_WIDTH, VIEW_HEIGHT);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        
        [self.backImageView removeFromSuperview];
        self.backImageView = nil;
    }];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIControl alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        __weak typeof(self) weakSelf = self;
        [self.backImageView addEvent:UIControlEventTouchDown callback:^{
            [weakSelf dismiss];
        }];
    }
    [topVC.view addSubview:self.backImageView];
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT) * 0.5, VIEW_WIDTH, VIEW_HEIGHT);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
    
    
    [super willMoveToSuperview:newSuperview];
}


@end
