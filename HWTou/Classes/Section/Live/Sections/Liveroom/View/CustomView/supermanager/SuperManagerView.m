//
//  SuperManagerView.m
//  HWTou
//
//  Created by robinson on 2018/3/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SuperManagerView.h"
#import "UIView+NTES.h"
#import "AnchorMoreFooterCollectionViewCell.h"

@interface SuperManagerView()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView  * collectionView;
@property (nonatomic,strong) NSArray * superManagerDataArray;
@property (nonatomic,strong) NSArray * managerDataArray;
@end

@implementation SuperManagerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (void)show
{
    if (self.ntesTop == self.ntesHeight) {
        CGFloat collcetionHeight = ([[self getDataArray] count]/4+1)*128;
        self.collectionView.frame = CGRectMake(0, self.ntesHeight-collcetionHeight, self.ntesWidth,collcetionHeight);
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.ntesTop -= self.ntesHeight;
        }];
        [self.collectionView reloadData];
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop += self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self getDataArray].count;
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnchorMoreFooterCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AnchorMoreFooterCollectionViewCell cellIdentity] forIndexPath:indexPath];
    [cell setImageTitleDict:[self getDataArray][indexPath.row] isNormal:YES];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    NSDictionary * dict = [self getDataArray][indexPath.row];
    NSInteger clickType = [dict[tagKey] integerValue];
    [_superDelegate superManagerWork:clickType messageModel:_messageModel];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.ntesWidth/4, 128);
}

#pragma mark - getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 2.5;
        flowLayout.minimumInteritemSpacing = 2.5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColorFromRGB(0xE2E2E2);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"AnchorMoreFooterCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[AnchorMoreFooterCollectionViewCell cellIdentity]];
    }
    return _collectionView;
}

- (NSArray *)getDataArray{
    if (_isSuperManager) {
        return self.superManagerDataArray;
    }
    return self.managerDataArray;
}

- (NSArray *)managerDataArray{
    if (!_managerDataArray) {
        _managerDataArray = @[
                          @{imgKey:@"zbtc_btn_jy",titleKey:@"禁言",tagKey:@(jyType)},
                          @{imgKey:@"zbtc_btn_tc",titleKey:@"剔出房间",tagKey:@(tcType)},];
    }
    return _managerDataArray;
}

- (NSArray *)superManagerDataArray{
    if (!_superManagerDataArray) {
        _superManagerDataArray = @[
//                       @{imgKey:@"zbtc_btn_sc",titleKey:@"删除评论",tagKey:@(scType)},
                       @{imgKey:@"zbtc_btn_jy",titleKey:@"禁言",tagKey:@(jyType)},
                       @{imgKey:@"zbtc_btn_tc",titleKey:@"剔出房间",tagKey:@(tcType)},
                       @{imgKey:@"zbtc_btn_bljl",titleKey:@"奖励",tagKey:@(bljlType)},
                       @{imgKey:@"zbtc_btn_yjjy",titleKey:@"永久禁言",tagKey:@(yjjyType)},
//                       @{imgKey:@"zbtc_btn_fjsb",titleKey:@"封禁设备",tagKey:@(fjsbType)}
                       ];
    }
    return _superManagerDataArray;
}

@end
