//
//  NTESLiveChatView.h
//  NIMLiveDemo
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMessageModel.h"

@protocol NTESLiveChatViewDelegate <NSObject>

- (void)onTapChatView:(CGPoint)point;
- (void)longGesturePress:(NTESMessageModel *)model;
- (void)headerAction:(NTESMessageModel *)model;
@end

@interface NTESLiveChatView : UIView

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,weak) id<NTESLiveChatViewDelegate> delegate;

- (void)addMessages:(NSArray<NIMMessage *> *)messages;

@end
