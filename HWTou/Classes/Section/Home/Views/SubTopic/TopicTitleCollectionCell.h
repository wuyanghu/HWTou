//
//  TopicTitleCollectionCell.h
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicWorkDetailModel.h"

@interface TopicTitleCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIView * lineView;

@property (nonatomic,strong) TopicLabelListModel * labelListModel;
- (void)setSelectBgColor:(BOOL)selected;
@end


@interface TopicTitleArrowCell : UICollectionViewCell
@property (nonatomic,strong) UIButton * imgBtn;
@property (nonatomic,weak) id<TopicButtonSelectedDelegate> btnSelectedDelegate;

@end
