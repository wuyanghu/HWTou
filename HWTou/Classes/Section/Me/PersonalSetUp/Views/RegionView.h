//
//  RegionView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RegionRequest.h"

@protocol RegionViewDelegate <NSObject>

- (void)onAreaSelection:(NSDictionary *)dic withType:(RegionType)type;

@end

@interface RegionView : UIView

@property (nonatomic, weak) id<RegionViewDelegate> m_Delegate;

- (void)accessDataSourceWithType:(RegionType)type withDataSource:(NSDictionary *)dic;

@end
