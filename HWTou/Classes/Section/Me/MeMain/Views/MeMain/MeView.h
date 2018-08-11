//
//  MeView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeFuncModel.h"
#import "PersonalInfoDM.h"
#import "PersonHomeDM.h"
#import "MeViewProtocol.h"

@interface MeView : UIView

@property (nonatomic, weak) id<MeViewProtocol> m_Delegate;
@property (nonatomic,strong) PersonHomeDM * personHomeModel;
- (void)obtainPersonalInfo;

@end

