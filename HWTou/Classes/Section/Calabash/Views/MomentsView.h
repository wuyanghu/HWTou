//
//  MomentsView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PublicHeader.h"

@protocol MomentsViewDelegate<NSObject>

- (void)onShareMoments;

@end

@interface MomentsView : UIView

@property (nonatomic, weak) id<MomentsViewDelegate> m_Delegate;

- (void)accessDataSourceWithLoadDataType:(LoadDataType)type withPage:(NSInteger)page
                            withpageSize:(NSInteger)pageSize;

@end
