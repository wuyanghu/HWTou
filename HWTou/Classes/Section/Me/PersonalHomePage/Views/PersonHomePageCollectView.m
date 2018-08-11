//
//  PersonHomePageCollectView.m
//  HWTou
//
//  Created by robinson on 2017/12/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonHomePageCollectView.h"
#import "PublicHeader.h"
#import "PersonHomePageView.h"

#define kCellIdentify0 @"kCellIdentify0"
#define kCellIdentify1 @"kCellIdentify1"
#define kCellIdentify2 @"kCellIdentify2"
#define kCellIdentify3 @"kCellIdentify3"
#define kHeaderViewIdentify @"HeaderView"
#define kFooterViewIdentify @"FooterView"
#define kFooterViewIdentify1 @"FooterView1"

@interface PersonHomePageCollectView()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView  *collectionView;
@end

@implementation PersonHomePageCollectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
//    else if (section == 1){
//        return _hotTopicListArr.count;
//    }else if (section == 2){
//        return _titleArray.count;
//    }else if (section == 3){
//        return _todayTopicListArr.count;
//    }
    return 1;
}
//设置cell高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(kMainScreenWidth, 150);
    }else if (indexPath.section == 1){
        CGFloat itemWidth = (kMainScreenWidth-8*4)/3;
        return CGSizeMake(itemWidth, itemWidth*1.5);
    }else if (indexPath.section == 2){
        CGFloat itemWidth = (kMainScreenWidth)/5;
        return CGSizeMake(itemWidth, 54);
    }else if (indexPath.section == 3){
        return CGSizeMake(kMainScreenWidth, 100);
    }else{
        return CGSizeZero;
    }
}
//头部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return CGSizeMake(kMainScreenWidth, 50);
    }
    return CGSizeZero;
}

//尾部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return CGSizeMake(kMainScreenWidth, 10);
    }
    return CGSizeZero;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 2.5;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 2.5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PersonHomePageView * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify0 forIndexPath:indexPath];
        [cell setPersonHomeModel:_personHomeModel];
        return cell;
    }
//    else if (indexPath.section == 1) {
//        RotCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify1 forIndexPath:indexPath];
//        [cell setTopicListModel:self.hotTopicListArr[indexPath.row]];
//        return cell;
//    }else if (indexPath.section == 2){
//        TopicTitleCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify2 forIndexPath:indexPath];
//        [cell setSelectBgColor:_selectedTopicLabelIndex == indexPath.row?YES:NO];
//        [cell setLabelListModel:self.titleArray[indexPath.row]];
//        return cell;
//    }else if (indexPath.section == 3){
//        TopicTitleListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify3 forIndexPath:indexPath];
//        [cell.topicTitleListView setTopicListModel:self.todayTopicListArr[indexPath.row]];
//        return cell;
//    }else{
        return nil;
//    }
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
//    if (kind == UICollectionElementKindSectionHeader) {
//        if (indexPath.section == 1) {
//            RotCollectHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify forIndexPath:indexPath];
//            header.btnDelegate = self;
//            [header setTitleLabelText:@"热门推荐"];
//            reusableView = header;
//        }else{
//            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify forIndexPath:indexPath];
//        }
//    }
//    if (kind == UICollectionElementKindSectionFooter){
//        if (indexPath.section == 0 || indexPath.section == 1) {
//            RotCollectFooterView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify1 forIndexPath:indexPath];
//            reusableView = footerview;
//        }else{
//            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify forIndexPath:indexPath];
//        }
//    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1) {
//        [_topicViewDelegate selectedTopicListModel:self.hotTopicListArr[indexPath.row]];
//    }else if (indexPath.section == 2) {
//        TopicTitleCollectionCell *cell =  (TopicTitleCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        [_topicViewDelegate selecedLabelTopic:cell.labelListModel dispatchGroup:nil];
//        
//        _selectedTopicLabelIndex = indexPath.row;
//        [collectionView reloadData];
//    }
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 2) {
//        TopicTitleCollectionCell *cell =  (TopicTitleCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        [cell setSelectBgColor:NO];
//    }
//}
#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 2) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeMake(kMainScreenWidth, 0);
        //        flowLayout.estimatedItemSize = CGSizeMake(kMainScreenWidth, 100);
        flowLayout.footerReferenceSize = CGSizeMake(kMainScreenWidth, 0);
        flowLayout.minimumLineSpacing = 2.5;
        flowLayout.minimumInteritemSpacing = 2.5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PersonHomePageCollectView class] forCellWithReuseIdentifier:kCellIdentify0];
//        [_collectionView registerClass:[RotCollectCell class] forCellWithReuseIdentifier:kCellIdentify1];
//        [_collectionView registerClass:[TopicTitleCollectionCell class] forCellWithReuseIdentifier:kCellIdentify2];
//        [_collectionView registerClass:[TopicTitleListCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentify3];
//
//        [_collectionView registerClass:[RotCollectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify];
//        [_collectionView registerClass:[RotCollectFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify1];
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self loadNewData];
        }];
    }
    return _collectionView;
}


@end
