//
//  HomeMoneyIsComingCollectionViewCell.h
//  HWTou
//
//  Created by robinson on 2018/1/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "PlayerDetailViewModel.h"

@interface HomeMoneyIsComingCollectionViewCell : BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *browseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic,strong) PlayerDetailViewModel * detailVM;
@end
