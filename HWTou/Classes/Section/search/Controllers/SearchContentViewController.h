//
//  SearchContentViewController.h
//  HWTou
//
//  Created by robinson on 2017/12/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,SearchType){
    searchRadioType,//广播
    searchTopicType,//话题
    searchUserType,//用户
    searchChatType,//聊吧
};

@class GuessULikeModel;
@class PersonHomeDM;

typedef void(^SearchContentVCBlock)(GuessULikeModel * uLikeModel);
typedef void(^SearchContentUserVCBlock)(PersonHomeDM * personHomeDM);

@interface SearchContentViewController : BaseViewController
@property (nonatomic,copy) NSString * keywords;

@property (nonatomic,assign) SearchType type;//1: 搜索广播， 2：搜索话题
@property (nonatomic,copy) SearchContentVCBlock searchVCBlock;
@property (nonatomic,copy) SearchContentUserVCBlock searchUserVCBlock;

@end
