//
//  AuctionRecordViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionRecordViewController.h"
#import "AuctionCommodityRecordTableViewCell.h"
#import "ShopMallRequest.h"
#import "PublicHeader.h"

@interface AuctionRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    GetBidSellerRecordParam * recordParam;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray <GetBidSellerRecordModel *> * recoreArr;
@end

@implementation AuctionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"竞拍记录"];
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dataInit{
    self.view.backgroundColor = UIColorFromRGB(0xF3F4F6);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AuctionCommodityRecordTableViewCell" bundle:nil]
         forCellReuseIdentifier:[AuctionCommodityRecordTableViewCell cellReuseIdentifierInfo]];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestGetBidSellerRecord:NO];
    }];
    
    [self requestGetBidSellerRecord:YES];
}

#pragma mark - request
- (void)requestGetBidSellerRecord:(BOOL)isRefresh{
    if (!recordParam) {
        recordParam = [GetBidSellerRecordParam new];
        recordParam.pagesize = 20;
    }
    recordParam.acvId = _performGoodsListModel.acvId;
    recordParam.sellerGoodsId = _goodsListModel.goodsId;
    
    if (isRefresh) {
        recordParam.page = 1;
    }else{
        recordParam.page++;
    }
    
    [ShopMallRequest getBidSellerRecord:recordParam Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            if(isRefresh){
                [self.recoreArr removeAllObjects];
            }
            for (NSDictionary * dict in response.data) {
                GetBidSellerRecordModel * model = [GetBidSellerRecordModel new];
                [model setValuesForKeysWithDictionary:dict];
                
                [self.recoreArr addObject:model];
            }
            [self.tableView reloadData];
            if (isRefresh) {
                [self.tableView.mj_footer resetNoMoreData];
            }else{
                if (response.data.count<recordParam.pagesize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recoreArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AuctionCommodityRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[AuctionCommodityRecordTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    [cell setRecordModel:self.recoreArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - getter
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
