//
//  CustomerAndFeedbackView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerAndFeedbackViewDelegate <NSObject>



@end

@interface CustomerAndFeedbackView : UIView

@property (nonatomic, weak) id<CustomerAndFeedbackViewDelegate> m_Delegate;

@end
