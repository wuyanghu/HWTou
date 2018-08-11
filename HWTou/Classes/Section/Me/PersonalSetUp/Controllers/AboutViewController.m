//
//  AboutViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AboutViewController.h"
#import "InterfaceDefine.h"
#import "PublicHeader.h"

@interface AboutViewController ()


@end

@implementation AboutViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"关于发耶"];
    
    NSString *url = [NSString stringWithFormat:@"%@/editor/item/faye", kHomeServerHost];
    [self loadWebWithUrl:url];
}

@end
