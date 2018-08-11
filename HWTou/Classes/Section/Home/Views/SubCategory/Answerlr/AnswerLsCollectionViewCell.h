//
//  AnswerLsCollectionViewCell.h
//  HWTou
//
//  Created by robinson on 2018/1/29.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "GetSpecListModel.h"

@protocol AnswerLsCollectionViewCellDelegate
- (void)buttonAction:(GetSpecListModel *)specListModel;
@end

@interface AnswerLsCollectionViewCell : BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,weak) id<AnswerLsCollectionViewCellDelegate> cellDeleagte;
@end
