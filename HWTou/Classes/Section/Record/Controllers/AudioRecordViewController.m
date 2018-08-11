//
//  AudioRecordViewController.m
//  HWTou
//
//  Created by Reyna on 2017/12/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioRecordViewController.h"
#import "UINavigationItem+Margin.h"
#import "PublicHeader.h"
#import "AudioRecordView.h"
#import "FayeFileManager.h"
#import "AudioPlayViewController.h"
#import "BuildTopicViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioRecordViewController ()<AudioRecordViewDelegate, AudioPlaydViewControllerDelegate>

@property (nonatomic, strong) AudioRecordView *recordView;

@end

@implementation AudioRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置导航栏标题字体和颜色
    NSMutableDictionary *dictAttribute = [NSMutableDictionary dictionaryWithCapacity:2];
    [dictAttribute setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [dictAttribute setObject:FontPFRegular(18.0f) forKey:NSFontAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dictAttribute];
    
    // 设置导航栏背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0x171a44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)createUI {
    
    self.title = @"录音";
    
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImageName:@"navi_btn_recordBack" hltImageName:@"navi_btn_recordBack" target:self action:@selector(exitViewController)];
    [self.navigationItem setLeftBarButtonItem:leftItem fixedSpace:0];
    
    [self.view addSubview:self.recordView];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestMicAuthorization];
}

#pragma mark - AudioPlayViewControllerDelegate

- (void)rerecordAction {
    [self.recordView clearRecord];
}

- (void)saveAction {
    if (self.delegate) {
        [self.delegate didSelectRecordAudio];
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[BuildTopicViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark - AudioRecordViewDelegate

- (void)playBtnAction {
    AudioPlayViewController *playVC = [[AudioPlayViewController alloc] init];
    playVC.delegate = self;
    [self.navigationController pushViewController:playVC animated:YES];
}

- (void)saveBtnAction {
    if (self.delegate) {
        [self.delegate didSelectRecordAudio];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fayeRecordStateValueChanged:(NSString *)stateString {
    
    //    [self.state];
}

#pragma mark - Action

- (void)exitViewController {
    
    if (self.recordView.state != FayeVoiceStateDefault) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要放弃录制吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.recordView clearRecord];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:okAction];
        [alert addAction:cancleAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Sup

- (void)requestMicAuthorization {
    
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {// 未授权
        [self showSetAlertView];
    }
}

//提示用户进行麦克风使用授权
- (void)showSetAlertView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"麦克风权限未开启" message:@"麦克风权限未开启，请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:setAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Get

- (AudioRecordView *)recordView {
    if (!_recordView) {
        _recordView = [[AudioRecordView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64)];
        _recordView.delegate = self;
    }
    return _recordView;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
