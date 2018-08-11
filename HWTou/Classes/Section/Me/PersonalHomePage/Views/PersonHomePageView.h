//
//  PersonHomePageView.h
//  HWTou
//
//  Created by robinson on 2017/11/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonHomeReq.h"

typedef NS_ENUM(NSInteger,PersonHomePageButtonType) {
    editDataButtonType = 101,//编辑资料
    dynamicButtonType,//关注
};

@protocol PersonHomePageViewDelegate
- (void)buttonSelectedEdit:(UIButton *)button;//编辑资料
- (void)buttonClick:(UIButton *)button;
- (void)segmentChange:(UISegmentedControl *)segmentedControl;
@end

@interface PersonHomePageView : UIView
@property (nonatomic,assign) PersonHomePageButtonType buttonType;
@property (nonatomic,strong) PersonHomeDM * personHomeModel;
@property (nonatomic,weak) id<PersonHomePageViewDelegate> homePageDelegate;
@property (nonatomic,strong) UISegmentedControl *segment;
@property (nonatomic, assign) BOOL isHost;

- (void)isAttend:(NSInteger)isFocus;
@end
