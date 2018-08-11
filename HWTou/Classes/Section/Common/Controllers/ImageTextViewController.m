//
//  ImageTextViewController.m
//  HWTou
//
//  Created by Reyna on 2018/2/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ImageTextViewController.h"
#import "HomeBannerListModel.h"
#import "PublicHeader.h"

@interface ImageTextViewController ()

@end

@implementation ImageTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:_bannerModel.title];
    
    [self createUI];
}

- (void)createUI {
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    [webView loadHTMLString:self.bannerModel.imgText baseURL:nil];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
