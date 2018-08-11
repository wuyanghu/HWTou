//
//  ReplacePhoneView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReplacePhoneViewDelegate <NSObject>

- (void)onReplacePhone:(NSString *)phone;

@end

@interface ReplacePhoneView : UIView

@property (nonatomic, weak) id<ReplacePhoneViewDelegate> m_Delegate;

@end
