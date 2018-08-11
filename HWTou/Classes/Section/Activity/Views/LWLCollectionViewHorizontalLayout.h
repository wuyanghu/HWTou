//
//  DDCollectionViewHorizontalLayout.h
//  TestCollectionView
//
//  Created by 刘卫林 on 15/08/27.

#import <UIKit/UIKit.h>

@interface LWLCollectionViewHorizontalLayout : UICollectionViewFlowLayout

// 每一行显示多少个
@property (nonatomic) NSUInteger itemCountPerRow;
// 每一页显示多少行
@property (nonatomic) NSUInteger rowCount;

@end
