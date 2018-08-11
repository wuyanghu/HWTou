//
//  AuctionOrderStateViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionOrderStateViewController.h"
#import "PublicHeader.h"
#import "CommodityOrderTableViewCell.h"
#import "ShopMallRequest.h"
#import "GetMySellerListModel.h"
#import "CommodityOrderDetailHeader.h"
#import "PayWayViewController.h"
#import "CommodityOrderDetailCancelFooter.h"
#import "RedPacketRequest.h"
#import "GetMySellerListModel.h"
#import "AuctionOrderStateTableViewCell.h"
#import "AuctionOrderStateFooterView.h"
#import "BaseModel+Category.h"

@interface AuctionOrderStateViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    GetMySellerListParam * orderParam;
    dispatch_source_t _timer;
}
@property (nonatomic,strong) NSMutableArray<GetMySellerListModel *> * dataArray;
@property (nonatomic, strong) UITableView  *tableView;
@end

@implementation AuctionOrderStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_type == AuctionOrderStateTypeProceed) {
        [self setTitle:@"参拍中"];
    }else if (_type == AuctionOrderStateTypeNoGet){
        [self setTitle:@"未拍中"];
    }else if (_type == AuctionOrderStateTypeMargin){
        [self setTitle:@"我的保证金"];
    }
    
    self.view.backgroundColor = UIColorFromRGB(0xF3F4F6);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getGoodsListRequest:YES];
    if (_type == AuctionOrderStateTypeProceed) {
        [self keepTime];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_type == AuctionOrderStateTypeProceed){
        [self stopTime];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - timer

- (void)keepTime{
    WeakObj(self);
    
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        [selfWeak refreshCountTime];
    });
    dispatch_resume(_timer);
}

- (void)stopTime{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

-(void)pauseTimer{
    if(_timer){
        dispatch_suspend(_timer);
    }
}
-(void)resumeTimer{
    if(_timer){
        dispatch_resume(_timer);
    }
}

#pragma mark - private method

- (void)refreshCountTime{
    for (int i = 0;i<self.dataArray.count;i++) {
        GetMySellerListModel * sellerModel = self.dataArray[i];
        NSInteger countTime = sellerModel.time/1000;
        sellerModel.time -= 1000;
        NSString * countTimeStr = [sellerModel getCountDownTime:countTime];
        sellerModel.countTime = countTimeStr;
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - request

- (void)getGoodsListRequest:(BOOL)isRefresh{
    if (!orderParam) {
        orderParam = [GetMySellerListParam new];
        orderParam.pagesize = 20;
        if (_type == AuctionOrderStateTypeProceed) {
            orderParam.flag = 2;
        }else if (_type == AuctionOrderStateTypeNoGet){
            orderParam.flag = 3;
        }else if (_type == AuctionOrderStateTypeMargin){
            orderParam.flag = 1;
        }
        
    }
    if (isRefresh) {
        orderParam.page = 1;
    }else{
        orderParam.page++;
    }
    
    [ShopMallRequest getMySellerList:orderParam Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * dict in response.data) {
                GetMySellerListModel * model = [GetMySellerListModel new];
                [model setValuesForKeysWithDictionary:dict];
                
                [self.dataArray addObject:model];
                
            }
            [self.tableView reloadData];
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }else{
                if (response.data.count<orderParam.pagesize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
    
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AuctionOrderStateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[AuctionOrderStateTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    GetMySellerListModel * orderListModel = self.dataArray[indexPath.section];
    [cell setType:_type];
    [cell setGetMySellerListModel:orderListModel];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_type == AuctionOrderStateTypeMargin) {
        return 90;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CommodityOrderDetailHeader *cartView = (CommodityOrderDetailHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[CommodityOrderDetailHeader cellIdentity]];
    GetMySellerListModel * listModel = self.dataArray[section];
    cartView.titleLabel.text = [NSString stringWithFormat:@"商家:%@",listModel.sellerName];
    return cartView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    GetMySellerListModel * listModel = self.dataArray[section];
    if (_type == AuctionOrderStateTypeMargin) {
        AuctionOrderStateFooterView *cartView = (AuctionOrderStateFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[AuctionOrderStateFooterView cellIdentity]];
        [cartView setListModel:listModel];
        return cartView;
    }
    
    CommodityOrderDetailCancelFooter *cartView = (CommodityOrderDetailCancelFooter *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[CommodityOrderDetailCancelFooter cellIdentity]];
    if (_type == AuctionOrderStateTypeProceed) {
        cartView.titleLabel.text = [NSString stringWithFormat:@"距离拍卖结束:%@",listModel.countTime];
    }else if (_type == AuctionOrderStateTypeNoGet){
        cartView.titleLabel.text = @"您未拍中该商品，您缴纳的保证金将被退回";
    }
    return cartView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetMySellerListModel * listModel = self.dataArray[indexPath.section];
//    [self.delegate orderPushDetailVC:listModel];
}

#pragma mark - load

- (void)loadHeaderData{
    
}

- (void)loadFooterData{
    
}

#pragma mark - getter

- (NSMutableArray<GetMySellerListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStyleGrouped delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleNone];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"AuctionOrderStateTableViewCell" bundle:nil]
             forCellReuseIdentifier:[AuctionOrderStateTableViewCell cellReuseIdentifierInfo]];
        [_tableView registerNib:[UINib nibWithNibName:@"CommodityOrderDetailHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:[CommodityOrderDetailHeader cellIdentity]];
        [_tableView registerNib:[UINib nibWithNibName:@"CommodityOrderDetailCancelFooter" bundle:nil] forHeaderFooterViewReuseIdentifier:[CommodityOrderDetailCancelFooter cellIdentity]];
        [_tableView registerNib:[UINib nibWithNibName:@"AuctionOrderStateFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:[AuctionOrderStateFooterView cellIdentity]];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getGoodsListRequest:NO];
        }];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getGoodsListRequest:YES];
        }];
    }
    return _tableView;
}

@end
