//
//  AuctionCommodityRollTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ComCarouselView.h"

@interface AuctionCommodityRollTableViewCell : BaseTableViewCell
@property (nonatomic,strong) ComCarouselImageView * vCarouselImg;
@property (nonatomic,strong) NSString * bannerUrl;
@property (nonatomic,copy) NSString * countTimeStr;
@end
