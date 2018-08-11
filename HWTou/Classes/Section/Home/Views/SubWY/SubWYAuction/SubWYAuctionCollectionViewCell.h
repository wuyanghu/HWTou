//
//  SubWYAuctionCollectionViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "GetSellerPerformListModel.h"

typedef void(^SubWYAuctionCellBlock)(GetSellerPerformListModel * model);

@interface SubWYAuctionCollectionViewCell : BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray<GetSellerPerformListModel *> * dataArray;
@property (nonatomic,copy) SubWYAuctionCellBlock block;

@property (nonatomic,strong) NSMutableDictionary <NSString *,UIButton *>* btnDict;
@end
