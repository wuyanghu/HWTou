//
//  HighInfoPlayInstance.h
//  HWTou
//
//  Created by robinson on 2018/1/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HistoryTopModel,PlayHighInfoViewModel;
@class ChatMusicListModel;

typedef void(^HighInfoPlayBlock)(HistoryTopModel * topModel);
typedef void(^HighInfoRefreshViewBlock)(HistoryTopModel * topModel);

@interface HighInfoPlayInstance : NSObject

@property (nonatomic,assign) NSInteger chatId;
@property (nonatomic,copy) HighInfoPlayBlock highBlock;
@property (nonatomic,copy) HighInfoPlayBlock highRefreshViewBlock;

@property (nonatomic,strong) PlayHighInfoViewModel * highInfoVM;
@property (nonatomic,strong) NSMutableArray<ChatMusicListModel *> * chatMusicListArray;//背景音乐
+ (instancetype)sharedInstance;

- (void)externalTopComsRequest;
- (void)dataInit:(NSInteger)chatId;

- (void)stopAnimation;//结束动画
- (void)startAnimation;//开始动画
- (void)setCurrentPlayModel:(HistoryTopModel *)topModel;//设置当前播放
- (void)handleDelloc;//销毁变量
@end
