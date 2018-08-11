//
//  PersonInfoCardView.m
//  HWTou
//
//  Created by Reyna on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonInfoCardView.h"
#import "PublicHeader.h"
#import "UIControl+Event.h"
#import "ComCarouselView.h"

@interface PersonInfoCardView () {
    
    CGFloat VIEW_WIDTH;
    CGFloat VIEW_HEIGHT;
    
    UIButton *segTwo;
}

@property (nonatomic, strong) UIControl *backImageView;
@property (nonatomic, strong) PersonHomeDM *model;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) int userId;

@end

@implementation PersonInfoCardView

- (instancetype)initWithUserModel:(PersonHomeDM *)model isSelf:(BOOL)isSelf userId:(int)userId {
    if (self = [super init]) {
        
        self.model = model;
        self.isSelf = isSelf;
        self.userId = userId;
        
        VIEW_WIDTH = 320.f;
        VIEW_HEIGHT = 400.f;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
   
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT + 81)];
    [self addSubview:backgroundView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10.f;
    bgView.layer.masksToBounds = YES;
    [backgroundView addSubview:bgView];
    
    NSArray *bmgsArray = [self.model getBgBmgs];
    ComCarouselImageView *civ = [[ComCarouselImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT/2.0)];
    civ.imageURLStringsGroup = bmgsArray;
    [bgView addSubview:civ];
    
    UIImageView *headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 220, 48, 48)];
    [headerIV sd_setImageWithURL:[NSURL URLWithString:self.model.headUrl]];
    [bgView addSubview:headerIV];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(64, 235, VIEW_WIDTH - 64, 18)];
    nameLab.text = self.model.nickname;
    nameLab.font = SYSTEM_FONT(14);
    nameLab.textColor = UIColorFromHex(0x8e8f91);
    [bgView addSubview:nameLab];
    
    NSArray *typeArray = @[@"粉丝",@"关注"];
    NSArray *numArray = @[[NSString stringWithFormat:@"%ld",self.model.fansNum],[NSString stringWithFormat:@"%ld",self.model.focusNum]];
    for (int i=0; i<typeArray.count; i++) {
        
        float pieces = typeArray.count * 1.0;
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH/pieces * i, 284, VIEW_WIDTH/pieces, 24)];
        contentLab.textAlignment = NSTextAlignmentCenter;
        contentLab.text = numArray[i];
        contentLab.font = SYSTEM_FONT(24);
        contentLab.textColor = UIColorFromHex(0x2b2b2b);
        [bgView addSubview:contentLab];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH/pieces * i, 312, VIEW_WIDTH/pieces, 12)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = typeArray[i];
        titleLab.font = SYSTEM_FONT(12);
        titleLab.textColor = UIColorFromHex(0x646665);
        [bgView addSubview:titleLab];
    }
    CGFloat btnRatio = 82/167.0;
    CGFloat b_y;
    if (VIEW_WIDTH/2.0 * btnRatio > VIEW_HEIGHT - 329) {
        b_y = 329;
    }
    else {
        b_y = VIEW_HEIGHT - VIEW_WIDTH/2.0 * btnRatio;
    }
    UIButton *segOne = [UIButton buttonWithType:UIButtonTypeCustom];
    segOne.frame = CGRectMake(0, b_y, VIEW_WIDTH/2.0, VIEW_WIDTH/2.0 * btnRatio);
    [segOne setBackgroundImage:[UIImage imageNamed:@"btn_gr"] forState:UIControlStateNormal];
    segOne.layer.cornerRadius = 15.f;
    [segOne addTarget:self action:@selector(mePageAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:segOne];
    
    if (!_isSelf) {
        segTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        segTwo.frame = CGRectMake(VIEW_WIDTH/2.0, b_y, VIEW_WIDTH/2.0, VIEW_WIDTH/2.0 * btnRatio);
        UIImage *img = self.model.isFocus == 0 ? [UIImage imageNamed:@"btn_gz"] : [UIImage imageNamed:@"btn_wgz"];
        [segTwo setBackgroundImage:img forState:UIControlStateNormal];
        segTwo.layer.cornerRadius = 15.f;
        [segTwo addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:segTwo];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((VIEW_WIDTH - 1.5)/2.0, VIEW_HEIGHT, 1.5, 30)];
    lineView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:lineView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake((VIEW_WIDTH - 51)/2.0, VIEW_HEIGHT + 30, 51, 51);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"card_btn_cancel"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:backBtn];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
}

#pragma mark - BtnClickBlock

- (void)mePageAction:(UIButton *)btn {

    if (self.delegate) {
        [self.delegate mePageActionWithUserId:self.userId isSelf:self.isSelf];
    }
    [self dismiss];
}

- (void)attentionAction:(UIButton *)btn {
//    [self dismiss];
    
    if (self.delegate && !self.isSelf) {
        if (self.model.isFocus == 0) {
            [self.delegate attentionActionWithUserId:self.userId isCancel:NO];
        }
        else {
            [self.delegate attentionActionWithUserId:self.userId isCancel:YES];
        }
    }
}

- (void)backBtnAction {
    
    [self dismiss];
}

#pragma mark - Custom

- (void)show {
    
    UIViewController *topVC = [self appRootViewController];
    
    topVC.view.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT - 81) * 0.5 + kMainScreenHeight, VIEW_WIDTH, VIEW_HEIGHT + 81);
    
    [topVC.view addSubview:self];
}

- (void)dismiss {
    
    [self removeFromSuperview];
}

- (void)refreshWithState:(NSInteger)state {
    self.model.isFocus = state;
    
    UIImage *img = self.model.isFocus == 0 ? [UIImage imageNamed:@"btn_gz"] : [UIImage imageNamed:@"btn_wgz"];
    [segTwo setBackgroundImage:img forState:UIControlStateNormal];
}

- (UIViewController *)appRootViewController {
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview {
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, kMainScreenHeight + (kMainScreenHeight - VIEW_HEIGHT - 81) * 0.5, VIEW_WIDTH, VIEW_HEIGHT + 81);
    
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
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
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT - 81) * 0.5, VIEW_WIDTH, VIEW_HEIGHT + 81);
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
    
    
    [super willMoveToSuperview:newSuperview];
}

@end

