//
//  AddSetMusicView.h
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSetMusicViewProtocol.h"

@interface AddSetMusicView : UIControl
@property (nonatomic,weak) id<AddSetMusicViewDelegate> addDelegate;
- (void)show;
- (void)dismiss;
@end
