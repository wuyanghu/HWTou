//
//  AudioPlayViewController.m
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioPlayViewController.h"
#import "UINavigationItem+Margin.h"
#import "PublicHeader.h"
#import "AudioPlayView.h"

@interface AudioPlayViewController () <AudioPlayViewDelegate>

@property (nonatomic, strong) AudioPlayView *playView;

@end

@implementation AudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI {
    
    self.title = @"试听";
    
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImageName:@"navi_btn_recordBack" hltImageName:@"navi_btn_recordBack" target:self action:@selector(exitViewController)];
    [self.navigationItem setLeftBarButtonItem:leftItem fixedSpace:0];
    
    [self.view addSubview:self.playView];
}

#pragma mark - ClearPlayer

- (void)clearPlayer {
    
    [self.playView clearPlayer];
}

#pragma mark - AudioPlayViewDelegate

- (void)rerecordBtnAction {
    
    if (self.delegate) {
        [self.delegate rerecordAction];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtnAction {
    
    if (self.delegate) {
        [self.delegate saveAction];
    }
}

#pragma mark - Action

- (void)exitViewController {
    
    [self clearPlayer];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Get

- (AudioPlayView *)playView {
    if (!_playView) {
        _playView = [[AudioPlayView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64)];
        _playView.delegate = self;
    }
    return _playView;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
