//
//  MainTabBarControllerConfig.m
//  HWTou
//
//  Created by Reyna on 2017/12/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MainTabBarControllerConfig.h"
#import <UIKit/UIKit.h>
#import "HomePageViewController.h"
#import "HomeWYViewController.h"
#import "MeViewController.h"
#import "CustomNavigationController.h"
#import "PublicHeader.h"

static CGFloat const MainTabBarControllerHeight = 49.f;

@interface MainTabBarControllerConfig ()<UITabBarControllerDelegate>

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation MainTabBarControllerConfig

+ (instancetype)sharedInstance {
    static MainTabBarControllerConfig *config = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [[MainTabBarControllerConfig alloc] init];
    });
    
    return config;
}

- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        /**
         * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
         * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
         * 更推荐后一种做法。
         */
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
        UIOffset titlePositionAdjustment = UIOffsetZero;//UIOffsetMake(0, MAXFLOAT);
        
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                             imageInsets:imageInsets
                                                                                 titlePositionAdjustment:titlePositionAdjustment];
        
        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (NSArray *)viewControllers {
    HomePageViewController *firstViewController = [[HomePageViewController alloc] init];
    CustomNavigationController *firstNavigationController = [[CustomNavigationController alloc] initWithRootViewController:firstViewController];
    
    HomeWYViewController *wyVC = [[HomeWYViewController alloc] init];
    CustomNavigationController *midNAV = [[CustomNavigationController alloc] initWithRootViewController:wyVC];
    
    MeViewController *fourthViewController = [[MeViewController alloc] init];
    CustomNavigationController *fourthNavigationController = [[CustomNavigationController alloc] initWithRootViewController:fourthViewController];
    
    
    NSArray *viewControllers = @[firstNavigationController, midNAV, fourthNavigationController];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{CYLTabBarItemTitle : @"聊吧", CYLTabBarItemImage : @"tab_quwan_icon1", CYLTabBarItemSelectedImage : @"tab_quwan_icon"};
    NSDictionary *midTabBarItemsAttributes = @{CYLTabBarItemTitle : @"唯艺商城", CYLTabBarItemImage : @"tab_btn_wy", CYLTabBarItemSelectedImage : @"tab_btn_wy1"};
    NSDictionary *fourthTabBarItemsAttributes = @{CYLTabBarItemTitle : @"我的", CYLTabBarItemImage : @"tab_btn_wd", CYLTabBarItemSelectedImage : @"tab_btn_wd1"};
    NSArray *tabBarItemsAttributes = @[firstTabBarItemsAttributes, midTabBarItemsAttributes, fourthTabBarItemsAttributes];
    return tabBarItemsAttributes;
}

- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {

    if (CYL_IS_IPHONE_X) {
    }
    else {
        tabBarController.tabBarHeight = MainTabBarControllerHeight;
    }
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
//    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [normalAttrs setObject:FontPFMedium(11.0f) forKey:NSFontAttributeName];
    [normalAttrs setObject:[UIColor colorWithWhite:0.498 alpha:1] forKey:NSForegroundColorAttributeName];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [selectedAttrs setObject:FontPFMedium(11.0f) forKey:NSFontAttributeName];
    [selectedAttrs setObject:[UIColor colorWithRed:0.706 green:0.157 blue:0.176 alpha:1] forKey:NSForegroundColorAttributeName];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

#pragma mark - Sup

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    CGFloat tabBarHeight = MainTabBarControllerHeight;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor yellowColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) {
        return nil;
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
