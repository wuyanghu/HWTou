//
//  InterfaceDefine.m
//
//  Created by PP on 15/11/3.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import "InterfaceDefine.h"

/**************************************************************/

#pragma mark - 服务器地址
//理财，电商url
//NSString *const kApiServerHost = @"http://hangwt-api.palcomm.com.cn";
//NSString *const kHomeServerHost = @"https://web.hangwt.cn";
//NSString *const kHomeServerHost = @"http://hangwt-home.palcomm.com.cn";
//NSString *const kHomeServerHost = @"http://hangwt-home-test.palcomm.com.cn";

//测试IP
//NSString *const kApiAnswerLsUrlHost = @"http://dev.faye.rbson.net:8099/zuul/fayeactivity";  //测试环境<答题车神>
//NSString *const kApiMoneyServerHost = @"http://dev.faye.rbson.net:8099/zuul/fayefinance";   //测试环境<资金服务>
//NSString *const kApiUserServerHost = @"http://dev.faye.rbson.net:8099/zuul/fayemyself";    //测试环境<用户服务>
//NSString *const kApiListenServerHost = @"http://dev.faye.rbson.net:8099/zuul/fayelisten";  //测试环境<听说服务>
//NSString *const kApiServerHost = @"";                                      //测试环境<好选商城>
//NSString *const kHomeServerHost = @"";                                     //测试环境<好选商城>
//NSString *const kApiAapplyH5ServerHost = @"https://h5.faye.rbson.net/applyanchordev/#/";
//NSString *const kApiChatdetailShareUrlHost = @"https://h5.faye.rbson.net/chatdetaildev/#/";
//NSString *const kApiUrlHost = @"http://dev.faye.rbson.net";

NSString *const kApiAnswerLsUrlHost = @"http://dev.faye.rbson.net:8090";  //测试环境<答题车神>
NSString *const kApiMoneyServerHost = @"http://dev.faye.rbson.net:8998";   //测试环境<资金服务>
NSString *const kApiUserServerHost = @"http://dev.faye.rbson.net:8996";    //测试环境<用户服务>
NSString *const kApiListenServerHost = @"http://dev.faye.rbson.net:8993";  //测试环境<听说服务>
NSString *const kApiServerHost = @"";                                      //测试环境<好选商城>
NSString *const kHomeServerHost = @"";                                     //测试环境<好选商城>
NSString *const kApiAapplyH5ServerHost = @"https://h5.faye.rbson.net/applyhostdev/#/";
NSString *const kApiChatdetailShareUrlHost = @"https://h5.faye.rbson.net/chatdetaildev/#/";
NSString *const kApiUrlHost = @"http://dev.faye.rbson.net";
NSString * const kApiLiveH5ServerHost = @"https://h5.faye.rbson.net/chatroomdev/#/";
NSString *const kApiShoppMallUrlHost = @"http://dev.fayeapp.com/zuul/fayeshop";   //测试环境<商城>

//正式IP
//NSString *const kApiAnswerLsUrlHost = @"http://api.fayeapp.com:8884";   //正答环境<答题车神>
//NSString *const kApiMoneyServerHost = @"http://api.fayeapp.com:8883";    //正式环境<资金服务>
//NSString *const kApiUserServerHost = @"http://api.fayeapp.com:8881";     //正式环境<用户服务>
//NSString *const kApiListenServerHost = @"http://api.fayeapp.com:8880";   //正式环境<听说服务>
//NSString *const kApiServerHost = @"http://api.faye.rbson.net:8090";      //正式环境<好选商城>
//NSString *const kHomeServerHost = @"http://api.faye.rbson.net:8090";     //正式环境<好选商城>
//NSString *const kApiAapplyH5ServerHost = @"https://h5.faye.rbson.net/applyhost/#/";//达人主播申请
//NSString *const kApiChatdetailShareUrlHost = @"https://h5.faye.rbson.net/chatdetail/#/";
//NSString *const kApiUrlHost = @"http://api.faye.rbson.net";
//NSString * const kApiLiveH5ServerHost = @"https://h5.faye.rbson.net/chatroom/#/";
//NSString *const kApiShoppMallUrlHost = @"http://api.fayeapp.com/zuul/fayeshop";   //正答环境<商城>

//H5服务IP
NSString *const kApiFayeUserManageRuleUrlHost = @"https://h5.faye.rbson.net/usermanagerrules/#/"; //发耶平台用户管理条例
NSString *const kApiFayeGreenConventionUrlHost = @"https://h5.faye.rbson.net/platrules/#/"; //发耶声音互动平台绿色公约
NSString *const kApiLiaoBaInstructionsUrlHost = @"https://h5.faye.rbson.net/anchorusehandbook/#/"; //聊吧主播使用手册

NSString *const kApiWithdrawRuleUrlHost = @"https://h5.faye.rbson.net/purserules/#/"; //提现规则
NSString *const kApiInviteStrategyUrlHost = @"https://h5.faye.rbson.net/invitedactived/#/"; //邀请攻略
NSString *const kApiActivityRuleUrlHost = @"https://h5.faye.rbson.net/dabaaruleske/#/";// 活动规则
NSString *const kApiMoreplayingUrlHost = @"https://h5.faye.rbson.net/moreplaying/#/";//获取更多
NSString *const kApiSuccessUrlHost = @"https://h5.faye.rbson.net/successshare/#/";//成功分享
NSString *const kApiH5UrlHost = @"https://h5.faye.rbson.net";
NSString *const kApiRadioShareUrlHost = @"https://h5.faye.rbson.net/radiodetail/#/";
NSString *const kApiTopicShareUrlHost = @"https://h5.faye.rbson.net/radiodetail/#/";
NSString *const kApiCustomH5UrlHost = @"https://h5.faye.rbson.net/custom/?type=1";//客服与反馈
NSString *const kApiAboutH5UrlHost = @"https://h5.faye.rbson.net/about/";//关于
//开放平台地址
NSString *const kWechatServerHost = @"https://api.weixin.qq.com";
NSString *const kWeiboServerHost = @"https://api.weibo.com";
NSString *const kFileUrlHost = @"http://api.fayeapp.com:8880";//文件上传下载相关接口


NSString *const kApiProductDetail = @"editor/item/index";
NSString *const kApiNewsDetail = @"fy_mobile/dist/index.html#/indexNews";
NSString *const kApiActiDetail = @"fy_mobile/dist/index.html#/actDetails";
NSString *const kApiProductShare = @"fy_mobile/dist/index.html#/spendProInfo";
NSString *const kApiSignDetails =  @"fy_mobile/dist/index.html#/signDetails";

NSString *const kApiFileUpload = @"oss/uploadImg";//单个图片上传
NSString *const kApiFileBatchUpload = @"oss/uploadImgs";//批量上传
NSString *const kApiFileDownload = @"universe/index/download";

/**************************************************************/
