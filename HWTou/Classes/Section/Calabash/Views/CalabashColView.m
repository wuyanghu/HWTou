//
//  CalabashColView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CalabashColView.h"

#import "PublicHeader.h"

#import "CalabashRequest.h"
#import "CourseColViewCell.h"
#import "TeachersColViewCell.h"

@interface CalabashColView()<CourseColViewCellDelegate,TeachersColViewCellDelegate,
UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NSInteger g_Page;
    NSInteger g_PageSize;

    NSString *g_SearchKey;
    CalabashColType g_ColType;
    
}

@property (nonatomic, strong) UICollectionView *m_ColView;
@property (nonatomic, strong) NSMutableArray<CourseModel *> *m_CourseColArray;
@property (nonatomic, strong) NSMutableArray<TeacherModel *> *m_TeachersColArray;

@end

@implementation CalabashColView
@synthesize m_Delegate;
@synthesize m_ColView;
@synthesize m_CourseColArray,m_TeachersColArray;

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
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setItemSize:CGSizeMake(kMainScreenWidth, 100)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];

    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:layout];
    
    [colView setDelegate:self];
    [colView setDataSource:self];
    [colView setAlwaysBounceVertical:YES];
    [colView setBackgroundColor:[UIColor clearColor]];
    
    [self setM_ColView:colView];
    [self addSubview:colView];
    
    // UICollectionViewCell 注册 否则会报错
    [colView registerClass:[CourseColViewCell class] forCellWithReuseIdentifier:kCourseColViewCellId];
    [colView registerClass:[TeachersColViewCell class] forCellWithReuseIdentifier:kTeachersColViewCellId];
    [colView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ColCellId"];
    
    [colView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        
    }];
    
    WeakObj(self);
    
    // 下拉刷新
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
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = 0;
    
    switch (g_ColType) {
        case CalabashColType_NewCourse:
            
        case CalabashColType_AllCourse:{
            
            count = [m_CourseColArray count];
            
            break;}
        case CalabashColType_Teachers:{
            
            count = [m_TeachersColArray count];
            
            break;}
        default:
            break;
    }
    
    return count;
    
}

// 同一行的 cell 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}

// 上下行 cell 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger row = [indexPath row];
    
    UICollectionViewCell *rCell;
    
    switch (g_ColType) {
        case CalabashColType_NewCourse:

        case CalabashColType_AllCourse:{
            
            CourseModel *model;
            OBJECTOFARRAYATINDEX(model, m_CourseColArray, row);
            
            CourseColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseColViewCellId
                                                                                forIndexPath:indexPath];
            
            [cell setM_Delegate:self];
            [cell setCourseColCellUpDataSource:model cellForRowAtIndexPath:indexPath];
            
            rCell = cell;
            
            break;}
        case CalabashColType_Teachers:{
            
            TeacherModel *model;
            OBJECTOFARRAYATINDEX(model, m_TeachersColArray, row);
            
            TeachersColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTeachersColViewCellId
                                                                                  forIndexPath:indexPath];
            
            [cell setM_Delegate:self];
            [cell setTeachersColCellUpDataSource:model cellForRowAtIndexPath:indexPath];
            
            rCell = cell;
            
            break;}
        default:{
            
            static  NSString * colCellId = @"ColCellId";
            
            rCell = [collectionView dequeueReusableCellWithReuseIdentifier:colCellId
                                                              forIndexPath:indexPath];
            
            [rCell setBackgroundColor:[UIColor whiteColor]];
            
            break;}
    }
    
    return rCell;
    
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSObject *object;
    NSInteger row = [indexPath row];
    
    switch (g_ColType) {
        case CalabashColType_NewCourse:
            
        case CalabashColType_AllCourse:{
            
            OBJECTOFARRAYATINDEX(object, m_CourseColArray, row);
            
            break;}
        case CalabashColType_Teachers:{
            
            OBJECTOFARRAYATINDEX(object, m_TeachersColArray, row);
            
            break;}
        default:
            break;
    }
    
    if (!IsNilOrNull(object)) {
    
        if (m_Delegate && [m_Delegate respondsToSelector:
                           @selector(onSelCalabashColViewWithColType:withDataSource:)]) {
            
            [m_Delegate onSelCalabashColViewWithColType:g_ColType withDataSource:object];
            
        }
        
    }

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark - 下拉刷新数据
- (void)loadNewData{
    
    g_Page = Request_Page;
    
    // 马上进入刷新状态
    [m_ColView.mj_header beginRefreshing];
    
    [self accessDataSourceWithColType:g_ColType
                     withLoadDataType:LoadDataType_New
                             withPage:g_Page
                         withpageSize:g_PageSize];
    
}

#pragma mark - 上拉加载更多数据
- (void)loadMoreData{
    
    g_Page += Request_PageSize;
    
    [self accessDataSourceWithColType:g_ColType
                     withLoadDataType:LoadDataType_More
                             withPage:g_Page
                         withpageSize:g_PageSize];
    
}

#pragma mark - 获取数据源
- (void)accessDataSourceWithColType:(CalabashColType)colType withLoadDataType:(LoadDataType)type
                           withPage:(NSInteger)page withpageSize:(NSInteger)pageSize{
    
    if (colType == CalabashColType_NewCourse || colType == CalabashColType_AllCourse) {
        
        CourseListParam *param = [[CourseListParam alloc] init];
        
        [param setStart_page:page];
        [param setPages:pageSize];
        [param setTitle:g_SearchKey];
        [param setNow_type:(colType == CalabashColType_NewCourse ? CourseType_New : CourseType_All)];
        
        [self obtainMostPopularCoursesListWithParam:param withLoadDataType:type];
        
    }else if (colType == CalabashColType_Teachers){
    
        TeachersListParam *param = [[TeachersListParam alloc] init];
        
        [param setStart_page:page];
        [param setPages:pageSize];
        
        [self obtainPopularTeacherListWithParam:param withLoadDataType:type];
        
    }else{
        
        
        
    }
    
}

#pragma mark - Public Functions
- (void)dataInitialization{

    g_Page = Request_Page;
    g_PageSize = Request_PageSize;
    
    g_SearchKey = nil;
    g_ColType = CalabashColType_Unknown;
    
    if (IsNilOrNull(m_CourseColArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [self setM_CourseColArray:tmpArray];
        
    }
    
    if (IsNilOrNull(m_TeachersColArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [self setM_TeachersColArray:tmpArray];
        
    }
    
}

- (void)setCalabashColViewType:(CalabashColType)colType{

    g_ColType = colType;
    
    [self accessDataSourceWithColType:colType
                     withLoadDataType:LoadDataType_Default
                             withPage:g_Page
                         withpageSize:g_PageSize];
    
}

- (void)setCalabashColViewType:(CalabashColType)colType withSearchKey:(NSString *)key{

    g_ColType = colType;
    g_SearchKey = key;
    
    [self accessDataSourceWithColType:colType
                     withLoadDataType:LoadDataType_Default
                             withPage:g_Page
                         withpageSize:g_PageSize];
    
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

#pragma mark - Button Handler

#pragma mark - NetworkRequest Manager
- (void)obtainMostPopularCoursesListWithParam:(CourseListParam *)param
                             withLoadDataType:(LoadDataType)type{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [CalabashRequest obtainMostPopularCoursesListWithParam:param success:^(CalabashCourseResponse *response) {
        
        NSInteger currentTotalNum = [response.data.list count];
        NSInteger totalNum = response.data.total_pages;
        
        if (response.success) {
            
            if (type == LoadDataType_More) {
                
                currentTotalNum += [m_CourseColArray count];
                
                [m_CourseColArray addObjectsFromArray:response.data.list];
                
            }else{
                
                if (!IsArrEmpty(m_CourseColArray)) [m_CourseColArray removeAllObjects];
                
                [m_CourseColArray addObjectsFromArray:response.data.list];
                
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

- (void)obtainPopularTeacherListWithParam:(TeachersListParam *)param
                         withLoadDataType:(LoadDataType)type{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [CalabashRequest obtainPopularTeacherListWithParam:param success:^(CalabashTeachersResponse *response) {
        
        NSInteger currentTotalNum = [response.data.list count];
        NSInteger totalNum = response.data.total_pages;
        
        if (response.success) {
            
            if (type == LoadDataType_More) {
                
                currentTotalNum += [m_TeachersColArray count];
                
                [m_TeachersColArray addObjectsFromArray:response.data.list];
                
            }else{
                
                if (!IsArrEmpty(m_TeachersColArray)) [m_TeachersColArray removeAllObjects];
                
                [m_TeachersColArray addObjectsFromArray:response.data.list];
                
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
