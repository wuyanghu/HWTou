//
//  ModifyLoginPwdView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyLoginPwdViewDelegate <NSObject>

- (void)onModifyPwdSuccess;

@end

@interface ModifyLoginPwdView : UIView

@property (nonatomic, weak) id<ModifyLoginPwdViewDelegate> m_Delegate;

@end
