//
//  ShopView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCategoryViewController.h"
#import "ProductListViewController.h"
#import "ProductCategoryDM.h"
#import "ShopCategoryCell.h"
#import "ComCarouselView.h"
#import "ComFloorEvent.h"
#import "ComFloorView.h"
#import "PublicHeader.h"
#import "BannerAdDM.h"
#import "ShopView.h"


@protocol ShopHeaderViewDelegate <NSObject>

@optional
// 更多分类事件
- (void)onMoreCategory;

@end

@interface ShopHeaderView : UICollectionReusableView <ComCarouselViewDelegate,
                            UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    ComCarouselImageView    *_vComBanner;   // 横幅广告
    UICollectionView        *_clvCategory;  // 分类入口
}

@property (nonatomic, weak) id<ShopHeaderViewDelegate> delegate;
@property (nonatomic, copy) NSArray<BannerAdDM *> *banners;
@property (nonatomic, copy) NSArray<ProductCategoryList *> *categorys;

@end

@implementation ShopHeaderView

static  NSString * const kCellIdentifier = @"CellIdentifier";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = UIColorFromHex(0xf4f4f4);
    
    _vComBanner = [[ComCarouselImageView alloc] init];
    _vComBanner.delegate = self;
    [self addSubview:_vComBanner];
    
    [_vComBanner makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(_vComBanner.width).multipliedBy(0.5);
    }];
    
    CGFloat itemW = CoordXSizeScale(32);
    CGFloat itemH = CoordXSizeScale(50); // 图标高度 + 图标与标题间距 + 标题高度
    CGFloat lrEdge = CoordXSizeScale(35); // 左右边距
    CGFloat tbEdge = CoordXSizeScale(20); // 上下边距
    CGFloat itemSpace = (kMainScreenWidth - itemW * 4 - lrEdge * 2) / 3;
    CGFloat lineSpace = (CoordXSizeScale(160) - itemH * 2 - tbEdge * 2);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    flowLayout.minimumInteritemSpacing = itemSpace;
    flowLayout.minimumLineSpacing = lineSpace;
    flowLayout.sectionInset = UIEdgeInsetsMake(tbEdge, lrEdge, tbEdge, lrEdge);
    
    _clvCategory = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _clvCategory.backgroundColor = [UIColor whiteColor];
    _clvCategory.showsVerticalScrollIndicator = NO;
    _clvCategory.delegate = self;
    _clvCategory.dataSource = self;
    
    [_clvCategory registerClass:[ShopCategoryCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    [self addSubview:_clvCategory];
    
    [_clvCategory makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(_vComBanner.bottom);
    }];
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

- (void)setCategorys:(NSArray<ProductCategoryList *> *)categorys
{
    _categorys = categorys;
    if (categorys.count > 8) {
        NSMutableArray *newCategorys = [NSMutableArray arrayWithCapacity:8];
        NSArray *subArray = [categorys subarrayWithRange:NSMakeRange(0, 7)];
        [newCategorys addObjectsFromArray:subArray];
        
        ProductCategoryList *more = [[ProductCategoryList alloc] init];
        more.mcid = -1;
        more.name = @"更多";
        
        [newCategorys addObject:more];
        _categorys = newCategorys;
    }
    [_clvCategory reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categorys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell setCategory:self.categorys[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCategoryList *category = self.categorys[indexPath.row];
    if (category.mcid == -1) {
        if ([self.delegate respondsToSelector:@selector(onMoreCategory)]) {
            [self.delegate onMoreCategory];
        }
    } else {
        ProductListViewController *listVC = [[ProductListViewController alloc] init];
        listVC.category = self.categorys[indexPath.row];
        [[UIApplication topViewController].navigationController pushViewController:listVC animated:YES];
    }
}

#pragma mark - ComCarouselViewDelegate
- (void)carouselView:(ComCarouselView *)view didSelectItemAtIndex:(NSInteger)index
{
    BannerAdDM *banner = [self.banners objectAtIndex:index];
    [ComFloorEvent handleEventWithFloor:banner];
}

@end

@interface ShopView () <FloorViewDataSource, FloorViewDelegate, ShopHeaderViewDelegate>

@property (nonatomic, strong) ComFloorView *vFloor;
@property (nonatomic, strong) ShopHeaderView *vHeader;

@end

@implementation ShopView

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

- (void)setBanners:(NSArray<BannerAdDM *> *)banners
{
    _banners = banners;
    self.vHeader.banners = banners;
}

- (void)setCategorys:(NSArray<ProductCategoryList *> *)categorys
{
    _categorys = categorys;
    self.vHeader.categorys = categorys;
    [self.vFloor reloadFloorData];
}

- (void)setFloors:(NSArray<FloorListDM *> *)floors
{
    _floors = floors;
    self.vFloor.listData = floors;
}

- (UICollectionView *)collectionView
{
    return self.vFloor.collectionView;
}

#pragma mark - FloorViewDataSource & FloorViewDelegate
- (Class)floorViewTopRegisterClass:(ComFloorView *)floorView
{
    return [ShopHeaderView class];
}

- (CGSize)floorViewTopSize:(ComFloorView *)floorView
{
    CGFloat bannerH = kMainScreenWidth * 0.5;
    CGFloat headH = bannerH + self.heightCategory;
    return CGSizeMake(kMainScreenWidth, headH);
}

- (void)floorView:(ComFloorView *)floorView topReusableView:(UICollectionReusableView *)topView
{
    self.vHeader = (ShopHeaderView *)topView;
    self.vHeader.delegate = self;
    self.vHeader.banners = self.banners;
    self.vHeader.categorys = self.categorys;
}

- (void)onMoreCategory
{
    ProductCategoryViewController *vc = [[ProductCategoryViewController alloc] init];
    [vc setCategorys:self.categorys];
    [[UIApplication topViewController].navigationController pushViewController:vc animated:YES];
}

- (CGFloat)heightCategory
{
    if (self.categorys.count == 0) {
        return 0;
    }
    
    if (self.categorys.count > 4) {
        return CoordXSizeScale(160);
    }
    return CoordXSizeScale(90);
}

@end

