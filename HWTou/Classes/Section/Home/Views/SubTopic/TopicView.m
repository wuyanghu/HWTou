//
//  TopicView.m
//  HWTou
//
//  Created by robinson on 2017/11/17.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicView.h"
#import "PublicHeader.h"
#import "HeaderRollCollectionCell.h"
#import "PersonEditDataView.h"//暂用，删除
#import "RotCollectionCell.h"
#import "TopicTitleCollectionCell.h"
#import "TopicTitleListCollectionViewCell.h"
#import "TopicFooterCollectionReusableView.h"
#import "TopicTitleScrollView.h"

#define kCellIdentify0 @"kCellIdentify0"
#define kCellIdentify1 @"kCellIdentify1"
#define kCellIdentify2 @"kCellIdentify2"
#define kCellIdentify2_1 @"kCellIdentify2_1"
#define kCellIdentify3 @"kCellIdentify3"
#define kHeaderViewIdentify @"HeaderView"
#define kHeaderViewIdentify1 @"HeaderView1"
#define kFooterViewIdentify @"FooterView"
#define kFooterViewIdentify1 @"FooterView1"

@interface TopicView()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,TopicButtonSelectedDelegate,HeaderRollCollectionCellDelegate,TopicTitleScrollViewDelegate>

@property (nonatomic, assign) BOOL isTitleExp;
@property (nonatomic,strong) TopicTitleScrollView * titleSrollView;
@end

@implementation TopicView

- (instancetype)init{
    self = [super init];
    if (self) {
        _selectedTopicLabelIndex = 0;
        [self drawView];
    }
    return self;
}

- (void)drawView{
    self.backgroundColor = UIColorFromHex(0xffffff);
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.titleSrollView];
}

- (void)refreshData{
    [self showArrowData];
    [self.collectionView reloadData];
}
//刷新数据
- (void)loadNewData{
    [_topicViewDelegate loadNewData];
}

- (void)historyData{
    if (_selectedTopicLabelIndex<self.showTitleArray.count) {
        [_topicViewDelegate loadHistoryData:self.showTitleArray[_selectedTopicLabelIndex]];
    }
}

- (void)showArrowData{
    [self.showTitleArray removeAllObjects];
    if (self.titleArray.count>9) {
        //大于10个展示箭头
        for (int i = 0; i<9; i++) {
            [self.showTitleArray addObject:self.titleArray[i]];
        }
    }else{
        [self.showTitleArray addObjectsFromArray:self.titleArray];
    }
    TopicLabelListModel * labelListModel = [TopicLabelListModel new];
    [self.showTitleArray addObject:labelListModel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point=scrollView.contentOffset;
//    NSLog(@"scrollViewDidScroll-%f",point.y);
    //1.根据偏移量判断一下应该显示第几个item
    CGFloat offSetY = point.y;
    NSInteger row = self.showTitleArray.count/5;
    NSInteger count = self.showTitleArray.count%5==0?0:1;
    CGFloat tempOffsetY = 385+44*(row+count)+22;
    if (offSetY>=tempOffsetY) {
//        NSLog(@"显示");
        self.titleSrollView.hidden = NO;
        self.titleSrollView.isTitleExp = self.isTitleExp;
        self.titleSrollView.selectedTopicLabelIndex = _selectedTopicLabelIndex;
        [self.titleSrollView setDataArray:self.titleArray];
        
        [self.titleSrollView setAllDataArray:self.titleArray];
        
    }else{
//        NSLog(@"隐藏");
        self.titleSrollView.hidden = YES;
    }
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.hotTopicListArr.count;
    }else if (section == 2){
        if (self.titleArray.count>9) {
            return self.showTitleArray.count;
        }else{
            if (self.showTitleArray.count > 0) {
                return self.showTitleArray.count-1;
            }
            return 0;
        }
    }else if (section == 3){
        return self.todayTopicListArr.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HeaderRollCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify0 forIndexPath:indexPath];
        cell.cellDelegate = self;
        [cell setDataArray:self.bannerListViewModel.dataArray];
        return cell;
    }else if (indexPath.section == 1) {
        RotCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify1 forIndexPath:indexPath];
        [cell setTopicListModel:self.hotTopicListArr[indexPath.row]];
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == self.showTitleArray.count-1) {
            TopicTitleArrowCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify2_1 forIndexPath:indexPath];
            cell.imgBtn.selected = self.isTitleExp;
            cell.btnSelectedDelegate = self;
            return cell;
        }else{
            TopicTitleCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify2 forIndexPath:indexPath];
            [cell setSelectBgColor:_selectedTopicLabelIndex == indexPath.row?YES:NO];
            [cell setLabelListModel:self.showTitleArray[indexPath.row]];
            return cell;
        }
    }else if (indexPath.section == 3){
        TopicTitleListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify3 forIndexPath:indexPath];
        cell.topicTitleListView.btnSelectedDelegate = self;
        [cell.topicTitleListView setTopicListModel:self.todayTopicListArr[indexPath.row]];
        return cell;
    }else{
        return nil;
    }
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 1) {
            RotCollectHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify forIndexPath:indexPath];
            header.topicBtnDelegate = self;
            [header setTitleLabelText:@"王牌榜单"];
            reusableView = header;
        }else{
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify1 forIndexPath:indexPath];
        }
    }
    if (kind == UICollectionElementKindSectionFooter){
        if (indexPath.section == 0 || indexPath.section == 1) {
            TopicFooterCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify1 forIndexPath:indexPath];
            reusableView = footerview;
        }else{
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify forIndexPath:indexPath];
        }
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [_topicViewDelegate selectedTopicListModel:self.hotTopicListArr[indexPath.row]];
    }else if (indexPath.section == 2) {
        if (indexPath.row == self.showTitleArray.count-1) {
            return;
        }
        [_topicViewDelegate selecedLabelTopic:self.showTitleArray[indexPath.row]];
        _selectedTopicLabelIndex = indexPath.row;
        [collectionView reloadData];
    }else if (indexPath.section == 3){
        [_topicViewDelegate selectedTodayTopicList:self.todayTopicListArr[indexPath.row]];
    }
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
    if (section == 1) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsZero;
}

//设置每个单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(kMainScreenWidth, 150);
    }else if (indexPath.section == 1){
        CGFloat itemWidth = (kMainScreenWidth-10*4)/3;
        return CGSizeMake(itemWidth, 165);
    }else if (indexPath.section == 2){
        CGFloat itemWidth = kMainScreenWidth/5;
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

#pragma mark - HeaderRollCollectionCellDelegate
- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index{
    [_topicViewDelegate carouselviewDidSelectItemAtIndex:index];
}

#pragma mark - TopicTitleScrollViewDelegate
- (void)selectedLabelTopic:(NSInteger)selectedIndex{
    _selectedTopicLabelIndex = selectedIndex;
    [_topicViewDelegate selecedLabelTopic:self.titleArray[_selectedTopicLabelIndex]];
    [self.collectionView reloadData];
}

#pragma mark - ButtonSelectedDelegate

- (void)buttonSelected:(UIButton *)button{
    if (button.tag == arrowsBtnType) {
        if (self.isTitleExp) {
            [self showArrowData];
        }
        else {
            [self.showTitleArray removeAllObjects];
            [self.showTitleArray addObjectsFromArray:self.titleArray];
            TopicLabelListModel * labelListModel = [TopicLabelListModel new];
            [self.showTitleArray addObject:labelListModel];
        }
        self.isTitleExp = !self.isTitleExp;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }else{
        [_btnDelegate buttonSelected:button];
    }
}

#pragma mark - getter

- (TopicTitleScrollView *)titleSrollView{
    if (!_titleSrollView) {
        _titleSrollView = [[TopicTitleScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
        _titleSrollView.hidden = YES;
        _titleSrollView.selectedDelegate = self;
    }
    return _titleSrollView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];

        //布局
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HeaderRollCollectionCell class] forCellWithReuseIdentifier:kCellIdentify0];
        [_collectionView registerClass:[RotCollectCell class] forCellWithReuseIdentifier:kCellIdentify1];
        [_collectionView registerClass:[TopicTitleCollectionCell class] forCellWithReuseIdentifier:kCellIdentify2];
        [_collectionView registerClass:[TopicTitleArrowCell class] forCellWithReuseIdentifier:kCellIdentify2_1];
        [_collectionView registerClass:[TopicTitleListCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentify3];
        
        [_collectionView registerClass:[RotCollectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify1];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify];
        [_collectionView registerClass:[TopicFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify1];
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadNewData];
        }];
        
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self historyData];
        }];
    }
    return _collectionView;
}

- (NSMutableArray *)showTitleArray{
    if (!_showTitleArray) {
        _showTitleArray = [NSMutableArray array];
    }
    return _showTitleArray;
}

- (NSMutableArray *)hotTopicListArr{
    if (!_hotTopicListArr) {
        _hotTopicListArr = [NSMutableArray array];
    }
    return _hotTopicListArr;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)todayTopicListArr{
    if (!_todayTopicListArr) {
        _todayTopicListArr = [NSMutableArray array];
    }
    return _todayTopicListArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
