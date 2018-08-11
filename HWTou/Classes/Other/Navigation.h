//
//  Navigation.h
//  HWTou
//
//  Created by Reyna on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PersonalHomePageViewController.h"

@class PlayerHistoryModel, PlayerCommentModel;
@class HomeBannerListModel;
@class PlayerDetailViewModel;
@class TopicWorkDetailModel;
@class MoneyAccountModel;
@class GuessULikeModel;
@interface Navigation : NSObject

/** Record */
+ (void)showAudioRecordViewController:(UIViewController *)from;
+ (void)showAudioPlayViewController:(UIViewController *)from;

/** Radio */
+ (void)showAudioPlayerViewController:(UIViewController *)from radioModel:(id)model completion:(void (^)())completion;

+ (void)showAudioPlayerViewController:(UIViewController *)from radioModel:(id)model;

+ (void)showSubCommentViewController:(UIViewController *)from model:(PlayerCommentModel *)model PlayerHistoryModel:(PlayerHistoryModel *)historyModel playerDetailViewModel:(PlayerDetailViewModel *)playerDetailViewModel;

+ (void)showPlayerHistoryViewController:(UIViewController *)from;

+ (void)showPersonalHomePageViewController:(UIViewController *)from attendType:(PersonHomePageButtonType)attendType uid:(NSInteger)uid;

//banner页跳转
+ (void)showBanner:(UIViewController *)from bannerModel:(HomeBannerListModel *)bannerModel;
//达人主播h5
+ (void)showExpertAnchorHtml5:(UIViewController *)from detailModel:(TopicWorkDetailModel *)detailModel;

/** Web活动链接 */
+ (void)showWebViewController:(UIViewController *)from webLink:(NSString *)webLink;

//跳转到答题车神分享
+ (void)showAnswerShareViewController:(UIViewController *)from title:(NSString *)title webLink:(NSString *)webLink;

//获取服务时间
+ (void)getServeDate:(NSInteger)specId from:(UIViewController *)from isBanner:(BOOL)isBanner;//答题车神

+ (void)showAnswerShareViewController:(UIViewController *)from;

/** 资金相关 */
+ (void)showMyWalletViewController:(UIViewController *)from;
+ (void)showWithdrawMoneyViewController:(UIViewController *)from;


//进入直播
+ (void)joinPushLiveRoom:(UIViewController *)from model:(GuessULikeModel *)model;
//观看直播
+ (void)lookLiveRoom:(UIViewController *)from model:(GuessULikeModel *)model;
//进入聊天室
+ (void)joinChatRoom:(UIViewController *)from model:(GuessULikeModel *)model;
@end
