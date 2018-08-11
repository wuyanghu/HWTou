//
//  PlayerDetailViewModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
@class ChatMusicListModel;

@protocol PlayerDetailViewModelDelegate
- (void)modityViewState;
@end

@interface PlayerDetailViewModel : BaseViewModel
{
    NSTimer * timer;
    
}
@property (nonatomic, copy) NSString *playingUrl;
@property (nonatomic, copy) NSString *bmgs;
@property (nonatomic, copy) NSString *avater;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSAttributedString *htmlContent;
@property (nonatomic, copy) NSString *contentImg;//内容图片
@property (nonatomic, strong) NSMutableArray *contentImgsArray;//内容图片数组

//@property (nonatomic, copy) NSAttributedString * contentAttributedText;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) int praiseNum;
@property (nonatomic, assign) int lookNum;
@property (nonatomic, assign) int commentNum;
@property (nonatomic, assign) int giftNum;
@property (nonatomic, assign) int radioId;
@property (nonatomic, assign) int rtcId;
@property (nonatomic, assign) int isCollected;
@property (nonatomic, assign) int chatDefNum;//聊吧默认播放条数
@property (nonatomic,strong) NSMutableArray<ChatMusicListModel*> * chatMusicListArray;

@property (nonatomic, copy) NSString *createBy;
@property (nonatomic, copy) NSString *labelNames;

@property (nonatomic, strong) NSMutableArray *bmgsArr;

@property (nonatomic, assign) CGFloat imgsHeight;
@property (nonatomic, assign) CGFloat infoCellHeight;


@property (nonatomic,weak) id<PlayerDetailViewModelDelegate> detailViewModelDelegate;
@property (nonatomic, assign) CGFloat priaseNum;
- (void)startTimer;
- (void)stopTimer;
//减少能量条
- (void)reduceZanEnergy;
//增加能量条
- (void)addZanEnergy;
@end
