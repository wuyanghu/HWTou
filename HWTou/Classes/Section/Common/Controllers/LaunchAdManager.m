//
//  LaunchAdManager.m
//  HWTou
//
//  Created by 彭鹏 on 2017/6/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "LaunchAdManager.h"
#import "ComFloorEvent.h"
#import "AdLaunchReq.h"
#import "XHLaunchAd.h"
#import "ComFloorDM.h"


@interface LaunchAdManager () <XHLaunchAdDelegate>

@property (nonatomic, assign) BOOL isClickAd;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) AdLaunchDM *adLaunch;
@property (nonatomic, copy) LaunchAdShowCompleted blockComplted;

@end

@implementation LaunchAdManager

#define kDefaultWaitTime  2   // 启动页默认等待时间

+ (LaunchAdManager *)share
{
    static LaunchAdManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[LaunchAdManager alloc] init];
    });
    return instance;
}

#pragma mark -- 启动广告处理
- (void)showLaunchAdCompleted:(LaunchAdShowCompleted)completed
{
    self.blockComplted = completed;
    self.startTime = [[NSDate date] timeIntervalSince1970];
    
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将自动进入window的RootVC
    //3.数据获取成功,初始化广告时,自动结束等待,显示广告
    [XHLaunchAd setWaitDataDuration:3];
    [AdLaunchReq adLaunchSuccess:^(AdLaunchResp *response) {
        if (response.data.ad_sw) {
            
            NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval interval = endTime - self.startTime;
            NSTimeInterval delaySecond = 0;
            if (interval < kDefaultWaitTime) {
                delaySecond = kDefaultWaitTime - interval;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.adLaunch = response.data;
                XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
                imageAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
                imageAdconfiguration.imageNameOrURLString = self.adLaunch.img_url;
                imageAdconfiguration.duration = self.adLaunch.ad_second;
                imageAdconfiguration.openURLString = @"url"; // 只有设置了才会有点击事件
                [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
            });
        } else {
            !self.blockComplted ?: self.blockComplted();
        }
    } failure:^(NSError *error) {
        !self.blockComplted ?: self.blockComplted();
    }];
}

-(void)xhLaunchShowFinish:(XHLaunchAd *)launchAd
{
    NSLog(@"%s", __FUNCTION__);
    !self.blockComplted ?: self.blockComplted();
    self.blockComplted = nil;
    if (self.isClickAd) {
        self.isClickAd = NO;
        FloorItemDM *dmFloor = [[FloorItemDM alloc] init];
        dmFloor.type = self.adLaunch.click_type;
        dmFloor.param = self.adLaunch.param;
        [ComFloorEvent handleEventWithFloor:dmFloor];
    }
}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString
{
    NSLog(@"%s", __FUNCTION__);
    self.isClickAd = YES;
}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd launchAdImageView:(UIImageView *)launchAdImageView URL:(NSURL *)url
{
    [launchAdImageView sd_setImageWithURL:url];
}
@end
