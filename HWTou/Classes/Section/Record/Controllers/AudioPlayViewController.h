//
//  AudioPlayViewController.h
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@protocol AudioPlaydViewControllerDelegate
- (void)rerecordAction;
- (void)saveAction;
@end

@interface AudioPlayViewController : BaseViewController
@property (nonatomic,weak) id<AudioPlaydViewControllerDelegate> delegate;

@end
