//
//  MyCollectiontableView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MyCollectionColView.h"

#import "PublicHeader.h"

#import "ProductCollectReq.h"
#import "ActivityCollectReq.h"
#import "ActivityNewsCollectReq.h"
#import "ProductDetailViewController.h"
#import "ActivityDetailViewController.h"

#import "ProductEnjoyCell.h"
#import "ActivityListCell.h"
#import "ActivityContentCell.h"

@interface MyCollectionColView()<UITableViewDataSource, UITableViewDelegate>{
    
    NSInteger g_Page;
    NSInteger g_PageSize;
    
    CollectionColType g_ColType;
    
}

@property (nonatomic, strong) UITableView *m_TableView;
@property (nonatomic, strong) NSMutableArray *m_CollectArray;

@end

@implementation MyCollectionColView
@synthesize m_Delegate;

@synthesize m_TableView;
@synthesize m_CollectArray;

static  NSString * const kCellIdentifier = @"CellIdentifier";

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
    
    [self addTableView];
    
}

- (void)addTableView{
    
    UITableView *tableView = [BasisUITool getTableViewWithFrame:CGRectZero
                                                          style:UITableViewStylePlain
                                                       delegate:self
                                                     dataSource:self
                                                  scrollEnabled:YES
                                                 separatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self setM_TableView:tableView];
    [self addSubview:tableView];
    
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        
    }];

    // 下拉刷新
    
    WeakObj(self);
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [selfWeak loadNewData];
        
    }];
    
    [header.lastUpdatedTimeLabel setHidden:YES];
    
    tableView.mj_header = header;

    // 上拉加载更多
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [selfWeak loadMoreData];
        
    }];
    
    [tableView.mj_footer setHidden:YES];
    
}

#pragma mark - UITableViewDataSource Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return g_ColType == CollectionColType_ActivityNews ? [m_CollectArray count] : 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return g_ColType == CollectionColType_ActivityNews ? 1 : [m_CollectArray count];
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    
    return g_ColType == CollectionColType_ActivityNews ? 10 : 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [self createTableSectionFooterView];
    
    return footerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];

    switch (g_ColType) {
        case CollectionColType_SpendMoney:{ // list<ProductCollectDM>
            
            ProductCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

            [cell setCollectProduct:m_CollectArray[row]];
            
            return cell;
            
            break;}
        case CollectionColType_ActivityNews:{// list<ActivityNewsCollectDM>
            
            ActivityContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            
            [cell setDmNews:m_CollectArray[section]];
            
            return cell;
            
            break;}
        case CollectionColType_Activity:{// list<ActivityCollectDM>
            
            ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            
            [cell setDmList:m_CollectArray[row]];
            
            return cell;
            
            break;}
        default:{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            
            return cell;
            
            break;}
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (g_ColType) {
        case CollectionColType_SpendMoney:{ // list<ProductCollectDM>
            
            ProductCollectDM *model;
            OBJECTOFARRAYATINDEX(model, m_CollectArray, row);
            ProductDetailViewController *viewController = [[ProductDetailViewController alloc] init];
            viewController.dmProduct = model;
            [[UIApplication topViewController].navigationController pushViewController:viewController animated:YES];
            
            break;}
        case CollectionColType_ActivityNews:{// list<ActivityNewsCollectDM>
            
            ActivityNewsCollectDM *model;
            OBJECTOFARRAYATINDEX(model, m_CollectArray, section);
            
            ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc] init];
            detailVC.dmNews = model;
            detailVC.type = ActivityDetailNews;
            [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
            
            break;}
        case CollectionColType_Activity:{// list<ActivityCollectDM>
            
            ActivityCollectDM *model;
            OBJECTOFARRAYATINDEX(model, m_CollectArray, row);
            [self handleWebLink:model.link];
            
            ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc] init];
            detailVC.dmActivity = model;
            [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
            break;}
        default:{
            break;}
    }
    
}

// web链接跳转
- (void)handleWebLink:(NSString *)link{
    
    
    
}

// 滑动删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath
                       :(NSIndexPath *)indexPath{
    
    return @"删 除";
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        [self cancelCollect:g_ColType didSelectItemAtIndexPath:indexPath];

    }
    
}

#pragma mark - 下拉刷新数据
- (void)loadNewData{
    
    g_Page = Request_Page;
    
    // 马上进入刷新状态
    [m_TableView.mj_header beginRefreshing];
    
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
- (void)accessDataSourceWithColType:(CollectionColType)colType withLoadDataType:(LoadDataType)type
                           withPage:(NSInteger)page withpageSize:(NSInteger)pageSize{

    switch (colType) {
        case CollectionColType_SpendMoney:{

            ProductCollectListParam *param = [[ProductCollectListParam alloc] init];
            
            [param setStart_page:page];
            [param setPages:pageSize];
            
            [self obtainMyProductCollectionList:param withLoadDataType:type];
            
            break;}
        case CollectionColType_ActivityNews:{

            ActivityNewsCollectListParam *param = [[ActivityNewsCollectListParam alloc] init];
            
            [param setStart_page:page];
            [param setPages:pageSize];
            
            [self obtainMyActivityNewsCollectListWithParam:param withLoadDataType:type];
            
            break;}
        case CollectionColType_Activity:{
            
            ActivityCollectListParam *param = [[ActivityCollectListParam alloc] init];
            
            [param setStart_page:page];
            [param setPages:pageSize];
            
            [self obtainMyActivityCollectListWithParam:param withLoadDataType:type];
            
            break;}
        default:
            break;
    }
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    g_Page = Request_Page;
    g_PageSize = Request_PageSize;
    
    g_ColType = CollectionColType_Unknown;
    
    if (IsNilOrNull(m_CollectArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [self setM_CollectArray:tmpArray];
        
    }
    
}

- (void)setMyCollectionColViewType:(CollectionColType)colType{
    
    g_ColType = colType;
    
    switch (colType) {
        case CollectionColType_SpendMoney:{
            
            [m_TableView setRowHeight:CoordXSizeScale(100)];
            
            // 产品(花钱)
            [m_TableView registerClass:[ProductCollectCell class] forCellReuseIdentifier:kCellIdentifier];
            
            break;}
        case CollectionColType_ActivityNews:{
            
            [m_TableView setRowHeight:(0.35 * kMainScreenWidth)];
            
            // 活动新闻（内容）
            [m_TableView registerClass:[ActivityContentCell class] forCellReuseIdentifier:kCellIdentifier];
            
            break;}
        case CollectionColType_Activity:{
            
            [m_TableView setRowHeight:(0.5 * kMainScreenWidth)];
            
            // 活动
            [m_TableView registerClass:[ActivityListCell class] forCellReuseIdentifier:kCellIdentifier];
            
            break;}
        default:{
            
            [m_TableView setRowHeight:CoordXSizeScale(100)];
            
            [m_TableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
            
            break;}
    }
    
    [self accessDataSourceWithColType:colType
                     withLoadDataType:LoadDataType_Default
                             withPage:g_Page
                         withpageSize:g_PageSize];
    
}

- (void)cancelCollect:(CollectionColType)colType didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    switch (colType) {
        case CollectionColType_SpendMoney:{// list<ProductCollectDM>
            
            ProductCollectDM *model;
            OBJECTOFARRAYATINDEX(model, m_CollectArray, row);
            
            ProductCollectParam *param = [[ProductCollectParam alloc] init];
            
            [param setItem_id:model.item_id];
            
            [self cancelProductCollection:param didSelectItemAtIndexPath:indexPath];
            
            break;}
        case CollectionColType_ActivityNews:{// list<ActivityNewsCollectDM>
            
            ActivityNewsCollectDM *model;
            OBJECTOFARRAYATINDEX(model, m_CollectArray, section);
            
            ActivityNewsCollectParam *param = [[ActivityNewsCollectParam alloc] init];
            
            [param setNews_id:model.ncid];
            
            [self cancelActivityNewsCollectWithParam:param didSelectItemAtIndexPath:indexPath];
            
            break;}
        case CollectionColType_Activity:{// list<ActivityCollectDM>
            
            ActivityCollectDM *model;
            OBJECTOFARRAYATINDEX(model, m_CollectArray, row);
            
            ActivityCollectParam *param = [[ActivityCollectParam alloc] init];
            
            [param setAct_id:model.acid];
            
            [self cancelActivityCollectWithParam:param didSelectItemAtIndexPath:indexPath];
            
            break;}
        default:
            break;
    }
    
}

- (void)endRefreshing:(LoadDataType)loadDataType{
    
    switch (loadDataType) {
        case LoadDataType_New:
            [m_TableView.mj_header endRefreshing];
            break;
        case LoadDataType_More:
            [m_TableView.mj_footer endRefreshing];
            break;
        default:{
            break;}
    }
    
}

// 是否有更多数据 MJ处理
- (void)moreDataWithCurrentTotalNum:(NSInteger)currentTotalNum withTotalNum:(NSInteger)totalNum{
    
    if (currentTotalNum < totalNum) {
        
        [m_TableView.mj_footer setHidden:NO];
        
    }else{
        
        [m_TableView.mj_footer endRefreshingWithNoMoreData];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            
            // 隐藏当前的上拉刷新控件
            [m_TableView.mj_footer setHidden:YES];
            
        });
        
    }
    
}

- (UIView *)createTableSectionFooterView{
    
    UIView *footerView = [[UIView alloc] init];
    
    return footerView;
    
}

#pragma mark - Button Handlers

#pragma mark - NetworkRequest Manager
// 获取用户收藏的商品列表
- (void)obtainMyProductCollectionList:(ProductCollectListParam *)param
                     withLoadDataType:(LoadDataType)type{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ProductCollectReq listWithParam:param success:^(CollectResp *response) {
        
        NSInteger currentTotalNum = [response.data.list count];
        NSInteger totalNum = response.data.total_pages;
        
        if (response.success) {
            
            if (type == LoadDataType_More) {
                
                currentTotalNum += [m_CollectArray count];
                
                [m_CollectArray addObjectsFromArray:response.data.list];
                
            }else{
                
                if (!IsArrEmpty(m_CollectArray)) [m_CollectArray removeAllObjects];
                
                [m_CollectArray addObjectsFromArray:response.data.list];
                
            }
            
            [m_TableView reloadData];
            
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

// 取消收藏的商品
- (void)cancelProductCollection:(ProductCollectParam *)param
       didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ProductCollectReq cancelWithParam:param success:^(BaseResponse *response) {

        if (response.success) {
            
            REMOVEOBJECTOFARRAYATINDEX(m_CollectArray, [indexPath row]);
            
            [UIView performWithoutAnimation:^{
                
                [m_TableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                   withRowAnimation:UITableViewRowAnimationFade];
                
            }];
            
            [HUDProgressTool showSuccessWithText:ReqSuccessful];
            
        }else{
        
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

// 获取用户收藏的活动新闻(内容)列表
- (void)obtainMyActivityNewsCollectListWithParam:(ActivityNewsCollectListParam *)param
                                withLoadDataType:(LoadDataType)type{

    [ActivityNewsCollectReq obtainActivityNewsCollectListWithParam:param success:^(ActivityNewsCollectResp *response) {
        
        NSInteger currentTotalNum = [response.data.list count];
        NSInteger totalNum = response.data.total_pages;
        
        if (response.success) {
            
            if (type == LoadDataType_More) {
                
                currentTotalNum += [m_CollectArray count];
                
                [m_CollectArray addObjectsFromArray:response.data.list];
                
            }else{
                
                if (!IsArrEmpty(m_CollectArray)) [m_CollectArray removeAllObjects];
                
                [m_CollectArray addObjectsFromArray:response.data.list];
                
            }
            
            [m_TableView reloadData];
            
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

// 取消收藏的活动新闻(内容)
- (void)cancelActivityNewsCollectWithParam:(ActivityNewsCollectParam *)param
                  didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ActivityNewsCollectReq cancelActivityNewsCollectWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {
            
            REMOVEOBJECTOFARRAYATINDEX(m_CollectArray, [indexPath row]);
            
            [UIView performWithoutAnimation:^{
                
                [m_TableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                   withRowAnimation:UITableViewRowAnimationFade];
                
            }];
            
            [HUDProgressTool showSuccessWithText:ReqSuccessful];
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

// 获取用户收藏的活动列表
- (void)obtainMyActivityCollectListWithParam:(ActivityCollectListParam *)param
                            withLoadDataType:(LoadDataType)type{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ActivityCollectReq obtainActivityCollectListWithParam:param success:^(ActivityCollectResp *response) {
        
        NSInteger currentTotalNum = [response.data.list count];
        NSInteger totalNum = response.data.total_pages;
        
        if (response.success) {
            
            if (type == LoadDataType_More) {
                
                currentTotalNum += [m_CollectArray count];
                
                [m_CollectArray addObjectsFromArray:response.data.list];
                
            }else{
                
                if (!IsArrEmpty(m_CollectArray)) [m_CollectArray removeAllObjects];
                
                [m_CollectArray addObjectsFromArray:response.data.list];
                
            }
            
            [m_TableView reloadData];
            
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

// 取消收藏的活动
- (void)cancelActivityCollectWithParam:(ActivityCollectParam *)param
                 didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ActivityCollectReq cancelActivityCollectWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {
            
            REMOVEOBJECTOFARRAYATINDEX(m_CollectArray, [indexPath row]);
            
            [UIView performWithoutAnimation:^{
                
                [m_TableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                   withRowAnimation:UITableViewRowAnimationFade];
                
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
