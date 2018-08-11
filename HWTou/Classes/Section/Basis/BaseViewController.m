//
//  BaseViewController.m
//
//  Created by PP on 15/7/3.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "UINavigationItem+Margin.h"
#import "BaseViewController.h"
#import "PublicHeader.h"

@interface BaseViewController ()
{
    UIImageView     *_imgvBG;
}

@end

@implementation BaseViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)loadView
//{
//    [super loadView];
//
//    [self.view setBackgroundColor:[UIColor whiteColor]];
//}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - Create UI
- (void)createUI
{
    
}

- (void)setupNaviCloseButton
{
    if (self.isShowCloseButton) {
        UIBarButtonItem *btnItem = [UIBarButtonItem itemWithImageName:@"navi_close_btn" hltImageName:nil target:self action:@selector(actionClose)];
        
        NSMutableArray *items = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
        [items addObject:btnItem];
        
        self.tabBarController.navigationItem.leftBarButtonItems = items;
        [self.navigationItem addLeftBarButtonItem:btnItem fixedSpace:20];
    }
}

- (BOOL)isShowCloseButton
{
    return NO;
}

- (void)actionClose
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 设置导航栏标题
- (void)setBackgroupImage:(UIImage *)image
{
    if (!_imgvBG)
    {
        _imgvBG = [[UIImageView alloc] init];
        [self.view addSubview:_imgvBG];
        
        _imgvBG.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_imgvBG attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_imgvBG attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_imgvBG attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_imgvBG attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        NSArray *constraints = @[leftConstraint, rightConstraint, bottomConstraint, heightConstraint];
        [self.view addConstraints:constraints];
    }
    [_imgvBG setImage:image];
}

#pragma mark - 屏幕旋转控制
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - 设置导航栏颜色
- (void)setNavBarColor:(UIColor *)navBarColor
{
    if (navBarColor)
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:navBarColor]
                                                      forBarMetrics:UIBarMetricsDefault];
    }
}

@end
