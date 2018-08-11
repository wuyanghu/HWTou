//
//  InterfaceDefine.h
//
//  Created by PP on 15/11/3.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************************************************/

#pragma mark - Http请求方法
typedef NS_ENUM(NSInteger , HttpRequestMethod) {
    HttpRequestMethodGet = 0,
    HttpRequestMethodPost,
    HttpRequestMethodHead,
    HttpRequestMethodPut,
    HttpRequestMethodDelete,
    HttpRequestMethodPatch
};

#pragma mark - Http请求内容类型
typedef NS_ENUM(NSInteger , HttpRequestSerializerType) {
    HttpRequestSerializerTypeData = 0,
    HttpRequestSerializerTypeJSON,
    HttpRequestSerializerTypePlist
};

#pragma mark - Http响应可接受类型
typedef NS_ENUM(NSInteger , HttpResponseSerializerType) {
    HttpResponseSerializerTypeData = 0,
    HttpResponseSerializerTypeJSON,
    HttpResponseSerializerTypeXML,
    HttpResponseSerializerTypePlist,
    HttpResponseSerializerTypeImage,
};

/**************************************************************/

/**************************************************************/
#pragma mark - 服务器地址
extern NSString *const kApiMoneyServerHost;
extern NSString *const kApiListenServerHost;
extern NSString *const kApiServerHost;
extern NSString *const kHomeServerHost;
extern NSString *const kApiUserServerHost;
//H5
extern NSString *const kApiFayeUserManageRuleUrlHost;
extern NSString *const kApiFayeGreenConventionUrlHost;
extern NSString *const kApiLiaoBaInstructionsUrlHost;
extern NSString *const kApiWithdrawRuleUrlHost;
extern NSString *const kApiInviteStrategyUrlHost;
extern NSString *const kApiAapplyH5ServerHost;
extern NSString *const kApiLiveH5ServerHost;
extern NSString *const kApiShoppMallUrlHost;
extern NSString *const kApiRadioShareUrlHost;
extern NSString *const kApiTopicShareUrlHost;
extern NSString *const kApiChatdetailShareUrlHost;
extern NSString *const kApiCustomH5UrlHost;
extern NSString *const kApiAboutH5UrlHost;
extern NSString *const kApiH5UrlHost;
extern NSString *const kApiUrlHost;
extern NSString *const kApiAnswerLsUrlHost;
extern NSString *const kApiActivityRuleUrlHost;
extern NSString *const kApiMoreplayingUrlHost;
extern NSString *const kApiSuccessUrlHost;
// 微信开放平台地址
extern NSString *const kWechatServerHost;
// 微博开放平台地址
extern NSString *const kWeiboServerHost;

// 文件上传下载相关接口
extern NSString *const kFileUrlHost;
extern NSString *const kApiFileUpload;
extern NSString *const kApiFileBatchUpload;
extern NSString *const kApiFileDownload;

// H5页面地址
extern NSString *const kApiProductDetail;
extern NSString *const kApiProductShare;
extern NSString *const kApiNewsDetail;
extern NSString *const kApiActiDetail;
extern NSString *const kApiSignDetails;
/**************************************************************/

