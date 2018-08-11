//
//  SpecalMusicView.h
//  HWTou
//
//  Created by robinson on 2018/3/21.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSetMusicViewProtocol.h"

@interface SpecalMusicView : UIControl
@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,weak) id<AddSetMusicViewDelegate> specalDelegate;
- (void)show;
- (void)dismiss;
@end
