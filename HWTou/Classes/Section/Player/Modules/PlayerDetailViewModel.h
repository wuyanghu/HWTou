//
//  PlayerDetailViewModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"

@interface PlayerDetailViewModel : BaseViewModel

@property (nonatomic, copy) NSString *playingUrl;
@property (nonatomic, copy) NSString *bmgs;
@property (nonatomic, copy) NSString *avater;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) int praiseNum;
@property (nonatomic, assign) int lookNum;
@property (nonatomic, assign) int commentNum;
@property (nonatomic, assign) int giftNum;
@property (nonatomic, assign) int radioId;
@property (nonatomic, assign) int rtcId;
@property (nonatomic, assign) int isCollected;

@property (nonatomic, strong) NSMutableArray *bmgsArr;

@property (nonatomic, assign) CGFloat infoCellHeight;

@end
