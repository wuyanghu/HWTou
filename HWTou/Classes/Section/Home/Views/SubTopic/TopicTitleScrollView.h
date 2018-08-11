//
//  TopicTitleScrollView.h
//  HWTou
//
//  Created by robinson on 2018/1/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicWorkDetailModel.h"

@protocol TopicTitleScrollViewDelegate
- (void)selectedLabelTopic:(NSInteger)selectedIndex;
@end

@interface TopicTitleScrollView : UIView
@property (nonatomic,strong) NSArray<TopicLabelListModel *> * dataArray;//收缩数据源
@property (nonatomic,strong) NSArray<TopicLabelListModel *> * allDataArray;//展开数据源
@property (nonatomic,assign) NSInteger selectedTopicLabelIndex;//记录标题选中index
@property (nonatomic,weak) id<TopicTitleScrollViewDelegate> selectedDelegate;
@property (nonatomic, assign) BOOL isTitleExp;
@end
