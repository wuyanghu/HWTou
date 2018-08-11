//
//  ActivityView.m
//  HWTou
//
//  Created by mac on 2017/3/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "LWLCollectionViewHorizontalLayout.h"
#import <SDCycleScrollView/TAPageControl.h>
#import "ActivityDetailViewController.h"
#import "ActivityContentView.h"
#import "ActivityContentCell.h"
#import "ProductCategoryDM.h"
#import "ShopCategoryCell.h"
#import "ComCarouselView.h"
#import "ActivityNewsDM.h"
#import "ComFloorEvent.h"
#import "PublicHeader.h"
#import "BannerAdDM.h"

@interface ActivityContentView () <UITableViewDataSource, UITableViewDelegate,
UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, ComCarouselViewDelegate>
{
    UICollectionView        *_clvCategory;  // 分类入口
}

@property (nonatomic, strong) ComCarouselImageView *vComBanner;
@property (nonatomic, strong) TAPageControl *pageControl;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UIView        *headerView;
@property (nonatomic, copy)   NSArray       *listCategorys;

@end

@implementation ActivityContentView

static NSInteger const kCategoryMaxCount = 16;
static NSString * const kCellIdentifier = @"CellIdentifier";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self setupHeaderView];
    }
    return self;
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.rowHeight = 0.4 * kMainScreenWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ActivityContentCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setupHeaderView
{
    self.headerView = [[UIView alloc] init];
    
    _vComBanner = [[ComCarouselImageView alloc] init];
    _vComBanner.delegate = self;
    [self.headerView addSubview:_vComBanner];
    
    [_vComBanner makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(_vComBanner.width).multipliedBy(0.5);
    }];
    
    CGFloat itemW = CoordXSizeScale(32);
    CGFloat itemH = CoordXSizeScale(50);  // 图标高度 + 图标与标题间距 + 标题高度
    CGFloat lrEdge = CoordXSizeScale(35); // 左右边距
    CGFloat tbEdge = CoordXSizeScale(20); // 上下边距
    CGFloat lineSpace = (kMainScreenWidth - itemW * 4 - lrEdge * 2) / 3;
    CGFloat fItemSpace = (CoordXSizeScale(160) - itemH * 2 - tbEdge * 2);
    NSInteger itemSpace = floorf(fItemSpace);
    
    LWLCollectionViewHorizontalLayout *flowLayout = [[LWLCollectionViewHorizontalLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    flowLayout.minimumInteritemSpacing = itemSpace;
    flowLayout.minimumLineSpacing = lineSpace;
    flowLayout.sectionInset = UIEdgeInsetsMake(tbEdge, lrEdge, tbEdge, lrEdge);
    
    _clvCategory = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _clvCategory.backgroundColor = [UIColor whiteColor];
    _clvCategory.showsHorizontalScrollIndicator = NO;
    _clvCategory.showsVerticalScrollIndicator = NO;
    _clvCategory.pagingEnabled = YES;
    _clvCategory.delegate = self;
    _clvCategory.dataSource = self;
    
    [_clvCategory registerClass:[ShopCategoryCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    [self.headerView addSubview:_clvCategory];
    
    [_clvCategory makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.headerView);
        make.bottom.equalTo(self.headerView).offset(-10);
        make.top.equalTo(_vComBanner.bottom);
    }];
}

- (void)setCategorys:(NSArray<ActivityCategoryDM *> *)categorys
{
    _categorys = categorys;
    if (categorys.count > kCategoryMaxCount) {
        NSMutableArray *newCategorys = [NSMutableArray arrayWithCapacity:kCategoryMaxCount];
        NSArray *subArray = [categorys subarrayWithRange:NSMakeRange(0, kCategoryMaxCount - 1)];
        [newCategorys addObjectsFromArray:subArray];
        
        ActivityCategoryDM *more = [[ActivityCategoryDM alloc] init];
        more.ncid = -1;
        more.name = @"更多";
        
        [newCategorys addObject:more];
        _categorys = newCategorys;
    }
    [_clvCategory reloadData];
    [self setupPageControl];
}

- (void)setupPageControl
{
    NSInteger numberOfPages = self.categorys.count / 8;
    if (self.categorys.count % 8) {
        numberOfPages += 1;
    }
    if (numberOfPages <= 1) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
        return;
    }
    
    if (self.pageControl == nil) {
        TAPageControl *pageControl = [[TAPageControl alloc] init];
        
        // 不添加到backgroundView的话，滑动时会跟着偏移
        _clvCategory.backgroundView = [[UIView alloc] init];
        [_clvCategory.backgroundView addSubview:pageControl];
        
        pageControl.frame = CGRectMake((kMainScreenWidth - 22) * 0.5,  CoordXSizeScale(160) - 7 - 5, 22, 7);
        pageControl.dotImage = [UIImage imageNamed:@"com_banner_dot_nor"];
        pageControl.currentDotImage = [UIImage imageNamed:@"com_banner_dot_sel"];
        self.pageControl = pageControl;
    }
    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.currentPage = 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.pageControl && [scrollView isKindOfClass:[UICollectionView class]]) {
        int pageNo = 0;
        if (scrollView.contentOffset.x > 0) {
            pageNo = (scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame)) + 1;
        }
        if (self.pageControl.numberOfPages > pageNo) {
            self.pageControl.currentPage = pageNo;
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.categorys.count > 8) {
        return kCategoryMaxCount;
    }
    return self.categorys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.categorys.count) {
        [cell setActCategory:self.categorys[indexPath.row]];
    } else {
        [cell setActCategory:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.categorys.count) {
        return;
    }
    ActivityCategoryDM *category = self.categorys[indexPath.row];
    NSInteger row = indexPath.row;
    if (category.ncid == -1) {
        row = 0;
    }
    if ([self.delegate respondsToSelector:@selector(onSelectCategoryAtIndex:)]) {
        [self.delegate onSelectCategoryAtIndex:row];
    }
}

- (void)setListData:(NSArray *)listData
{
    _listData = listData;
    [self.tableView reloadData];
}

- (void)setBanners:(NSArray<BannerAdDM *> *)banners
{
    _banners = banners;
    
    NSMutableArray *urlGroup = [NSMutableArray arrayWithCapacity:banners.count];
    [banners enumerateObjectsUsingBlock:^(BannerAdDM *obj, NSUInteger idx, BOOL *stop) {
        [urlGroup addObject:obj.img_url];
    }];
    _vComBanner.imageURLStringsGroup = urlGroup;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kMainScreenWidth * 0.5 + self.heightCategory + 10;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setDmNews:self.listData[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc] init];
    detailVC.dmNews = self.listData[indexPath.section];
    detailVC.type = ActivityDetailNews;
    [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - ComCarouselViewDelegate
- (void)carouselView:(ComCarouselView *)view didSelectItemAtIndex:(NSInteger)index
{
    BannerAdDM *banner = [self.banners objectAtIndex:index];
    [ComFloorEvent handleEventWithFloor:banner];
}

- (CGFloat)heightCategory
{
    if (self.categorys.count == 0) {
        return 0;
    }
    return CoordXSizeScale(160);
}
@end
