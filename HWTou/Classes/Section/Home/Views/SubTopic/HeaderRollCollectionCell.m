//
//  HeaderRollCollectionReusableView.m
//  HWTou
//  头部滚动图
//  Created by robinson on 2017/11/30.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HeaderRollCollectionCell.h"
#import "ComCarouselView.h"
#import "PublicHeader.h"
#import "TopicWorkDetailModel.h"
#import "ComFloorEvent.h"
#import "HomeBannerListModel.h"

@interface HeaderRollCollectionCell()<ComCarouselViewDelegate>
@property (nonatomic,strong) ComCarouselImageView * vCarouselImg; // 图片轮播
@end

@implementation HeaderRollCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.vCarouselImg];
        [self.vCarouselImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(150);
        }];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    NSMutableArray *urlGroup = [NSMutableArray array];
    
    for (HomeBannerListModel * bannerModel in dataArray) {
        if (bannerModel.bannerImg != nil) {
            [urlGroup addObject:bannerModel.bannerImg];
        }
    }
    self.vCarouselImg.imageURLStringsGroup = urlGroup;
}

#pragma mark - ComRollViewDelegate
- (void)carouselView:(ComCarouselView *)view didSelectItemAtIndex:(NSInteger)index
{
    [_cellDelegate carouselviewDidSelectItemAtIndex:index];
}

- (ComCarouselImageView *)vCarouselImg{
    if (!_vCarouselImg) {
        _vCarouselImg = [[ComCarouselImageView alloc] init];
        _vCarouselImg.delegate = self;
    }
    return _vCarouselImg;
}

+ (NSString *)cellIdentity{
    return @"HeaderRollCollectionCell";
}

@end
