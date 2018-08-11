//
//  MeHeaderReusableView.h
//  HWTou
//
//  Created by robinson on 2017/12/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeViewProtocol.h"

@class PersonHomeDM;

@interface MeHeaderReusableView : UICollectionReusableView
@property (nonatomic, strong) UIImageView * bgView;//背景
@property (nonatomic, strong) UIImageView * headerImageView;//头像

@property (nonatomic, strong) UILabel * userNameLabel;//昵称
@property (nonatomic, strong) UIButton * fansBtn;//粉丝
@property (nonatomic, strong) UIButton * attentBtn;//关注

@property (nonatomic, weak) id<MeViewProtocol> m_Delegate;

@property (nonatomic,strong) PersonHomeDM * personHomeModel;

+ (NSString *)cellIdentity;
@end

@interface MeHeaderBgView : UICollectionReusableView
+ (NSString *)cellIdentity;
@end
