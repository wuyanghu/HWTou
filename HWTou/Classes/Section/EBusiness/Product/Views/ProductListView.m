//
//  ProductListView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductListView.h"
#import "ProductListCell.h"
#import "PublicHeader.h"

@interface ProductListView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation ProductListView

static  NSString * const kCellIdentifier = @"CellIdentifier";

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
    CGFloat itemW = kMainScreenWidth * 0.5;
    CGFloat itemH = kMainScreenWidth * kScale_9_16;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(16, 0, 16, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[ProductListCell class] forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self addSubview:self.collectionView];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setListData:(NSArray<ProductDetailDM *> *)listData
{
    _listData = listData;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell setProduct:self.listData[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
    detailVC.dmProduct = self.listData[indexPath.row];
    [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
}
@end
