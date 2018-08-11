//
//  CopperAccountView.h
//  HWTou
//
//  Created by 张维扬 on 2017/8/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestAccountDM;

@interface CopperAccountView : UICollectionReusableView

@property (nonatomic, strong) InvestAccountDM *dmAccount;
@property (nonatomic, assign) float gold; // 提前花余额

@end
