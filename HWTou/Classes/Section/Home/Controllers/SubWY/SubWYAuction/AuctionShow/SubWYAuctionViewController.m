//
//  SubWYAuctionViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SubWYAuctionViewController.h"
#import "PublicHeader.h"
#import "CommodityShowCollectionViewCell.h"
#import "ShopMallRequest.h"
#import "GetSellerPerformGoodsListModel.h"
#import "SubWYAuctionDetailViewController.h"

@interface SubWYAuctionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    GetSellerPerformGoodsListParam * getGoodsListParam;
}
@property (nonatomic,strong) GetSellerPerformGoodsListModel * getSellerPerformGoodsListModel;
@property (nonatomic, strong) UICollectionView  *collectionView;
@end

@implementation SubWYAuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"唯艺拍卖"];
    [self.view addSubview:self.collectionView];
    [self getGoodsListRequest:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request

- (void)getGoodsListRequest:(BOOL)isRefresh{
    if (!getGoodsListParam) {
        getGoodsListParam = [GetSellerPerformGoodsListParam new];
        getGoodsListParam.pagesize = 20;
    }
    if (isRefresh) {
        getGoodsListParam.page = 1;
    }else{
        getGoodsListParam.page++;
    }
    getGoodsListParam.performId = _performListModel.performId;

    [ShopMallRequest getSellerPerformGoodsList:getGoodsListParam Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.getSellerPerformGoodsListModel.goodsListArr removeAllObjects];
            }
            
            [self.getSellerPerformGoodsListModel setValuesForKeysWithDictionary:response.data];
            
            NSArray * returnArr = response.data[@"goodsList"];
            for (NSDictionary * dict in returnArr) {
                GoodsListModel * detailModel = [GoodsListModel new];
                [detailModel setValuesForKeysWithDictionary:dict];
                
                [self.getSellerPerformGoodsListModel.goodsListArr addObject:detailModel];
            }
            [self.collectionView reloadData];
            if (isRefresh) {
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer resetNoMoreData];
            }else{
                if (returnArr.count<getGoodsListParam.pagesize) {
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.collectionView.mj_footer endRefreshing];
                }
            }
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.getSellerPerformGoodsListModel.goodsListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommodityShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CommodityShowCollectionViewCell cellIdentity] forIndexPath:indexPath];
    [cell setGoodsListModel:self.getSellerPerformGoodsListModel.goodsListArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubWYAuctionDetailViewController * auctionVC = [[SubWYAuctionDetailViewController alloc] initWithNibName:nil bundle:nil];
    auctionVC.goodsListModel = self.getSellerPerformGoodsListModel.goodsListArr[indexPath.row];
    auctionVC.performGoodsListModel = self.getSellerPerformGoodsListModel;
    [self.navigationController pushViewController:auctionVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

//每个item之间的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//每个item之间的纵向的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

//设置每个单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWidth = (kMainScreenWidth-4)/2;
    return CGSizeMake(itemWidth, 260);
}

//头部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

//尾部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

#pragma mark - load

- (void)loadHeaderData{
    [self getGoodsListRequest:YES];
}

- (void)loadFooterData{
    [self getGoodsListRequest:NO];
}

#pragma mark - getter

- (GetSellerPerformGoodsListModel *)getSellerPerformGoodsListModel{
    if (!_getSellerPerformGoodsListModel) {
        _getSellerPerformGoodsListModel = [GetSellerPerformGoodsListModel new];
    }
    return _getSellerPerformGoodsListModel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.frame = self.view.frame;
        _collectionView.backgroundColor = UIColorFromRGB(0xF4F3F3);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"CommodityShowCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[CommodityShowCollectionViewCell cellIdentity]];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadHeaderData];
        }];
        
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadFooterData];
        }];
    }
    return _collectionView;
}

@end
