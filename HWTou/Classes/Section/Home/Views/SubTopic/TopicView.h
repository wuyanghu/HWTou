//
//  TopicView.h
//  HWTou
//
//  Created by robinson on 2017/11/17.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "TopicWorkDetailModel.h"
#import "HomeBanerListViewModel.h"

@protocol TopicViewDelegate
- (void)loadNewData;//加载最新数据
- (void)loadHistoryData:(TopicLabelListModel *)labelListModel;//加载最新数据
- (void)selecedLabelTopic:(TopicLabelListModel *)labelListModel;//选择今日优选标签
- (void)selectedTopicListModel:(MyTopicListModel *)topicListModel;//选择热门话题
- (void)selectedTodayTopicList:(MyTopicListModel *)topicListModel;//选择话题列表
- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index;
@end

@interface TopicView : UIView
@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic,assign) NSInteger selectedTopicLabelIndex;//记录标题选中index
@property (nonatomic,assign) id<TopicButtonSelectedDelegate> btnDelegate;
@property (nonatomic,assign) id<TopicViewDelegate> topicViewDelegate;

@property (nonatomic,strong) NSMutableArray * titleArray;//话题标签列表
@property (nonatomic,strong) NSMutableArray * showTitleArray;//话题标签列表
@property (nonatomic,strong) NSMutableArray * hotTopicListArr;//热门列表
@property (nonatomic,strong) NSMutableArray * todayTopicListArr;//今日优选列表

@property (nonatomic,strong) HomeBanerListViewModel * bannerListViewModel;
- (void)refreshData;
@end

