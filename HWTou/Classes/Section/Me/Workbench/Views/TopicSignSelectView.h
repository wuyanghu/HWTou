//
//  TopicSignSelectView.h
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicLabelListModel;

@interface TopicSignSelectView : UIView

typedef void (^TopicSelectBlock)(TopicLabelListModel *labelModel);

- (instancetype)initWithLabelListArray:(NSArray *)array;

- (void)show;

@property (nonatomic, copy) TopicSelectBlock selectBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end
