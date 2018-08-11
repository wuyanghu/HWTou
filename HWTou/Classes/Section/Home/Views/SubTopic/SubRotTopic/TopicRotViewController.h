//
//  TopicRotViewController.h
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TopicType) {
    TopicRotType,//热门话题
    TopicMeType,//我的话题
};

@interface TopicRotViewController : UIViewController
@property (nonatomic,assign) TopicType topicType;
@end
