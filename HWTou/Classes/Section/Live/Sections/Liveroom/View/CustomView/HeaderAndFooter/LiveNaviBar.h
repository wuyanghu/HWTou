//
//  LiveNaviBar.h
//  HWTou
//
//  Created by robinson on 2018/3/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveNaviBarProtocol.h"

@interface LiveNaviBar : UIView
@property (nonatomic,weak) id<LiveNaviBarProtocol> naviBarDelegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
