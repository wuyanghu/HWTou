//
//  EditCoverViewController.h
//  HWTou
//  编辑资料
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonHomeDM.h"

@protocol EditCoverViewControllerDelegate
- (void)selectImgArr:(NSArray<UIImage *> *)imgArr;
@end

@interface EditCoverViewController : UIViewController
@property (nonatomic,strong) PersonHomeDM * personHomeModel;
@property (nonatomic,weak) id<EditCoverViewControllerDelegate> editDelegate;

@end
