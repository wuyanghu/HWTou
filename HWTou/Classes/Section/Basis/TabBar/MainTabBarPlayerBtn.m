//
//  MainTabBarPlayerBtn.m
//  HWTou
//
//  Created by Reyna on 2017/12/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MainTabBarPlayerBtn.h"
#import "PublicHeader.h"

@interface MainTabBarPlayerBtn () {
    CGFloat _buttonImageHeight;
}
@end

@implementation MainTabBarPlayerBtn

#pragma mark - Life Cycle

+ (void)load {
    //在 -application:didFinishLaunchingWithOptions: 中进行注册
    //[super registerPlusButton];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

//上下结构的 button
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 控件大小,间距大小
    // 注意：一定要根据项目中的图片去调整下面的0.7和0.9，Demo之所以这么设置，因为demo中的 plusButton 的 icon 不是正方形。
    CGFloat const imageViewEdgeWidth   = self.bounds.size.width * 1.0;
    CGFloat const imageViewEdgeHeight  = self.bounds.size.height * 1.0;
    
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const centerOfImageView  = self.bounds.size.height * 0.5;

    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdgeWidth, imageViewEdgeHeight);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
}

#pragma mark - CYLPlusButtonSubclassing Methods

+ (id)plusButton {
    
    MainTabBarPlayerBtn *button = [[MainTabBarPlayerBtn alloc] init];
    UIImage *buttonImage = [UIImage imageNamed:@"tab_play"];
    [button setImage:buttonImage forState:UIControlStateNormal];
    UIImage *buttonSelectedImage = [UIImage imageNamed:@"tab_zt"];
    [button setImage:buttonSelectedImage forState:UIControlStateSelected];
//    [button sizeToFit];
    button.frame = CGRectMake(0, 0, 55, 50);
    [button addTarget:button action:@selector(playerAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Event Response

- (void)playerAction {
    CYLTabBarController *tabBarController = [self cyl_tabBarController];
    UIViewController *viewController = tabBarController.selectedViewController;
    
    [Navigation showAudioPlayerViewController:viewController radioModel:nil];
}

#pragma mark - CYLPlusButtonSubclassing

+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    return  0.5;
}

+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
    return  CYL_IS_IPHONE_X ? -30 : -10;
}

@end
