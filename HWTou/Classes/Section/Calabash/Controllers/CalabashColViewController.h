//
//  CalabashColViewController.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalabashColView.h"

@protocol CalabashColViewControllerDelegate <NSObject>

- (void)onViewSelectedInformationWithColType:(CalabashColType)colType
                              withDataSource:(NSObject *)object;

@end

@interface CalabashColViewController : UIViewController

@property (nonatomic, weak) id<CalabashColViewControllerDelegate> m_Delegate;

- (void)setCalabashColViewType:(CalabashColType)colType;

@end
