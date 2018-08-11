//
//  RotView.m
//  HWTou
//
//  Created by robinson on 2017/11/17.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RotView.h"
#import "PublicHeader.h"
#import "ComCarouselView.h"
#import "PersonEditDataView.h"//暂用，删除
#import "HeaderRollCollectionCell.h"
#import "RotCollectionCell.h"
#import "TopicFooterCollectionReusableView.h"

#define kRotCollectCellIdentify @"kRotCollectCellIdentify"
#define kCarouselCellIdentify @"kCarouselCellIdentify"
#define kRotCollectHorizontalCellIdentify @"RotCollectHorizontalCellIdentify"
#define kHeaderViewIdentify @"HeaderView"
#define kFooterViewIdentify @"FooterView"
#define kFooterViewIdentify1 @"kFooterViewIdentify1"

@interface RotView()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,RotButtonSelectedDelegate,HeaderRollCollectionCellDelegate>

@end

@implementation RotView

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
    [_rotViewDelegate loadHeaderData];
}

- (void)loadFooterData{
    [_rotViewDelegate loadFooterData];
}

- (void)refreshData{
    [self.collectionView reloadData];
}

#pragma mark - HeaderRollCollectionCellDelegate
- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index{
    [_rotViewDelegate carouselviewDidSelectItemAtIndex:index];
}

#pragma mark - ButtonSelectedDelegate
- (void)buttonSelected:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    [_rotViewDelegate buttonSelected:button indexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2+self.viewModel.hotRecListArray.count+1;//banner+猜你喜欢+热门推荐(不确定)+最新推荐
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
//        return self.viewModel.likeArray.count;
        return 0;
    }else if(section<2+self.viewModel.hotRecListArray.count){
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[section-2];
        return recListModel.rtcDetailArr.count;
    }else{
        return self.viewModel.hotNewRecListArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HeaderRollCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCarouselCellIdentify forIndexPath:indexPath];
        cell.cellDelegate = self;
        [cell setDataArray:self.bannerListViewModel.dataArray];
        return cell;
    }else if (indexPath.section == 1) {
        RotCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRotCollectCellIdentify forIndexPath:indexPath];
        [cell setLikeModel:self.viewModel.likeArray[indexPath.row]];
        return cell;
    }else if(indexPath.section<2+self.viewModel.hotRecListArray.count){
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
        if (recListModel.layoutType == 1) {//横排
            RotCollectHorizontalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRotCollectHorizontalCellIdentify forIndexPath:indexPath];
            [cell.listView setLikeModel:recListModel.rtcDetailArr[indexPath.row] isShowLine:recListModel.rtcDetailArr.count == indexPath.row+1];
            return cell;
        }else{//竖排
            RotCollectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRotCollectCellIdentify forIndexPath:indexPath];
            [cell setLikeModel:recListModel.rtcDetailArr[indexPath.row]];
            return cell;
        }
    }else{
        RotCollectHorizontalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRotCollectHorizontalCellIdentify forIndexPath:indexPath];
        [cell.listView setLikeModel:self.viewModel.hotNewRecListArray[indexPath.row] isShowLine:self.viewModel.hotNewRecListArray.count == indexPath.row+1];
        return cell;
    }
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
            
        }else if (indexPath.section == 1) {
//            title = @"猜你喜欢";
        }else if (indexPath.section<2+self.viewModel.hotRecListArray.count){
            GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
            title = recListModel.title;
        }else{
            title = @"最新主播";
        }
        
        [header setTitleLabelText:title];
        reusableView = header;
    }
    if (kind == UICollectionElementKindSectionFooter){
        if (indexPath.section == 0) {
            TopicFooterCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify1 forIndexPath:indexPath];
            reusableView = footerview;
        }else{
            RotCollectFooterView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify forIndexPath:indexPath];
            footerview.btnDelegate = self;
            footerview.indexPath = indexPath;
            reusableView = footerview;
        }
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_rotViewDelegate didSelectItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

//每个item之间的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//每个item之间的纵向的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsZero;
    }else if (section==1) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }else if (section<2+self.viewModel.hotRecListArray.count) {
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[section-2];
        if (recListModel.layoutType == 1) {//横排
            return UIEdgeInsetsMake(10, 0, 10, 0);
        }else{
            return UIEdgeInsetsMake(10, 10, 10, 10);
        }
        
    }else{
        return UIEdgeInsetsMake(10, 0, 10, 0);
    }
}

//设置每个单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(kMainScreenWidth, 150);
    }else if (indexPath.section==1){
        CGFloat itemWidth = (kMainScreenWidth-10*4)/3;
        return CGSizeMake(itemWidth, 165);
    }else if (indexPath.section<2+self.viewModel.hotRecListArray.count){
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
        if (recListModel.layoutType == 1) {//横排
            return CGSizeMake(kMainScreenWidth, 90);
        }else{
            CGFloat itemWidth = (kMainScreenWidth-10*4)/3;
            return CGSizeMake(itemWidth, 165);
        }
    }else{
        return CGSizeMake(kMainScreenWidth, 90);
    }
}

//头部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return CGSizeZero;
    }
    return CGSizeMake(kMainScreenWidth, 50);
}

//尾部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(kMainScreenWidth, 10);
    }
    if (section == 1 || section == 2+self.viewModel.hotRecListArray.count) {
        return CGSizeZero;
    }
    return CGSizeMake(kMainScreenWidth, 50);;
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
        [_collectionView registerClass:[RotCollectCell class] forCellWithReuseIdentifier:kRotCollectCellIdentify];
        [_collectionView registerClass:[RotCollectHorizontalCell class] forCellWithReuseIdentifier:kRotCollectHorizontalCellIdentify];
        [_collectionView registerClass:[HeaderRollCollectionCell class] forCellWithReuseIdentifier:kCarouselCellIdentify];
        [_collectionView registerClass:[RotCollectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify];
        [_collectionView registerClass:[RotCollectFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify];
        [_collectionView registerClass:[TopicFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify1];

        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadHeaderData];
        }];
        
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadFooterData];
        }];
    }
    return _collectionView;
}

@end

