//
//  AudioRecordViewController.h
//  HWTou
//
//  Created by Reyna on 2017/12/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@protocol AudioRecordViewControllerDelegate
- (void)didSelectRecordAudio;
@end

@interface AudioRecordViewController : BaseViewController

@property (nonatomic,weak) id<AudioRecordViewControllerDelegate> delegate;

@end
