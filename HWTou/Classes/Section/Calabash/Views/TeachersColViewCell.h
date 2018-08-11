//
//  TeachersColViewCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TeacherModel.h"

#define kTeachersColViewCellId       (@"TeachersColCellId")

@protocol TeachersColViewCellDelegate <NSObject>



@end

@interface TeachersColViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) TeacherModel *m_Model;
@property (nonatomic, weak) id<TeachersColViewCellDelegate> m_Delegate;

- (void)setTeachersColCellUpDataSource:(TeacherModel *)model
                 cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
