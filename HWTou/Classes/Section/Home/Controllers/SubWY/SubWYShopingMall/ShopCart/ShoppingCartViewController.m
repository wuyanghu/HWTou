//
//  ShoppingCartViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShopCartTableViewCell.h"
#import "ShoppingCartSettleViewController.h"
#import "UIView+NTES.h"
#import "ShopMallRequest.h"
#import "GetShopCartListModel.h"
#import "ShoppingCartHeaderView.h"
#import "GetGoodsAddrListModel.h"
#import "AddAddressViewController.h"
#import "PublicHeader.h"

@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCartTableViewCellDelegate,AddAddressViewControllerDelegate>
{
    GetShopCartListParam * getShopCartListParam;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *settleLabel;

@property (nonatomic,strong) NSMutableArray<GetShopCartListModel *> * dataArray;

@property (nonatomic,strong) NSMutableArray<GetShopCartListModel *> * shopCartDataArray;

@property (nonatomic,strong) GetGoodsAddrListModel * defaultAddrModel;
@end

@implementation ShoppingCartViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"购物车"];
    // Do any additional setup after loading the view from its nib.
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataInit{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView* footView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:footView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopCartTableViewCell" bundle:nil]
         forCellReuseIdentifier:[ShopCartTableViewCell cellReuseIdentifierInfo]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCartHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:[ShoppingCartHeaderView cellIdentity]];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getShopCartListRequest:NO];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getShopCartListRequest:YES];
    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.allSelectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    
    [self getShopCartListRequest:YES];
    [self getGoodsAddrListRequest];
}

#pragma mark - request
- (void)getShopCartListRequest:(BOOL)isRefresh{
    if (!getShopCartListParam) {
        getShopCartListParam = [GetShopCartListParam new];
        getShopCartListParam.pagesize = 20;
    }
    if (isRefresh) {
        getShopCartListParam.page = 1;
    }else{
        getShopCartListParam.page++;
    }
    
    [ShopMallRequest getShopCartList:getShopCartListParam Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            if(isRefresh){
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * dict in response.data) {
                GetShopCartListModel * listModel = [GetShopCartListModel new];
                [listModel setValuesForKeysWithDictionary:dict];
                
                NSArray * listArr = dict[@"cartGoodsList"];
                for (NSDictionary * listDict in listArr) {
                    GetShopCartListResultModel * resultModel = [GetShopCartListResultModel new];
                    [resultModel setValuesForKeysWithDictionary:listDict];
                    [listModel.cartGoodsListArr addObject:resultModel];
                }
                
                [self.dataArray addObject:listModel];
            }
            [self.tableView reloadData];
            
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }else{
                if (response.data.count<getShopCartListParam.pagesize) {
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


- (void)getGoodsAddrListRequest{
    GetGoodsAddrListParam * param = [GetGoodsAddrListParam new];
    param.isDef = 1;
    [ShopMallRequest getGoodsAddrList:param Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            
            for (NSDictionary * dict in response.data) {
                GetGoodsAddrListModel * listModel = [GetGoodsAddrListModel new];
                [listModel setValuesForKeysWithDictionary:dict];
                if (listModel.isDef == 1) {
                    _defaultAddrModel = listModel;
                }
            }
            [self.tableView reloadData];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

#pragma mark - AddAddressViewControllerDelegate

- (void)addAddressVCAction{
    [self getGoodsAddrListRequest];
}

#pragma mark - private mothod

- (NSArray *)calculateMoney{
    double actualMoney = 0;
    NSInteger settleCount = 0;
    for (GetShopCartListModel * listModel in self.shopCartDataArray) {
        for (GetShopCartListResultModel * resultModel in listModel.cartGoodsListArr) {
            actualMoney += [resultModel.actualMoney doubleValue];
            settleCount++;
        }
    }
    return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%.2f",actualMoney],@(settleCount), nil];
}

#pragma mark - ShopCartTableViewCellDelegate

- (void)shopCartTableViewCellAction:(GetShopCartListResultModel *)model listModel:(GetShopCartListModel *)listModel type:(ShopCartTableViewCellType)type{
    NSInteger currentListIndex = [self.shopCartDataArray indexOfObject:listModel];
    
    if (currentListIndex == NSNotFound){
        GetShopCartListModel * newListModel = [GetShopCartListModel new];
        newListModel.uid = listModel.uid;
        newListModel.sellerId = listModel.sellerId;
        newListModel.sellerName = listModel.sellerName;
        
        [newListModel.cartGoodsListArr addObject:model];
        [self.shopCartDataArray addObject:newListModel];
    }else{
        GetShopCartListModel * currentListModel = self.shopCartDataArray[currentListIndex];
        NSInteger currentResultIndex = [currentListModel.cartGoodsListArr indexOfObject:model];
        if (type == ShopCartTableViewCellTypeAdd) {
            [currentListModel.cartGoodsListArr addObject:model];
        }else{
            if (currentResultIndex != NSNotFound){
                [currentListModel.cartGoodsListArr removeObjectAtIndex:currentResultIndex];
                if (currentListModel.cartGoodsListArr.count == 0) {
                    [self.shopCartDataArray removeObjectAtIndex:currentListIndex];
                }
            }
        }
    }
    
    NSArray * calculateMoneyArr = [self calculateMoney];
    self.totalPriceLabel.text = calculateMoneyArr[0];
    self.settleLabel.text = [NSString stringWithFormat:@"结算(%ld)",[calculateMoneyArr[1] integerValue]];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GetShopCartListModel * model = self.dataArray[section];
    return model.cartGoodsListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GetShopCartListModel * model = self.dataArray[indexPath.section];
    GetShopCartListResultModel * resultModel = model.cartGoodsListArr[indexPath.row];
    ShopCartTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[ShopCartTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.delegate = self;
    [cell setReusltModel:resultModel];
    [cell setListModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108+13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShoppingCartHeaderView *cartView = (ShoppingCartHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[ShoppingCartHeaderView cellIdentity]];
    GetShopCartListModel * listModel = self.dataArray[section];
    cartView.addressLabel.text = listModel.sellerName;
    return cartView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1.删除
    
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@" 删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    deleteRoWAction.backgroundColor = UIColorFromRGB(0xFF6767);
    return @[deleteRoWAction];//最后返回这俩个RowAction 的数组
    
}



#pragma mark - action

- (IBAction)allSelectAction:(id)sender {
    self.allSelectBtn.selected = !self.allSelectBtn.selected;
}

- (IBAction)settleAction:(id)sender {
    if (_defaultAddrModel) {
        if (self.shopCartDataArray.count == 0) {
            [self.view makeToast:@"请选择需要购买的商品" duration:2.0f position:CSToastPositionCenter];
            return;
        }
        ShoppingCartSettleViewController * settleVC = [[ShoppingCartSettleViewController alloc] initWithNibName:nil bundle:nil];
        settleVC.defaultAddrModel = _defaultAddrModel;
        settleVC.shopCartDataArray = self.shopCartDataArray;
        settleVC.totalPrice = self.totalPriceLabel.text;
        [self.navigationController pushViewController:settleVC animated:YES];
    }else{
        AddAddressViewController * addrVC = [[AddAddressViewController alloc] initWithNibName:nil bundle:nil];
        addrVC.delegate = self;
        [self.navigationController pushViewController:addrVC animated:YES];
    }
    
}


#pragma mark - getter
- (NSMutableArray<GetShopCartListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray<GetShopCartListModel *> *)shopCartDataArray{
    if (!_shopCartDataArray) {
        _shopCartDataArray = [[NSMutableArray alloc] init];
    }
    return _shopCartDataArray;
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
