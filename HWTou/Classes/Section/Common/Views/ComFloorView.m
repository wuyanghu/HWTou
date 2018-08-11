//
//  ComFloorView.m
//  HWTou
//
//  Created by pengpeng on 17/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ComFloorView.h"
#import "ComFloorCell.h"
#import "PublicHeader.h"
#import "ComFloorDM.h"

@interface FloorFooterView : UICollectionReusableView

@end

@implementation FloorFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromHex(0xf4f4f4);
    }
    return self;
}

@end

@interface FloorHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel  *labTitle;

@end

@implementation FloorHeaderView

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
    self.labTitle = [[UILabel alloc] init];
    self.labTitle.textColor = UIColorFromHex(0x333333);
    self.labTitle.font = FontPFRegular(15.0f);
    self.labTitle.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.labTitle];
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.8);
    }];
}

@end

@interface ComFloorView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, assign) BOOL isTopView;

@end

@implementation ComFloorView

static  NSString * const kCellIdFloorOne = @"CellIdFloorOne";
static  NSString * const kCellIdFloorTwo = @"CellIdFloorTwo";
static  NSString * const kIdFloorHeader  = @"IdFloorHeader";
static  NSString * const kIdFloorFooter  = @"IdFloorFooter";
static  NSString * const kIdFloorTopView = @"IdFloorTopView";

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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.footerReferenceSize = CGSizeMake(kMainScreenWidth, 10);
    flowLayout.minimumLineSpacing = 2.5;
    flowLayout.minimumInteritemSpacing = 2.5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[FloorOneCell class] forCellWithReuseIdentifier:kCellIdFloorOne];
    [self.collectionView registerClass:[FloorTwoCell class] forCellWithReuseIdentifier:kCellIdFloorTwo];
    [self.collectionView registerClass:[FloorHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kIdFloorHeader];
    [self.collectionView registerClass:[FloorFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:kIdFloorFooter];
    
    [self addSubview:self.collectionView];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setDataSource:(id<FloorViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if ([self.dataSource respondsToSelector:@selector(floorViewTopRegisterClass:)]) {
        Class class = [self.dataSource floorViewTopRegisterClass:self];
        self.isTopView = YES;
        [self.collectionView registerClass:class
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:kIdFloorTopView];
    }
}

- (void)setListData:(NSArray<FloorListDM *> *)listData
{
    _listData = listData;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.listData.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    FloorListDM *fList = self.listData[section - 1];
    return fList.floor_info.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(0, 10, 8, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FloorListDM *fList = self.listData[indexPath.section - 1];
    FloorInfoDM *fInfo = fList.floor_info[indexPath.row];
    ComFloorCell *cell = nil;
    if (fInfo.type == 2) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdFloorTwo forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdFloorOne forIndexPath:indexPath];
    }
    [cell setFloorData:fInfo.floor_data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CGSize size = CGSizeZero;
        if ([self.dataSource respondsToSelector:@selector(floorViewTopSize:)]) {
            size = [self.dataSource floorViewTopSize:self];
        }
        return size;
    }
    
    return CGSizeMake(kMainScreenWidth, CoordXSizeScale(50));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *vReusable = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            if (self.isTopView) {
                vReusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                              withReuseIdentifier:kIdFloorTopView forIndexPath:indexPath];
                if ([self.delegate respondsToSelector:@selector(floorView:topReusableView:)]) {
                    [self.delegate floorView:self topReusableView:vReusable];
                }
            }
        } else {
            FloorHeaderView *vHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:kIdFloorHeader forIndexPath:indexPath];
            FloorListDM *fList = self.listData[indexPath.section - 1];
            vHeader.labTitle.text = fList.title;
            vReusable = vHeader;;
        }
        
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        vReusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                      withReuseIdentifier:kIdFloorFooter forIndexPath:indexPath];
    }
    return vReusable;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(floorScrollViewDidScroll:)]) {
        [self.delegate floorScrollViewDidScroll:scrollView];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FloorListDM *fList = self.listData[indexPath.section - 1];
    FloorInfoDM *fInfo = fList.floor_info[indexPath.row];
    
    CGFloat width = kMainScreenWidth * 0.94;
    if (fInfo.type == 2) {
        return CGSizeMake(width, width * 0.4);
    } else {
        return CGSizeMake(width, width * 0.36);
    }
}

- (void)reloadFloorData
{
    [self.collectionView reloadData];
}

@end
