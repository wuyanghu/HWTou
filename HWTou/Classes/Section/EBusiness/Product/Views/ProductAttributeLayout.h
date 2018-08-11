//
//  ProductAttributeLayout.h
//
//  Created by 彭鹏 on 2017/5/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductAttributeLayoutDelegate <NSObject>

@required
// item size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
// header size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

// footer size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end

@interface ProductAttributeLayout : UICollectionViewLayout

@property (nonatomic, weak) id<ProductAttributeLayoutDelegate> delegate;

@property (nonatomic, assign) UIEdgeInsets sectionInset; //sectionInset
@property (nonatomic, assign) CGFloat lineSpacing;  // line space
@property (nonatomic, assign) CGFloat itemSpacing;  // item space

@end
