//
//  ProductAttributeLayout.m
//
//  Created by 彭鹏 on 2017/5/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductAttributeLayout.h"

@interface ProductAttributeLayout ()

@property (nonatomic, assign) CGFloat yCoordMax;
@property (nonatomic, assign) CGFloat xCoordMax;
@property (nonatomic, assign) CGFloat lastHeight;
@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation ProductAttributeLayout

/**
 准备布局时回调
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    NSLog(@"%s", __func__);
    
    self.xCoordMax = 0;
    self.yCoordMax = 0;
    
    if (self.attributes == nil) {
        self.attributes = [NSMutableArray array];
    }
    
    [self.attributes removeAllObjects];
    
    NSInteger sections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sections; section++) {
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            // 获取header的UICollectionViewLayoutAttributes
            UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attributes addObject:headerAttrs];
        }
        
        self.xCoordMax = 0;
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < items; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributes addObject:attributes];
        }
        
        self.yCoordMax += self.lastHeight;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            // 获取footer的UICollectionViewLayoutAttributes
            UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attributes addObject:footerAttrs];
        }
    }
}

/**
 边距发生改变时，是否需要重新布局
 */
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}

/**
 返回内容的大小，用于scroll滚动
 
 @return 内容大小
 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.yCoordMax + self.sectionInset.bottom);
}

/**
 每个section添加眉头和眉尾
 
 @param elementKind 种类
 @param indexPath 位置
 @return 布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    CGSize size = CGSizeZero;
    
    // Header
    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
        }
        self.yCoordMax += self.sectionInset.top;
    } else {
        // Footer
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
        }
    }
    
    CGFloat maxW = CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right;
    if (size.width > maxW) {
        size.width = maxW;
    }
    
    attributes.frame = CGRectMake(self.sectionInset.left , self.yCoordMax, size.width, size.height);
    self.yCoordMax += size.height;
    
    return attributes;
}

/**
 每个cell布局时回调
 
 @param indexPath cell位置
 @return 布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGSize sizeItem = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    
    // 按钮最大宽度
    CGFloat maxW = CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right;
    if (sizeItem.width > maxW) {
        sizeItem.width = maxW;
    }
    
    if (indexPath.row > 0) {
        self.xCoordMax += self.itemSpacing;
    }
    
    // 实际最大x坐标
    CGFloat maxX = self.xCoordMax + sizeItem.width;
    if (maxX > maxW) {
        // 超出范围了，需要换行
        self.xCoordMax = self.sectionInset.left;
        self.yCoordMax += self.lineSpacing;
        self.yCoordMax += self.lastHeight;
    }
    
    if (indexPath.row == 0) {
        self.xCoordMax += self.sectionInset.left;
    }
    
    // 在这里计算每个cell的具体布局
    attributes.frame = CGRectMake(self.xCoordMax, self.yCoordMax, sizeItem.width, sizeItem.height);
    
    self.lastHeight = sizeItem.height;
    self.xCoordMax += sizeItem.width;
    
    return attributes;
}

/**
 可见显示区域内返回对应的布局属性
 
 @param rect 可见区域
 @return 布局属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributes;
}
@end
