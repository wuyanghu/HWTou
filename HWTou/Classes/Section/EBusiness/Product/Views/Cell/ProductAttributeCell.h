//
//  ProductAttributeCell.h
//  HWTou
//
//  Created by 彭鹏 on 2017/5/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductAttributeDM;
@class ProductAttributeCell;

@protocol ProductAttributeCellDelegate <NSObject>

/**
 商品数量发生改变
 
 @param result 数量值
 */
typedef void(^ProductNumberChangeBlock)(int result);

/**
 选择商品属性

 @param cell 当前cell
 @param selected 是否选中
 */
- (void)productAttributeCell:(ProductAttributeCell *)cell didSelectItem:(BOOL)selected;

@end

@interface ProductAttributeCell : UICollectionViewCell

@property (nonatomic, strong) ProductAttributeDM *dmAttribute;

@property (nonatomic, weak) id<ProductAttributeCellDelegate> delegage;

/**
 商品规格属性字体, 提供外部计算使用
 */
+ (UIFont *)fontAttribute;

@end

@interface ProductAttrStockCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger startNum;

@property (nonatomic, assign) NSInteger maxNumber;

@property (nonatomic, copy) ProductNumberChangeBlock changeBlock;

@end

@interface ProductAttrHeaderView : UICollectionReusableView

@property (nonatomic, copy) NSString *title;

@end
