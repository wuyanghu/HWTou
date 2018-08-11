//
//  ProductSearchViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/6/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductSearchViewController.h"
#import "ProductListView.h"
#import "ProductListReq.h"
#import "PublicHeader.h"

@interface ProductSearchViewController ()

@property (nonatomic, strong) ProductListView *vProductList;

@end

@implementation ProductSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.title = @"商品搜索";
    self.vProductList = [[ProductListView alloc] init];
    [self.view addSubview:self.vProductList];
    
    [self.vProductList makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadListData:YES];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vProductList.collectionView.mj_header = header;
    [self.vProductList.collectionView.mj_header beginRefreshing];
}

- (void)loadListData:(BOOL)refresh
{
    ProductSearchParam *param = [[ProductSearchParam alloc] init];
    param.keywords = self.keywords;
    param.start_page = refresh ? 0 : self.vProductList.listData.count;
    param.pages = 20;
    
    [ProductListReq searchWithParam:param success:^(ProductListResp *response) {
        if (refresh) {
            self.vProductList.listData = response.data.list;
        } else {
            NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vProductList.listData];
            [tempData addObjectsFromArray:response.data.list];
            self.vProductList.listData = tempData;
        }
        
        BOOL isMore = self.vProductList.listData.count < response.data.total_pages ? YES : NO;
        [self setLoadMore:isMore];
        [self handleLoadCompleted];
        
        if (refresh && response.data.list.count == 0) {
            [HUDProgressTool showOnlyText:@"未搜索到内容，换个关键词试试"];
        }
    } failure:^(NSError *error) {
        [self handleLoadCompleted];
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vProductList.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadListData:NO];
        }];
    } else {
        self.vProductList.collectionView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    [self.vProductList.collectionView.mj_header endRefreshing];
    [self.vProductList.collectionView.mj_footer endRefreshing];
}

@end
