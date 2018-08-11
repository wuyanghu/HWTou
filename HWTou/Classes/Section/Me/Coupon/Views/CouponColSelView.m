//
//  CouponColSelView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/5/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CouponColSelView.h"
#import "CouponColCell.h"
#import "PublicHeader.h"

@interface CouponColSelView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *m_ColView;

@end

@implementation CouponColSelView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addMainView];
        [self setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
    }
    return self;
}

#pragma mark - Add UI
- (void)addMainView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    [layout setSectionInset:UIEdgeInsetsMake(8, 0, 8, 0)];
    [layout setItemSize:CGSizeMake(kMainScreenWidth, 115)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:layout];
    
    [colView setDelegate:self];
    [colView setDataSource:self];
    [colView setAlwaysBounceVertical:YES];
    [colView setBackgroundColor:[UIColor clearColor]];
    
    [colView registerClass:[CouponColSelectCell class] forCellWithReuseIdentifier:kCouponColCellId];
    
    [self setM_ColView:colView];
    [self addSubview:colView];
    
    [colView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.coupons count];
}

// 上下行 cell 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponColSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCouponColCellId
                                                                    forIndexPath:indexPath];
    
    CouponSelDM *model;
    OBJECTOFARRAYATINDEX(model, self.coupons, [indexPath row]);
    
    [cell setDmCoupon:model];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CouponSelDM *dmCoupon;
    OBJECTOFARRAYATINDEX(dmCoupon, self.coupons, [indexPath row]);
    dmCoupon.selected = !dmCoupon.selected;
    
    if (dmCoupon.selected) {
        [self.selCoupons addObject:dmCoupon];
    } else {
        [self.selCoupons removeObject:dmCoupon];
    }
    
    CouponColSelectCell *cell = (CouponColSelectCell *)[self.m_ColView cellForItemAtIndexPath:indexPath];
    [cell setDmCoupon:dmCoupon];
    
    CGFloat totalPrice = 0;
    for (CouponSelDM *obj in self.selCoupons) {
        totalPrice += [obj.rule doubleValue];
    }
    
    if (totalPrice > self.totalPrice) {
        [HUDProgressTool showOnlyText:@"您当前选择的优惠券总价大于支付金额(超出部分不返现)"];
    }

}

- (NSMutableArray *)selCoupons
{
    if (_selCoupons == nil) {
        _selCoupons = [NSMutableArray array];
    }
    return _selCoupons;
}
@end
