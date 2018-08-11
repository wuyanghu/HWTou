//
//  AuctionCommodityRollTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionCommodityRollTableViewCell.h"
#import "PublicHeader.h"

@interface AuctionCommodityRollTableViewCell()
{
    UILabel * countLabel;
}
@end

@implementation AuctionCommodityRollTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.vCarouselImg];
    [self.vCarouselImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColorFromRGB(0x000000);
    bgView.alpha = 0.2;
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.left.equalTo(self);
        make.height.equalTo(42);
        make.bottom.equalTo(self.mas_bottom).offset(-62);
    }];
    
    countLabel = [BasisUITool getLabelWithTextColor:[UIColor whiteColor] size:12];
    [bgView addSubview:countLabel];
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(12);
        make.left.equalTo(bgView).offset(10);
        make.top.equalTo(bgView).offset(11);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBannerUrl:(NSString *)bannerUrl{
    _bannerUrl = bannerUrl;
    NSArray * dataArray = [bannerUrl componentsSeparatedByString:@","];
    NSMutableArray *urlGroup = [NSMutableArray array];
    
    for (NSString * urlString in dataArray) {
        [urlGroup addObject:urlString];
    }
    self.vCarouselImg.imageURLStringsGroup = urlGroup;
}

- (void)setCountTimeStr:(NSString *)countTimeStr{
    countLabel.text = countTimeStr;
}

#pragma mark - getter
- (ComCarouselImageView *)vCarouselImg{
    if (!_vCarouselImg) {
        _vCarouselImg = [[ComCarouselImageView alloc] init];
    }
    return _vCarouselImg;
}

#pragma mark - static
+ (NSString *)cellReuseIdentifierInfo{
    return @"AuctionCommodityRollTableViewCell";
}

@end
