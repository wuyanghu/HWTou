//
//  MemberCenterView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TaskModel.h"
#import "PersonalInfoDM.h"

@protocol MemberCenterViewDelegate <NSObject>

- (void)onDidLevelDescription;
- (void)onDidSelTask:(TaskModel *)model;

@end

@interface MemberCenterView : UIView

@property (nonatomic, weak) id<MemberCenterViewDelegate> m_Delegate;

- (void)setMemberInfo:(PersonalInfoDM *)model;

@end
