//
//  ReplyVideoPlayerViewController.m
//  HWTou
//
//  Created by Reyna on 2018/1/24.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ReplyVideoPlayerViewController.h"
#import "AudioPlayerView.h"

@interface ReplyVideoPlayerViewController ()

@end

@implementation ReplyVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[AudioPlayerView sharedInstance] resumeByVoiceReplyEnd];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
