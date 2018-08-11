//
//  AddressManageView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AddressManageView.h"

#import "PublicHeader.h"

#import "AddressRequest.h"
#import "AddressColViewCell.h"

@interface AddressManageView()<AddressColViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *m_AddressColView;
@property (nonatomic, strong) NSMutableArray *m_AddressDataSourceArray;

@end

@implementation AddressManageView
@synthesize m_Delegate;
@synthesize m_AddressColView;
@synthesize m_AddressDataSourceArray;

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
    
    [self addAddressColView];
    
}

- (void)addAddressColView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setItemSize:CGSizeMake(kMainScreenWidth, 115)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:layout];
    
    [colView setDelegate:self];
    [colView setDataSource:self];
    [colView setAlwaysBounceVertical:YES];
    [colView setBackgroundColor:[UIColor clearColor]];
    
    // UICollectionViewCell 注册 否则会报错
    [colView registerClass:[AddressColViewCell class] forCellWithReuseIdentifier:kAddressColViewCellId];
    
    [self setM_AddressColView:colView];
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
    
    return [m_AddressDataSourceArray count];
    
}

// 同一行的 cell 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 0;
    
}

// 上下行 cell 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 10;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    AddressColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddressColViewCellId
                                                                         forIndexPath:indexPath];
    
    [cell setM_Delegate:self];
    
    AddressGoodsDM *model;
    OBJECTOFARRAYATINDEX(model, m_AddressDataSourceArray, [indexPath row]);

    [cell setAddressColCellUpDataSource:model cellForRowAtIndexPath:indexPath];
    
    if (model.is_top == 1) {

        [collectionView selectItemAtIndexPath:indexPath
                                     animated:NO
                               scrollPosition:UICollectionViewScrollPositionNone];
        
    }
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.m_Delegate respondsToSelector:@selector(didSelectItem:)]) {
        
        AddressGoodsDM *model;
        OBJECTOFARRAYATINDEX(model, m_AddressDataSourceArray, [indexPath row]);
        
        [self.m_Delegate didSelectItem:model];
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
}

#pragma mark - 获取数据源
- (void)accessDataSource{

    [self obtainConsigneeAddressList];
    
}

#pragma mark - 下拉刷新数据
- (void)loadNewData{
    
    // 马上进入刷新状态
    [m_AddressColView.mj_header beginRefreshing];
    
    [self accessDataSource];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    if (IsNilOrNull(m_AddressDataSourceArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [self setM_AddressDataSourceArray:tmpArray];
        
    }
    
}

- (NSIndexPath *)defaultAddressDataProcessing:(NSInteger)maid{

    NSIndexPath *indexPath = nil;
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:m_AddressDataSourceArray];
    
    for (NSInteger index = 0 ; index < [tmpArray count]; index++) {
        
        AddressGoodsDM *model;
        OBJECTOFARRAYATINDEX(model, tmpArray, index);
        
        if (model.maid == maid) {
            
            [model setIs_top:1];
            
            REPLACEOBJECTATINDEX(model, tmpArray, index);
            
        }else{
            
            if (model.is_top == 1) {
                
                [model setIs_top:0];
                
                REPLACEOBJECTATINDEX(model, tmpArray, index);
                
                indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                
            }
            
        }

    }
    
    if (!IsArrEmpty(m_AddressDataSourceArray)) [m_AddressDataSourceArray removeAllObjects];
    
    [m_AddressDataSourceArray addObjectsFromArray:tmpArray];
    
    return indexPath;
    
}

#pragma mark - Button Handlers

#pragma mark - MeView Delegate Manager
- (void)onDefAddr:(AddressGoodsDM *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!IsNilOrNull(model)) {
        
        AddressParam *param = [[AddressParam alloc] init];
        
        [param setMaid:model.maid];
        
        [self topConsigneeAddressWithParam:param cellForRowAtIndexPath:indexPath];
        
    }
    
}

- (void)onEditor:(AddressGoodsDM *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onEditor:)]) {
        
        [m_Delegate onEditor:model];
        
    }
    
}

- (void)onDelete:(AddressGoodsDM *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (!IsNilOrNull(model)) {
    
        AddressParam *param = [[AddressParam alloc] init];
        
        [param setMaid:model.maid];
        
        [self deleteConsigneeAddressWithParam:param cellForRowAtIndexPath:indexPath];
        
        if ([self.m_Delegate respondsToSelector:@selector(deleteAddress:)]) {
            
            [self.m_Delegate deleteAddress:model];
            
        }
    }

}

#pragma mark - NetworkRequest Manager
// 获取收货地址列表
- (void)obtainConsigneeAddressList{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [AddressRequest obtainConsigneeAddressList:^(AddressResponse *response) {
        
        if (!IsArrEmpty(response.data)) {
            
            if (!IsArrEmpty(m_AddressDataSourceArray)) {
                
                [m_AddressDataSourceArray removeAllObjects];
                
            }
            
            [m_AddressDataSourceArray addObjectsFromArray:response.data];
            
            [m_AddressColView reloadData];

        }
        
        [m_AddressColView.mj_header endRefreshing];
        
        [HUDProgressTool dismiss];
        
    } failure:^(NSError *error) {
        
        [m_AddressColView.mj_header endRefreshing];
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

// 删除收货地址
- (void)deleteConsigneeAddressWithParam:(AddressParam *)param
                  cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [AddressRequest deleteConsigneeAddressWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {
            
            REMOVEOBJECTOFARRAYATINDEX(m_AddressDataSourceArray, [indexPath row]);
            
            [UIView performWithoutAnimation:^{
                
                [m_AddressColView reloadData];
                
            }];

            [HUDProgressTool showSuccessWithText:ReqSuccessful];
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

// 设置默认收货地址
- (void)topConsigneeAddressWithParam:(AddressParam *)param
               cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [AddressRequest topConsigneeAddressWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {
            
            NSIndexPath *deselectIndexPath = [self defaultAddressDataProcessing:param.maid];
            
            [UIView performWithoutAnimation:^{

                if (!IsNilOrNull(deselectIndexPath)) {
                    
                    [m_AddressColView reloadItemsAtIndexPaths:@[deselectIndexPath]];
                    
                }
                
                [m_AddressColView reloadItemsAtIndexPaths:@[indexPath]];
                
            }];
            
            [HUDProgressTool showSuccessWithText:ReqSuccessful];
            
        }else{
        
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
