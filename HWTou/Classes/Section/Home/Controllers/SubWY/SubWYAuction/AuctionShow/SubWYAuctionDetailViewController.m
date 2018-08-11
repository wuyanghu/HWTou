//
//  SubWYAuctionDetailViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SubWYAuctionDetailViewController.h"
#import "AuctionCommodityRollTableViewCell.h"
#import "AuctionCommodityDetailTableViewCell.h"
#import "SubWYAuctionMarginViewController.h"
#import "PublicHeader.h"
#import "ShopMallRequest.h"
#import "GetBidSellerRecordModel.h"
#import "AuctionCommodityRecordTableViewCell.h"
#import "AuctionRecordViewController.h"
#import "UINavigationItem+Margin.h"
#import "ComFloorEvent.h"
#import "AuctionCustomPriceView.h"
#import "UIView+NTES.h"
#import "BaseModel+Category.h"

@interface SubWYAuctionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,AuctionCommodityCellProtocol,AuctionCustomPriceViewDelegate>
{
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *marginFooterView;//缴纳保证金
@property (weak, nonatomic) IBOutlet UIButton *marginBtn;

@property (weak, nonatomic) IBOutlet UIView *applyFinishView;//报名已结束
@property (weak, nonatomic) IBOutlet UIButton *applyFinishBtn;

@property (weak, nonatomic) IBOutlet UIView *showACardFooterView;//举牌
@property (weak, nonatomic) IBOutlet UILabel *showAcardPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *activityFinishView;//活动已结束

@property (nonatomic,strong) NSMutableArray <GetBidSellerRecordModel *> * recoreArr;

@property (nonatomic,strong) AuctionCustomPriceView * auctionCustomPriceView;
@end

@implementation SubWYAuctionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"商品详情"];
    
    UIBarButtonItem *itemShare = [UIBarButtonItem itemWithImageName:@"navi_share_nor" hltImageName:nil target:self action:@selector(actionShare)];
    [self.navigationItem addRightBarButtonItem:itemShare fixedSpace:10];
    
    UIBarButtonItem *itemRule = [UIBarButtonItem itemWithImageName:@"rule" hltImageName:nil target:self action:@selector(actionRule)];
    [self.navigationItem addRightBarButtonItem:itemRule fixedSpace:10];
    
    [self dataInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self keepTime];
    [self requestGetSellerPerformGoods];
    [self requestGetBidSellerRecord];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTime];
}

- (void)dataInit{
    self.view.backgroundColor = UIColorFromRGB(0xF3F4F6);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AuctionCommodityRollTableViewCell" bundle:nil]
         forCellReuseIdentifier:[AuctionCommodityRollTableViewCell cellReuseIdentifierInfo]];
    [self.tableView registerNib:[UINib nibWithNibName:@"AuctionCommodityDetailTableViewCell" bundle:nil]
         forCellReuseIdentifier:[AuctionCommodityDetailTableViewCell cellReuseIdentifierInfo]];
    [self.tableView registerNib:[UINib nibWithNibName:@"AuctionCommodityRecordTableViewCell" bundle:nil]
         forCellReuseIdentifier:[AuctionCommodityRecordTableViewCell cellReuseIdentifierInfo]];
    
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setFootViewState];
    [self refreshFootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private mothed

- (void)actionShare{
    FloorItemDM * itemDM = [FloorItemDM new];
    itemDM.type = FloorEventParam;
    itemDM.title = @"拍卖分享";
    itemDM.param = @"https://baidu.com";
    [ComFloorEvent handleEventWithFloor:itemDM];
}

- (void)actionRule{
    FloorItemDM * itemDM = [FloorItemDM new];
    itemDM.type = FloorEventParam;
    itemDM.title = @"拍卖规则";
    itemDM.param = @"https://baidu.com";
    [ComFloorEvent handleEventWithFloor:itemDM];
}

- (void)refreshCountTime{
    NSInteger countTime = _performGoodsListModel.time/1000;
    NSString * countTimeStr = [_performGoodsListModel getCountDownTime:countTime];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        AuctionCommodityRollTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (_performGoodsListModel.acStatus == 1) {
            [cell setCountTimeStr:[NSString stringWithFormat:@"距离拍卖竞价开始%@",countTimeStr]];
        }
        if (_performGoodsListModel.status == 1) {
            [cell setCountTimeStr:[NSString stringWithFormat:@"距离拍卖竞价结束%@",countTimeStr]];
        }
        if (_performGoodsListModel.status == 2) {
            [cell setCountTimeStr:@"已结束"];
        }
    });
}

- (void)setFootViewState{
    BOOL isMargin = !(_performGoodsListModel.acStatus == 1 && _goodsListModel.isPayProve == 0) || !(_performGoodsListModel.status == 1  && _goodsListModel.isPayProve == 0);
    self.marginFooterView.hidden = isMargin;//报名进行中，未缴纳保证金;//活动进行中，未缴纳保证金

    self.applyFinishView.hidden = (_performGoodsListModel.acStatus == 2 && _goodsListModel.isPayProve == 0);//报名已结束，未缴纳保证金
    
    self.showACardFooterView.hidden = !(_performGoodsListModel.status == 1 && _goodsListModel.isPayProve == 1);//活动进行中，缴纳保证金
    
    self.activityFinishView.hidden = !(_performGoodsListModel.status == 2);//活动已结束
   
}

- (void)refreshFootView{
    if ([_goodsListModel.currentBidMoney doubleValue] == 0) {
        self.showAcardPriceLabel.text = [NSString stringWithFormat:@"当前报价%@",_goodsListModel.actualMoney];
    }else{
        self.showAcardPriceLabel.text = [NSString stringWithFormat:@"当前报价%@",_goodsListModel.currentBidMoney];
    }
}


#pragma mark - request
- (void)requestGetSellerPerformGoods{
    GetSellerPerformGoodsParam * param = [GetSellerPerformGoodsParam new];
    param.acvId = _performGoodsListModel.acvId;
    param.performId = _performGoodsListModel.performId;
    param.sellerGoodsId = _goodsListModel.goodsId;
    [ShopMallRequest getSellerPerformGoods:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [_performGoodsListModel setValuesForKeysWithDictionary:response.data];
            NSArray * goodsListArr = response.data[@"goodsList"];
            if (goodsListArr.count>0) {
                [_goodsListModel setValuesForKeysWithDictionary:goodsListArr[0]];
            }
            
            [self setFootViewState];
            [self refreshFootView];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestBidSellerGoods:(NSInteger)flag bidMoney:(NSString *)bidMoney{
    BidSellerGoodsParam * param = [BidSellerGoodsParam new];
    param.sellerGoodsId = _goodsListModel.goodsId;
    param.acvId = _performGoodsListModel.acvId;
    param.performId = _performGoodsListModel.performId;
    param.sellerId = _goodsListModel.sellerId;
    param.flag = flag;
    param.bidMoney = bidMoney;
    [ShopMallRequest bidSellerGoods:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self.view makeToast:@"竞价成功" duration:2.0f position:CSToastPositionCenter];
            [self requestGetSellerPerformGoods];
            [self requestGetBidSellerRecord];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
    
}

- (void)requestGetBidSellerRecord{
    GetBidSellerRecordParam * param = [GetBidSellerRecordParam new];
    param.acvId = _performGoodsListModel.acvId;
    param.sellerGoodsId = _goodsListModel.goodsId;
    param.page = 1;
    param.pagesize = 20;
    
    [ShopMallRequest getBidSellerRecord:param Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            [self.recoreArr removeAllObjects];
            for (NSDictionary * dict in response.data) {
                GetBidSellerRecordModel * model = [GetBidSellerRecordModel new];
                [model setValuesForKeysWithDictionary:dict];
                
                [self.recoreArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - timer

- (void)keepTime{
    WeakObj(self);
    
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        _performGoodsListModel.time -= 1000;
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

#pragma mark - delegate
- (void)recordAction{
    AuctionRecordViewController * recordVC = [[AuctionRecordViewController alloc] init];
    recordVC.goodsListModel = _goodsListModel;
    recordVC.performGoodsListModel = _performGoodsListModel;
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)auctionCustomPriceViewAction:(NSString *)price{
    [self requestBidSellerGoods:1 bidMoney:price];
}

#pragma mark - action
//缴纳保证金
- (IBAction)marginAction:(id)sender {
    SubWYAuctionMarginViewController * marginVC = [[SubWYAuctionMarginViewController alloc] initWithNibName:nil bundle:nil];
    marginVC.goodsListModel = _goodsListModel;
    marginVC.performGoodsListModel = _performGoodsListModel;
    [self.navigationController pushViewController:marginVC animated:YES];
}

- (IBAction)showACardAction:(id)sender {
    GetSellerPerformGoodsParam * param = [GetSellerPerformGoodsParam new];
    param.acvId = _performGoodsListModel.acvId;
    param.performId = _performGoodsListModel.performId;
    param.sellerGoodsId = _goodsListModel.goodsId;
    [ShopMallRequest getSellerPerformGoods:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [_performGoodsListModel setValuesForKeysWithDictionary:response.data];
            NSArray * goodsListArr = response.data[@"goodsList"];
            if (goodsListArr.count>0) {
                [_goodsListModel setValuesForKeysWithDictionary:goodsListArr[0]];
            }
            
            NSString * currentBidMoney = [_goodsListModel getCurrentPrice];
            WeakObj(self);
            NSString * message = [NSString stringWithFormat:@"当前最高出价为%@元,您的出价为%.2f元",currentBidMoney,[currentBidMoney doubleValue]+[_goodsListModel.courierMoney doubleValue]];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * _okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                [selfWeak requestBidSellerGoods:2 bidMoney:_goodsListModel.courierMoney];
            }];
            UIAlertAction * _cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:_okAction];
            [alert addAction:_cancelAction];
            // 弹出对话框
            [self presentViewController:alert animated:true completion:nil];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)customPriceAction:(id)sender {
    GetSellerPerformGoodsParam * param = [GetSellerPerformGoodsParam new];
    param.acvId = _performGoodsListModel.acvId;
    param.performId = _performGoodsListModel.performId;
    param.sellerGoodsId = _goodsListModel.goodsId;
    [ShopMallRequest getSellerPerformGoods:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [_performGoodsListModel setValuesForKeysWithDictionary:response.data];
            NSArray * goodsListArr = response.data[@"goodsList"];
            if (goodsListArr.count>0) {
                [_goodsListModel setValuesForKeysWithDictionary:goodsListArr[0]];
            }
            [self.auctionCustomPriceView show:_goodsListModel];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.recoreArr.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AuctionCommodityRollTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[AuctionCommodityRollTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        [cell setBannerUrl:_goodsListModel.bannerUrl];
        return cell;
    }else if (indexPath.section == 1){
        AuctionCommodityDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[AuctionCommodityDetailTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        cell.delegate = self;
        [cell setGoodsListModel:_goodsListModel];
        [cell setPerformGoodsListModel:_performGoodsListModel];
        if (self.recoreArr.count == 0) {
            [cell setRecordCount:0];
        }else{
            GetBidSellerRecordModel * recordModel = self.recoreArr[0];
            [cell setRecordCount:recordModel.totalCount];
        }
        
        return cell;
    }else{
        AuctionCommodityRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[AuctionCommodityRecordTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        [cell setRecordModel:self.recoreArr[indexPath.row]];
        return cell;
    }

    return nil;
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
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = UIColorFromRGB(0xF3F4F6);
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 438;
    }else if (indexPath.section == 1) {
        return 326;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - getter

- (AuctionCustomPriceView *)auctionCustomPriceView{
    if (!_auctionCustomPriceView) {
        _auctionCustomPriceView = [[[NSBundle mainBundle] loadNibNamed:@"AuctionCustomPriceView" owner:self options:nil] lastObject];
        _auctionCustomPriceView.frame = CGRectMake(0, UIScreenHeight, self.view.ntesWidth, UIScreenHeight);
        _auctionCustomPriceView.delegate = self;
    }
    return _auctionCustomPriceView;
}

- (NSMutableArray<GetBidSellerRecordModel *> *)recoreArr{
    if (!_recoreArr) {
        _recoreArr = [[NSMutableArray alloc] init];
    }
    return _recoreArr;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
