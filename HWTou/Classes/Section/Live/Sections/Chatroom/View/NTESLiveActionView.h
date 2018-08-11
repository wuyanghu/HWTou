//
//  NTESLiveActionView.h
//  NIM
//
//  Created by chris on 16/1/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESChatroomSegmentedControl.h"
#import "NTESPageView.h"
#import "NTESLiveViewDefine.h"

@protocol NTESLiveActionViewDataSource <NSObject>

@required
- (NSInteger)numberOfPages;

- (UIView *)viewInPage:(NSInteger)index;

- (CGFloat)liveViewHeight;

@end


@protocol NTESLiveActionViewDelegate <NSObject>

@optional

- (void)onSegmentControlChanged:(NTESChatroomSegmentedControl *)control;

- (void)onTouchActionBackground;

- (void)onActionType:(NTESLiveActionType)type sender:(id)sender;

@end

@interface NTESLiveActionView : UIView

@property (nonatomic, strong) NTESPageView *pageView;

@property (nonatomic,weak) id<NTESLiveActionViewDataSource> datasource;

@property (nonatomic,weak) id<NTESLiveActionViewDelegate> delegate;

- (instancetype)initWithDataSource:(id<NTESLiveActionViewDataSource>) datasource;

- (void)reloadData;

#pragma mark  - 直播
- (void)setActionType:(NTESLiveActionType)type disable:(BOOL)disable;

- (void)updateInteractButton:(NSInteger)count;

- (void)firstLineViewMoveToggle:(BOOL)isMoveUp;

- (void)updateFocusButton:(BOOL)isOn;

- (void)updateflashButton:(BOOL)isOn;

- (void)updateMirrorButton:(BOOL)isOn;

- (void)updateBeautify:(BOOL)isBeautify;

- (void)updateQualityButton:(BOOL)isHigh;

- (void)updateWaterMarkButton:(BOOL)isOn;
@end
