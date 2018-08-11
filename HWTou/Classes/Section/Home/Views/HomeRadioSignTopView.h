//
//  HomeRadioSignTopView.h
//  HWTou
//
//  Created by Reyna on 2018/3/29.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeRadioSignModel.h"

@protocol HomeRadioSignTopViewDelegate
- (void)itemSelected:(HomeRadioSignModel *)radioSignModel;
@end

@interface HomeRadioSignTopView : UIView

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, weak) id<HomeRadioSignTopViewDelegate> deleagte;

@end
