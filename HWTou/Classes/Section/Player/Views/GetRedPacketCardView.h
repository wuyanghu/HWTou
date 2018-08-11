//
//  GetRedPacketCardView.h
//  HWTou
//
//  Created by Reyna on 2018/3/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerCommentModel.h"

@interface GetRedPacketCardView : UIView

@property (nonatomic, copy) dispatch_block_t refreshBlock;

- (instancetype)initWithModel:(PlayerCommentModel *)model rtcId:(int)rtcId;

- (void)show;

- (void)dismiss;

@end
