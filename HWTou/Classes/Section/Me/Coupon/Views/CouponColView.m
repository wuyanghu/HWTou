//
//  CouponColView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CouponColView.h"

#import "PublicHeader.h"

#import "CouponRequest.h"
#import "CouponColCell.h"

@interface CouponColView()<UICollectionViewDataSource,UICollectionViewDelegate>{

    CouponType g_ColType;
    
}

@property (nonatomic, strong) UICollectionView *m_ColView;
@property (nonatomic, strong) NSMutableArray<CouponModel *> *m_CouponArray;

@end

@implementation CouponColView
@synthesize m_Delegate;

@synthesize m_ColView;
@synthesize m_CouponArray;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addMainView];
        
        [self setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addColView];
    
}

- (void)addColView{

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
    
    // UICollectionViewCell 注册 否则会报错
    [colView registerClass:[CouponColCell class] forCellWithReuseIdentifier:kCouponColCellId];
    
    [self setM_ColView:colView];
    [self addSubview:colView];

    [colView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        
    }];
    
    // 下拉刷新
    
    WeakObj(self);
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [selfWeak loadNewData];
        
    }];
    
    [header.lastUpdatedTimeLabel setHidden:YES];
    
    colView.mj_header = header;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return [m_CouponArray count];
    
}

// 上下行 cell 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCouponColCellId
                                                                        forIndexPath:indexPath];
    
    CouponModel *model;
    OBJECTOFARRAYATINDEX(model, m_CouponArray, [indexPath row]);
    
    [cell setCouponColCellUpDataSource:model cellForRowAtIndexPath:indexPath];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onDidSelectItem:)]) {
        
        CouponColCell *cell = (CouponColCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [m_Delegate onDidSelectItem:cell.m_Model];
        
    }
  
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark - 下拉刷新数据
- (void)loadNewData{

    // 马上进入刷新状态
    [m_ColView.mj_header beginRefreshing];
    
    [self accessDataSourceWithColType:g_ColType];
    
}

#pragma mark - 获取数据源
- (void)accessDataSourceWithColType:(CouponType)colType{
    
    if (colType == CouponType_Product) {
        CouponProductParam *param = [[CouponProductParam alloc] init];
        param.item_ids = self.productIds;
        param.flag = 1;
        [self obtainCouponListWithParam:param];
    } else {
        CouponParam *param = [[CouponParam alloc] init];
        
        [param setType:colType];
        [param setFlag:0];
        
        [self obtainCouponListWithParam:param];
    }
}

#pragma mark - Public Functions
- (void)dataInitialization{
    if (IsNilOrNull(m_CouponArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [self setM_CouponArray:tmpArray];
        
    }
    
}

- (void)setCouponColViewType:(CouponType)colType{

    g_ColType = colType;
    
    [self accessDataSourceWithColType:colType];
    
}

#pragma mark - Button Handlers

#pragma mark - NetworkRequest Manager
- (void)obtainCouponListWithParam:(CouponParam *)param{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [CouponRequest obtainCouponListWithParam:param success:^(CouponResponse *response) {
        
        if (response.success) {
            
            if (!IsArrEmpty(m_CouponArray)) [m_CouponArray removeAllObjects];
            
            [m_CouponArray addObjectsFromArray:response.data];
            
            [m_ColView reloadData];

            [HUDProgressTool dismiss];
            
        }else{

            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
        [m_ColView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [m_ColView.mj_header endRefreshing];
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
