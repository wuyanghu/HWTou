//
//  PersonInfoCardView.h
//  HWTou
//
//  Created by Reyna on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonHomeDM.h"

@protocol PersonInfoCardViewDelegate
- (void)mePageActionWithUserId:(int)userId isSelf:(BOOL)isSelf;
- (void)attentionActionWithUserId:(int)userId isCancel:(BOOL)isCancel;
@end

@interface PersonInfoCardView : UIView
@property (nonatomic,weak) id<PersonInfoCardViewDelegate> delegate;

- (instancetype)initWithUserModel:(PersonHomeDM *)model isSelf:(BOOL)isSelf userId:(int)userId;

- (void)show;

- (void)dismiss;

- (void)refreshWithState:(NSInteger)state;

@end
