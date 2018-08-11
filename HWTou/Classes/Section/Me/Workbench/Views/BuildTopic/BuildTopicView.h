//
//  BuildTopic.h
//  HWTou
//
//  Created by robinson on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "TopicWorkDetailModel.h"

@protocol BuildTopicViewDelegate
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BuildTopicView : UIView<TopicButtonSelectedDelegate>
@property (nonatomic,weak) id<TopicButtonSelectedDelegate> btnDelegate;
@property (nonatomic,weak) id<BuildTopicViewDelegate> topicDelegate;

@property (nonatomic,strong) NSArray * vCarouselImgArr;

@property (nonatomic,copy) NSString * labelTitle;
//分享内容
- (NSString *)shareContent;
//标题
- (NSString *)getTitle;
@end
