//
//  ProductCategoryView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductCategoryView.h"
#import "ProductCategoryCell.h"
#import "ProductCategoryDM.h"
#import "PublicHeader.h"

@interface ProductCategoryView () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UITableView *tabvLeft;
@property (nonatomic, strong) UICollectionView *cltvRight;
@property (nonatomic, assign) NSUInteger rowSelect;

@end

@implementation ProductCategoryView

static  NSString * const kCellIdList    = @"CategoryListCell";
static  NSString * const kCellIdContent = @"CategoryContentCell";

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
    self.rowSelect = -1;
    self.backgroundColor = UIColorFromHex(0xC4C4C4);
    
    self.tabvLeft = [[UITableView alloc] init];
    self.tabvLeft.delegate = self;
    self.tabvLeft.dataSource = self;
    self.tabvLeft.rowHeight = 46.0f;
    self.tabvLeft.showsVerticalScrollIndicator = NO;
    self.tabvLeft.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tabvLeft registerClass:[ProductCategoryTabCell class] forCellReuseIdentifier:kCellIdList];
    
    // 设置默认选中第一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.tabvLeft.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        [self.tabvLeft.delegate tableView:self.tabvLeft willSelectRowAtIndexPath:indexPath];
    }
    
    [self.tabvLeft selectRowAtIndexPath:indexPath animated:YES scrollPosition: UITableViewScrollPositionNone];
    if ([self.tabvLeft.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tabvLeft.delegate tableView:self.tabvLeft didSelectRowAtIndexPath:indexPath];
    }
    
    CGFloat itemW = CoordXSizeScale(60);
    CGFloat itemH = CoordXSizeScale(85); // 图标高度 + 图标与标题间距 + 标题高度
    CGFloat lrEdge = CoordXSizeScale(20); // 左右边距
    CGFloat tbEdge = CoordXSizeScale(30); // 上下边距
    CGFloat itemSpace = (kMainScreenWidth - CoordXSizeScale(100) - 1 - itemW * 3 - lrEdge * 2) / 2;
    CGFloat lineSpace = CoordXSizeScale(30);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    flowLayout.minimumInteritemSpacing = itemSpace;
    flowLayout.minimumLineSpacing = lineSpace;
    flowLayout.sectionInset = UIEdgeInsetsMake(tbEdge, lrEdge, tbEdge, lrEdge);
    
    self.cltvRight = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.cltvRight registerClass:[ProductCategoryCollCell class] forCellWithReuseIdentifier:kCellIdContent];
    self.cltvRight.showsVerticalScrollIndicator = NO;
    self.cltvRight.backgroundColor = [UIColor whiteColor];
    self.cltvRight.dataSource = self;
    self.cltvRight.delegate = self;
    
    [self addSubview:self.tabvLeft];
    [self addSubview:self.cltvRight];
    
    [self.tabvLeft makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(self);
        make.width.equalTo(CoordXSizeScale(100));
        make.top.equalTo(@0.5);
    }];
    
    [self.cltvRight makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tabvLeft.trailing).offset(@0.5);
        make.trailing.bottom.equalTo(self);
        make.top.equalTo(@0.5);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCategoryTabCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdList];
    cell.dmCategory = self.listData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rowSelect != indexPath.row) {
        self.rowSelect = indexPath.row;
        [self.cltvRight reloadData];
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.subCategorys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCategoryCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdContent forIndexPath:indexPath];
    ProductCategoryDM *sub = self.subCategorys[indexPath.row];
    [cell setDmCategory:sub];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListViewController *listVC = [[ProductListViewController alloc] init];
    listVC.category = self.listData[self.rowSelect];
    listVC.currentPage = indexPath.row;
    [self.viewController.navigationController pushViewController:listVC animated:YES];
}

- (NSArray<ProductCategoryDM*> *)subCategorys
{
    if (self.rowSelect < self.listData.count) {
        ProductCategoryList *category = self.listData[self.rowSelect];
        return category.children;
    }
    return nil;
}

@end

