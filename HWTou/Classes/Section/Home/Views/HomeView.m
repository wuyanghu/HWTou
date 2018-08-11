//
//  HomeView.m
//  HWTou
//
//  Created by pengpeng on 17/3/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeHeaderView.h"
#import "PublicHeader.h"
#import "ComFloorView.h"
#import "HomeNoticeDM.h"
#import "BannerAdDM.h"
#import "HomeView.h"

@interface HomeView () <FloorViewDataSource, FloorViewDelegate>

@property (nonatomic, strong) ComFloorView *vFloor;
@property (nonatomic, strong) HomeHeaderView *vHeader;

@end

@implementation HomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.vFloor = [[ComFloorView alloc] init];
    self.vFloor.dataSource = self;
    self.vFloor.delegate = self;
    
    [self addSubview:self.vFloor];
    [self.vFloor makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - FloorViewDataSource & FloorViewDelegate
- (Class)floorViewTopRegisterClass:(ComFloorView *)floorView
{
    return [HomeHeaderView class];
}

- (CGSize)floorViewTopSize:(ComFloorView *)floorView
{
    CGFloat bannerH = kMainScreenWidth * kScale_9_16 + 30;
    CGFloat funH = kMainScreenWidth * 0.54;
    CGFloat headH = bannerH + 10 + funH;
    return CGSizeMake(kMainScreenWidth, headH);
}

- (void)floorView:(ComFloorView *)floorView topReusableView:(UICollectionReusableView *)topView
{
    self.vHeader = (HomeHeaderView *)topView;
    self.vHeader.banners = self.banners;
    self.vHeader.delegate = self.delegate;
    self.vHeader.notices = self.notices;
    self.vHeader.config = self.config;
}

- (void)floorScrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(homeScrollViewDidScroll:)]) {
        [self.delegate homeScrollViewDidScroll:scrollView];
    }
}

#pragma mark - Setter Method
- (void)setFloors:(NSArray<FloorListDM *> *)floors
{
    _floors = floors;
    _vFloor.listData = floors;
}

- (void)setBanners:(NSArray<BannerAdDM *> *)banners
{
    _banners = banners;
    self.vHeader.banners = banners;
}

- (void)setNotices:(NSArray<HomeNoticeDM *> *)notices
{
    _notices = notices;
    self.vHeader.notices = notices;
}

- (void)setConfig:(NSArray<HomeConfigDM *> *)config
{
    _config = config;
    self.vHeader.config = config;
}

- (void)setDelegate:(id<HomeViewDelegate>)delegate
{
    _delegate = delegate;
    self.vHeader.delegate = delegate;
}

- (UICollectionView *)collectionView
{
    return self.vFloor.collectionView;
}
@end
