//
//  TeacherListView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TeacherModel.h"

@protocol TeacherListViewDelegate <NSObject>

- (void)onDidSelectItem:(TeacherModel *)model didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TeacherListView : UIView

@property (nonatomic, weak) id<TeacherListViewDelegate> m_Delegate;

@end
