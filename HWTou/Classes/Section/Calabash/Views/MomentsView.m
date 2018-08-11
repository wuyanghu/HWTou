//
//  MomentsView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MomentsView.h"

#import "CalabashRequest.h"
#import "MomentColViewCell.h"

//#import "UICollectionView+ARDynamicCacheHeightLayoutCell.h"

@interface MomentsView()<UICollectionViewDataSource,UICollectionViewDelegate>{

    NSInteger g_Page;
    NSInteger g_PageSize;
    
}

@property (nonatomic, strong) UICollectionView *m_ColView;
@property (nonatomic, strong) UIButton *m_EditorBtn;

@property (nonatomic, strong) NSMutableArray *m_MomentsColArray;

@end

@implementation MomentsView
@synthesize m_Delegate;

@synthesize m_ColView;
@synthesize m_EditorBtn;

@synthesize m_MomentsColArray;

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
    [self addEditorBtn];
    
}

- (void)addColView{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:layout];
    
    [colView setDelegate:self];
    [colView setDataSource:self];
    [colView setBackgroundColor:[UIColor clearColor]];
    
    // UICollectionViewCell 注册 否则会报错
    [colView registerClass:[MomentColViewCell class] forCellWithReuseIdentifier:kMomentColViewCellId];
    
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
    
    // 上拉加载更多
    colView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [selfWeak loadMoreData];
        
    }];
    
    [colView.mj_footer setHidden:YES];
    
    [self accessDataSourceWithLoadDataType:LoadDataType_Default
                                  withPage:g_Page
                              withpageSize:g_PageSize];
    
}

- (void)addEditorBtn{

    UIButton *editorBtn = [BasisUITool getBtnWithTarget:self action:@selector(editorBtnClick:)];
    
    [editorBtn setImage:ImageNamed(CALABASH_EDITOR_BTN_NOR) forState:UIControlStateNormal];
    [editorBtn setImage:ImageNamed(CALABASH_EDITOR_BTN_NOR) forState:UIControlStateDisabled];
    
    [self setM_EditorBtn:editorBtn];
    [self addSubview:editorBtn];
    
    [editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(54, 54));
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-70);
        
    }];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return [m_MomentsColArray count];
    
}

// 上下行 cell 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    CGSize size = [collectionView ar_sizeForCellWithIdentifier:kMomentColViewCellId indexPath:indexPath fixedWidth:collectionView.frame.size.width configuration:^(__kindof UICollectionViewCell *cell) {
//
//        MomentModel *model;
//        OBJECTOFARRAYATINDEX(model, m_MomentsColArray, [indexPath row]);
//
//        [(MomentColViewCell *)cell setMomentColViewCellUpDataSource:model cellForRowAtIndexPath:indexPath];
//
//    }];
    
//    return CGSizeMake(collectionView.frame.size.width, size.height);
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = [indexPath row];

    MomentColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMomentColViewCellId
                                                                        forIndexPath:indexPath];
    
    MomentModel *model;
    OBJECTOFARRAYATINDEX(model, m_MomentsColArray, row);
    
    [cell setMomentColViewCellUpDataSource:model cellForRowAtIndexPath:indexPath];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark - 下拉刷新数据
- (void)loadNewData{
    
    g_Page = Request_Page;
    
    // 马上进入刷新状态
    [m_ColView.mj_header beginRefreshing];
    
    [self accessDataSourceWithLoadDataType:LoadDataType_New withPage:g_Page withpageSize:g_PageSize];
    
}

#pragma mark - 上拉加载更多数据
- (void)loadMoreData{
    
    g_Page += Request_PageSize;
    
    [self accessDataSourceWithLoadDataType:LoadDataType_More withPage:g_Page withpageSize:g_PageSize];
    
}

#pragma mark - 获取数据源
- (void)accessDataSourceWithLoadDataType:(LoadDataType)type withPage:(NSInteger)page
                            withpageSize:(NSInteger)pageSize{
    
    TeachersListParam *param = [[TeachersListParam alloc] init];
    
    [param setStart_page:page];
    [param setPages:pageSize];
    
    [self obtainMomentsListWithParam:param withLoadDataType:type];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    g_Page = Request_Page;
    g_PageSize = Request_PageSize;
    
    if (IsNilOrNull(m_MomentsColArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [self setM_MomentsColArray:tmpArray];
        
    }
    
}

- (void)endRefreshing:(LoadDataType)loadDataType{
    
    switch (loadDataType) {
        case LoadDataType_New:
            [m_ColView.mj_header endRefreshing];
            break;
        case LoadDataType_More:
            [m_ColView.mj_footer endRefreshing];
            break;
        default:{
            break;}
    }
    
}

// 是否有更多数据 MJ处理
- (void)moreDataWithCurrentTotalNum:(NSInteger)currentTotalNum withTotalNum:(NSInteger)totalNum{
    
    if (currentTotalNum < totalNum) {
        
        [m_ColView.mj_footer setHidden:NO];
        
    }else{
        
        [m_ColView.mj_footer endRefreshingWithNoMoreData];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            
            // 隐藏当前的上拉刷新控件
            [m_ColView.mj_footer setHidden:YES];
            
        });
        
    }
    
}

#pragma mark - Button Handlers
- (void)editorBtnClick:(id)sender{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onShareMoments)]) {
        
        [m_Delegate onShareMoments];
        
    }
    
}

#pragma mark - NetworkRequest Manager
- (void)obtainMomentsListWithParam:(CalabashParam *)param withLoadDataType:(LoadDataType)type{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [CalabashRequest obtainMomentsListWithParam:param success:^(CalabashMomentResponse *response) {
        
        NSInteger currentTotalNum = [response.data.list count];
        NSInteger totalNum = response.data.total_pages;

        if (response.success) {
           
            if (type == LoadDataType_More) {
                
                currentTotalNum += [m_MomentsColArray count];
                
                [m_MomentsColArray addObjectsFromArray:response.data.list];
                
            }else{
                
                if (!IsArrEmpty(m_MomentsColArray)) [m_MomentsColArray removeAllObjects];
                
                [m_MomentsColArray addObjectsFromArray:response.data.list];
                
            }
            
            [m_ColView reloadData];
            
            [self moreDataWithCurrentTotalNum:currentTotalNum withTotalNum:totalNum];

            [HUDProgressTool dismiss];
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
        [self endRefreshing:type];
        
    } failure:^(NSError *error) {
        
        [self endRefreshing:type];
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
