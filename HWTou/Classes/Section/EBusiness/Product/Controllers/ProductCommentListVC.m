//
//  ProductCommentListVC.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCommentListView.h"
#import "ProductCommentListVC.h"
#import "ProductCommentReq.h"
#import "PublicHeader.h"
#import "VTMagic.h"

typedef void(^CommentNumberBolck)(NSInteger type, NSInteger num);

@interface CommentListConentVC : BaseViewController

@property (nonatomic, strong) ProductDetailDM *dmProduct;
@property (nonatomic, strong) ProductCommentListView *vComment;
@property (nonatomic, assign) NSInteger listType; // 2:全部 1:带图片

@property (nonatomic, copy) CommentNumberBolck blockNumber;

@end

@implementation CommentListConentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadListData:YES];
}

- (void)createUI
{
    self.vComment = [[ProductCommentListView alloc] init];
    [self.view addSubview:self.vComment];
    [self.vComment makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadListData:YES];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vComment.tableView.mj_header = header;
    [self.vComment.tableView.mj_header beginRefreshing];
}

- (void)loadListData:(BOOL)refresh
{
    CommentListParam *param = [CommentListParam new];
    param.item_id = self.dmProduct.item_id;
    param.start_page = refresh ? 0 : self.vComment.listData.count;
    param.pages = 20;
    param.flag = self.listType;
    
    [ProductCommentReq listWithParam:param success:^(CommentListResp *response) {
        if (response.success) {
            if (refresh) {
                !self.blockNumber ?: self.blockNumber(self.listType, response.data.total_pages);
                self.vComment.listData = response.data.list;
            } else {
                NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vComment.listData];
                [tempData addObjectsFromArray:response.data.list];
                self.vComment.listData = tempData;
            }
            
            BOOL isMore = self.vComment.listData.count < response.data.total_pages ? YES : NO;
            [self setLoadMore:isMore];
            [self handleLoadCompleted];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vComment.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadListData:NO];
        }];
    } else {
        self.vComment.tableView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    [self.vComment.tableView.mj_header endRefreshing];
    [self.vComment.tableView.mj_footer endRefreshing];
}
@end

@interface ProductCommentListVC ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;

@property (nonatomic, assign) NSInteger numAll;
@property (nonatomic, assign) NSInteger numImg;

@end

@implementation ProductCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.title = @"评价";
    [self.view addSubview:self.magicController.magicView];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];
}

- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = CoordXSizeScale(30);
        _magicController.magicView.navigationHeight = 32;
        _magicController.magicView.itemWidth = kMainScreenWidth/2;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSArray *)listTitle
{
    NSString *strAll = [NSString stringWithFormat:@"全部(%zd)", self.numAll];
    NSString *strImg = [NSString stringWithFormat:@"有图(%zd)", self.numImg];
    return @[strAll, strImg];
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.listTitle;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [menuItem setTitleColor:UIColorFromHex(0xb4292d) forState:UIControlStateSelected];
        menuItem.titleLabel.font = FontPFRegular(14.0f);
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString *recomIdAll = @"identifier.all";
    static NSString *recomIdImg = @"ridenifier.image";
    
    CommentListConentVC *contentVC = nil;
    if (pageIndex == 0) {
         contentVC = [magicView dequeueReusablePageWithIdentifier:recomIdAll];
    } else {
        contentVC = [magicView dequeueReusablePageWithIdentifier:recomIdImg];
    }
    
    if (!contentVC) {
        contentVC = [[CommentListConentVC alloc] init];
        WeakObj(self);
        contentVC.blockNumber = ^(NSInteger type, NSInteger num) {
            if (type == 1) {
                selfWeak.numImg = num;
            } else {
                selfWeak.numAll = num;
            }
            [self.magicController.magicView reloadMenuTitles];
        };
    }
    contentVC.dmProduct = self.dmProduct;
    if (pageIndex == 0) {
        contentVC.listType = 2;
    } else {
        contentVC.listType = 1;
    }
    return contentVC;
}

@end

