//
//  HomeMoneyIsComingView.m
//  HWTou
//
//  Created by robinson on 2017/11/17.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeMoneyIsComingView.h"
#import "PublicHeader.h"
#import "ComCarouselView.h"
#import "HeaderRollCollectionCell.h"
#import "RotCollectionCell.h"
#import "HomeMonryIsComingFooterCollectionReusableView.h"
#import "HomeMoneyIsComingCollectionViewCell.h"

#define kRotCollectCellIdentify @"kRotCollectCellIdentify"
#define kCarouselCellIdentify @"kCarouselCellIdentify"
#define kRotCollectHorizontalCellIdentify @"RotCollectHorizontalCellIdentify"
#define kHeaderViewIdentify @"HeaderView"
#define kFooterViewIdentify @"FooterView"

@interface HomeMoneyIsComingView()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,RotButtonSelectedDelegate,HeaderRollCollectionCellDelegate>

@end

@implementation HomeMoneyIsComingView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView{
    self.backgroundColor = UIColorFromHex(0xF3F4F6);
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - 刷新数据

//刷新数据
- (void)loadHeaderData{
    [_HomeMoneyIsComingViewDelegate loadHeaderData];
}

- (void)loadFooterData{
    [_HomeMoneyIsComingViewDelegate loadFooterData];
}

- (void)refreshData{
    [self.collectionView reloadData];
}

#pragma mark - HeaderRollCollectionCellDelegate
- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index{
    [_HomeMoneyIsComingViewDelegate carouselviewDidSelectItemAtIndex:index];
}

#pragma mark - ButtonSelectedDelegate
- (void)buttonSelected:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    [_HomeMoneyIsComingViewDelegate buttonSelected:button indexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.viewModel getSection];//banner+热门推荐(不确定)
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if(section<[self.viewModel getSection]){
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[section-2];
        return recListModel.rtcDetailArr.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HeaderRollCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCarouselCellIdentify forIndexPath:indexPath];
        cell.cellDelegate = self;
        [cell setDataArray:self.bannerListViewModel.dataArray];
        return cell;
    }else if (indexPath.section == 1){
        HomeMoneyIsComingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HomeMoneyIsComingCollectionViewCell cellIdentity] forIndexPath:indexPath];
        [cell setDetailVM:_detailVM];
        return cell;
    }else if (indexPath.section<[self.viewModel getSection]){
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
        RotCollectHorizontalCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRotCollectHorizontalCellIdentify forIndexPath:indexPath];
        [cell.listView setLikeModel:recListModel.rtcDetailArr[indexPath.row] isShowLine:recListModel.rtcDetailArr.count == indexPath.row+1];
        return cell;
    }
    return nil;
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        RotCollectHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify forIndexPath:indexPath];
        header.rotBtnDelegate = self;
        header.indexPath = indexPath;
        
        NSString * title = @"";
        if (indexPath.section == 0) {
            
        }else if (indexPath.section == 1){
            title = @"今日钱潮";
        }else if (indexPath.section<[self.viewModel getSection]){
            GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
            title = recListModel.title;
        }else{
            title = @"";
        }
        
        [header setTitleLabelText:title];
        if (indexPath.section>1 && indexPath.section<[self.viewModel getSection]){
            GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
            if (recListModel.recNum>3) {
                header.moreBtn.hidden = NO;
            }else{
                header.moreBtn.hidden = YES;
            }
            
        }
        reusableView = header;
    }
    if (kind == UICollectionElementKindSectionFooter){
        HomeMonryIsComingFooterCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify forIndexPath:indexPath];
        reusableView = footerview;
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_HomeMoneyIsComingViewDelegate didSelectItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return UIEdgeInsetsZero;
    }else if (section<[self.viewModel getSection]) {
        return UIEdgeInsetsMake(10, 0, 10, 0);
        
    }
    return UIEdgeInsetsZero;
}

//设置每个单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(kMainScreenWidth, 150);
    }else if (indexPath.section == 1){
        return CGSizeMake(kMainScreenWidth, 180);
    }else if (indexPath.section<[self.viewModel getSection]){
        return CGSizeMake(kMainScreenWidth, 90);
    }
    return CGSizeZero;
}

//头部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(kMainScreenWidth, 50);
}

//尾部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kMainScreenWidth, 10);
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[RotCollectHorizontalCell class] forCellWithReuseIdentifier:kRotCollectHorizontalCellIdentify];
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeMoneyIsComingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:[HomeMoneyIsComingCollectionViewCell cellIdentity]];
        [_collectionView registerClass:[RotCollectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify];
        [_collectionView registerClass:[HeaderRollCollectionCell class] forCellWithReuseIdentifier:kCarouselCellIdentify];
        [_collectionView registerClass:[HomeMonryIsComingFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadHeaderData];
        }];
        
//        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            [self loadFooterData];
//        }];
    }
    return _collectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

