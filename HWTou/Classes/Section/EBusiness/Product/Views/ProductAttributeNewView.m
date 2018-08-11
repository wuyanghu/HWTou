//
//  ProductAttributeNewView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/5/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductAttributeNewView.h"
#import "ProductAttributeLayout.h"
#import "ProductAttributeCell.h"
#import "ProductAttributeDM.h"
#import "ProductDetailDM.h"
#import "PublicHeader.h"

@interface ProductAttributeNewView () <UICollectionViewDataSource, UICollectionViewDelegate, ProductAttributeLayoutDelegate, ProductAttributeCellDelegate>
{
    UIImageView     *_imgvIcon;
    UILabel         *_labPrompt;
    UILabel         *_labPrice;
    UILabel         *_labStock;
}

@property (nonatomic, strong) ProductAttStockDM *dmStock; // 库存属性
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *dictSeleted; // 选中的数据

@end

@implementation ProductAttributeNewView

static NSString * const kCellIdNomal  = @"CellIdNomal";
static NSString * const kCellIdStock  = @"CellIdStock";
static NSString * const kCellIdHeader = @"CellIdHeader";
static NSString * const kCellIdFooter = @"CellIdFooter";

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
    self.backgroundColor = [UIColor whiteColor];
    
    _imgvIcon = [[UIImageView alloc] init];
    _labPrice = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xb4292d) size:14.0f];
    _labPrompt = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:14.0f];
    _labStock = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:13.0f];
    _labPrompt.numberOfLines = 2;
    
    ProductAttributeLayout *layout = [[ProductAttributeLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    layout.lineSpacing = 10;
    layout.itemSpacing = 15;
    layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[ProductAttributeCell class] forCellWithReuseIdentifier:kCellIdNomal];
    [self.collectionView registerClass:[ProductAttrStockCell class] forCellWithReuseIdentifier:kCellIdStock];
    [self.collectionView registerClass:[ProductAttrHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellIdHeader];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCellIdFooter];
    
    [self addSubview:_imgvIcon];
    [self addSubview:_labPrice];
    [self addSubview:_labStock];
    [self addSubview:_labPrompt];
    [self addSubview:self.collectionView];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20.0f);
        make.leading.equalTo(15.0f);
        make.size.equalTo(CGSizeMake(90, 90));
    }];
    
    [_labPrompt makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvIcon.trailing).offset(8);
        make.trailing.lessThanOrEqualTo(self).offset(-15);
        make.bottom.equalTo(_imgvIcon);
    }];
    
    [_labStock makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labPrompt);
        make.bottom.equalTo(_labPrompt.top);
    }];
    
    [_labPrice makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labPrompt);
        make.bottom.equalTo(_labStock.top);
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.equalTo(self);
        make.top.equalTo(_imgvIcon.bottom).offset(15);
        make.bottom.equalTo(self).offset(-15);
    }];
}

- (NSMutableDictionary *)dictSeleted
{
    if (!_dictSeleted) {
        _dictSeleted = [NSMutableDictionary dictionary];
    }
    return _dictSeleted;
}

- (void)setListAttribute:(NSArray<ProductAttListDM *> *)listAttribute
{
    _listAttribute = listAttribute;
    // 遍历所有属性，计算宽度
    [listAttribute enumerateObjectsUsingBlock:^(ProductAttListDM *listAtt, NSUInteger section, BOOL *stop) {
        [listAtt.prop_value_list enumerateObjectsUsingBlock:^(ProductAttributeDM *dmAttr, NSUInteger row, BOOL *stop) {
            
            NSDictionary *dictAttribute = [NSDictionary dictionaryWithObject:[ProductAttributeCell fontAttribute] forKey:NSFontAttributeName];
            
            CGRect rectRow = [dmAttr.value_name boundingRectWithSize:CGSizeMake(MAXFLOAT, CGFLOAT_MIN) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictAttribute context:nil];
            dmAttr.width = rectRow.size.width + 30;
            if (dmAttr.state == ProductAttrStateSelected) {
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:row inSection:section];
                [self.dictSeleted setObject:idxPath forKey:@(section)];
            }
        }];
    }];
    [self updateStateInfo];
}

- (void)setListStock:(NSArray<ProductAttStockDM *> *)listStock
{
    _listStock = listStock;
    [self updateStateInfo];
}

- (void)setDmProduct:(ProductDetailDM *)dmProduct
{
    _dmProduct = dmProduct;
    _labPrice.text = dmProduct.strPrice;
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:dmProduct.img_url]];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.listAttribute.count + 1; // 加一行 库存数量
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == self.listAttribute.count) { // 库存数量
        return 1;
    }
    ProductAttListDM *dmList;
    OBJECTOFARRAYATINDEX(dmList, self.listAttribute, section);
    return dmList.prop_value_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.listAttribute.count) { // 库存数量
        ProductAttrStockCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdStock forIndexPath:indexPath];
        [cell setStartNum:self.startNum];
        
        cell.changeBlock = ^(int result) {
            self.startNum = result;
            !self.blockNubmer ?: self.blockNubmer(result);
        };
        return cell;
    } else {
        ProductAttributeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdNomal forIndexPath:indexPath];
        
        ProductAttListDM *dmList;
        OBJECTOFARRAYATINDEX(dmList, self.listAttribute, indexPath.section);
        
        ProductAttributeDM *dmAttribute;
        OBJECTOFARRAYATINDEX(dmAttribute, dmList.prop_value_list, indexPath.row);
        
        [cell setDmAttribute:dmAttribute];
        if (cell.delegage == nil) {
            [cell setDelegage:self];
        }
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ProductAttrHeaderView *vHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellIdHeader forIndexPath:indexPath];
        if (indexPath.section == self.listAttribute.count) { // 库存数量
            vHeader.title = @"数量";
        } else {
            ProductAttListDM *dmList;
            OBJECTOFARRAYATINDEX(dmList, self.listAttribute, indexPath.section);
            vHeader.title = dmList.prop_name;
        }
        return vHeader;
    } else {
        UICollectionReusableView *vFooter= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCellIdFooter forIndexPath:indexPath];
        return vFooter;
    }
}

#pragma mark - ProductAttributeCellDelegate
- (void)productAttributeCell:(ProductAttributeCell *)cell didSelectItem:(BOOL)selected
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    ProductAttListDM *dmList;
    OBJECTOFARRAYATINDEX(dmList, self.listAttribute, indexPath.section);
    
    NSIndexPath *idxSel = [self.dictSeleted objectForKey:@(indexPath.section)];
    if (idxSel) { // 首先将已选择的取消
        
        ProductAttributeDM *attSel;
        OBJECTOFARRAYATINDEX(attSel, dmList.prop_value_list, idxSel.row);
        
        attSel.state = ProductAttrStateNormal;
        ProductAttributeCell *cellSel = (ProductAttributeCell *)[self.collectionView cellForItemAtIndexPath:idxSel];
        [cellSel setDmAttribute:attSel];
        
        [self.dictSeleted removeObjectForKey:@(indexPath.section)];
    }
    
    if (selected) { // 选择新的属性
        
        ProductAttributeDM *attSel;
        OBJECTOFARRAYATINDEX(attSel, dmList.prop_value_list, indexPath.row);
        attSel.state = ProductAttrStateSelected;
        [self.dictSeleted setObject:indexPath forKey:@(indexPath.section)];
    }
    [self updateStateInfo];
}

- (void)updateStateInfo
{
    NSMutableString *idsAttr = [NSMutableString string];
    NSMutableArray *selAttr = [NSMutableArray array];
    
    // 排序的目的: 选择的顺序混乱导致拼接属性id的时候不正确
    NSArray *allKeys = [[self.dictSeleted allKeys] sortedArrayUsingSelector:@selector(compare:)];
    if (allKeys.count > 0) {
        NSMutableString *strPrompt = [NSMutableString stringWithString:@"已选择: "];
        for (NSNumber *key in allKeys) {
            NSIndexPath *indexPath = [self.dictSeleted objectForKey:key];
            
            ProductAttListDM *dmList;
            OBJECTOFARRAYATINDEX(dmList, self.listAttribute, indexPath.section);
            
            ProductAttributeDM *dmAttribute;
            OBJECTOFARRAYATINDEX(dmAttribute, dmList.prop_value_list, indexPath.row);
            
            [selAttr addObject:dmAttribute];
            
            if (idsAttr.length > 0) {
                [idsAttr appendString:@","];
            }
            
            [idsAttr appendFormat:@"%ld", (long)dmAttribute.value_id];
            [strPrompt appendFormat:@" %@ ", dmAttribute.value_name];
        }
        
        _labPrompt.text = strPrompt;
    } else {
        _labPrompt.text = @"请选择规格属性";
    }
    
    _labPrice.text = self.dmProduct.strPrice;
    _labStock.text = @"库存: ";
    
    self.dmStock = nil;
    
    if (idsAttr.length > 0) {
        [self.listStock enumerateObjectsUsingBlock:^(ProductAttStockDM *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.value_ids isEqualToString:idsAttr]) {
                _labPrice.text = [NSString stringWithFormat:@"¥%.2f", obj.price];
                _labStock.text = [NSString stringWithFormat:@"库存: %ld", (long)obj.stock];
                self.dmStock = obj;
                *stop = YES;
            }
        }];
    }
    !self.blockAttribute ?: self.blockAttribute(self.dmStock, selAttr);
}

#pragma mark - ProductAttributeLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.listAttribute.count) { // 库存数量
        return CGSizeMake(160, 36);
    } else {
        ProductAttListDM *dmList;
        OBJECTOFARRAYATINDEX(dmList, self.listAttribute, indexPath.section);
        
        ProductAttributeDM *dmAtt;
        OBJECTOFARRAYATINDEX(dmAtt, dmList.prop_value_list, indexPath.row);
        return CGSizeMake(dmAtt.width, dmAtt.height);
    }
}

// header size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kMainScreenWidth, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == self.listAttribute.count) { // 库存数量
        CGSizeMake(0, 0);
    }
    return CGSizeMake(kMainScreenWidth, 10);
}
@end
