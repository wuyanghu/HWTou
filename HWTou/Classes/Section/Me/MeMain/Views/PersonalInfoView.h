//
//  PersonalInfoView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonalInfoDM.h"

@protocol PersonalInfoViewDelegate <NSObject>

- (void)onSelMediaResource;
- (void)onModifyPhone:(NSString *)phone;

@end

@interface PersonalInfoView : UIView

@property (nonatomic, weak) id<PersonalInfoViewDelegate> m_Delegate;

- (void)setPersonalInfo:(PersonalInfoDM *)model;

- (void)modifyPersonalInfo;

- (void)returnsMedia:(UIImage *)img;

@end
