//
//  ProductDetailViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "OrderCommitViewController.h"
#import "ProductCartViewController.h"
#import "SocialThirdController.h"
#import "ProductCommentListVC.h"
#import "ProductAttributeReq.h"
#import "ProductDetailView.h"
#import "ProductCollectReq.h"
#import "ProductCommentReq.h"
#import "ProductDetailReq.h"
#import "ProductAttributeDM.h"
#import "ProductDetailDM.h"
#import <YYModel/YYModel.h>
#import "ProductCartReq.h"
#import "ProductCartReq.h"
#import "ProductCartDM.h"
#import "PublicHeader.h"

@interface ProductDetailViewController () <ProductDetailDelegate>

@property (nonatomic, strong) ProductDetailView *vDetail;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self loadDetailData];
    [self loadCommentData];
}

- (void)createUI
{
    self.title = @"商品详情";
    self.vDetail = [[ProductDetailView alloc] init];
    self.vDetail.productNum = 1;
    [self.view addSubview:self.vDetail];
    
    [self.vDetail makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.vDetail.delegate = self;
    self.vDetail.dmProduct = self.dmProduct;
    
    UIBarButtonItem *itemShare = [UIBarButtonItem itemWithImageName:@"navi_share_nor" hltImageName:nil target:self action:@selector(actionShare)];
    self.navigationItem.rightBarButtonItem = itemShare;
}

- (BOOL)isShowCloseButton
{
    return YES;
}

- (void)actionShare
{
    NSString *url  = [NSString stringWithFormat:@"%@/%@?id=%ld&type=2", kHomeServerHost, kApiProductShare, (long)self.dmProduct.item_id];
    [SocialThirdController shareWebLink:url title:self.dmProduct.title content:self.dmProduct.title thumbnail:[UIImage imageNamed:@"share_icon"] completed:^(BOOL success, NSString *errMsg) {
        if (success) {
            [HUDProgressTool showOnlyText:@"已分享"];
        } else {
            [HUDProgressTool showOnlyText:errMsg];
        }
    }];
}

- (void)setDmProduct:(ProductDetailDM *)dmProduct
{
    _dmProduct = dmProduct;
    self.vDetail.dmProduct = dmProduct;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCartNumber];
}

- (void)loadCartNumber
{
    if ([AccountManager isNeedLogin]) {
        return;
    }
    [ProductCartReq listCartsSuccess:^(CartListResp *response) {
        [self.vDetail setCartNumber:response.data.count];
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)loadDetailData
{
    ProductDetailParam *param = [[ProductDetailParam alloc] init];
    param.item_id = self.dmProduct.item_id;
    
    [ProductDetailReq detailWithParam:param success:^(ProductDetailResp *response) {
        if (response.success) {
            self.vDetail.dmProduct = self.dmProduct = response.data;
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
    
    ProductAttListParam *listParam = [[ProductAttListParam alloc] init];
    listParam.item_id = self.dmProduct.item_id;
    
    [ProductAttributeReq listWithParam:listParam success:^(ProductAttListResp *response) {
        self.vDetail.listAttribute = response.data;
    } failure:^(NSError *error) {
        
    }];
    
    ProductAttStockParam *stockParam = [[ProductAttStockParam alloc] init];
    stockParam.item_id = self.dmProduct.item_id;
    
    [ProductAttributeReq stockWithParam:stockParam success:^(ProductAttStockResp *response) {
        self.vDetail.listStock = response.data.list;
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadCommentData
{
    CommentListParam *param = [CommentListParam new];
    param.item_id = self.dmProduct.item_id;
    param.start_page = 0;
    param.pages = 1;
    param.flag = 2;
    
    [ProductCommentReq listWithParam:param success:^(CommentListResp *response) {
        if (response.success) {
            self.vDetail.dmComment = [response.data.list firstObject];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}


#pragma mark - ProductDetailDelegate
- (void)productDetailAction:(DetailAction)action
{
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    switch (action) {
        case DetailActionNowBuy:
            [self handleNowBuy];
            break;
        case DetailActionCartList:
            [self handleCartList];
            break;
        case DetailActionCollect:
            [self handleCollect];
            break;
        case DetailActionCartAdd:
            [self handleAddCart];
            break;
        default:
            break;
    }
}
- (void)handleNowBuy
{
    if ([self checkAttribute]) {
        // 对象数据转换
        NSDictionary *dictObj = [self.dmProduct yy_modelToJSONObject];
        ProductCartDM *cart = [ProductCartDM yy_modelWithJSON:dictObj];
        cart.num = (int)self.vDetail.productNum;
        cart.mivid = self.vDetail.dmStock.mivid;
        cart.price = self.vDetail.dmStock.price;
        cart.postage = self.vDetail.dmStock.postage;
        cart.value_names = self.vDetail.dmStock.value_names;
        
        OrderCommitViewController *cartVC = [[OrderCommitViewController alloc] init];
        cartVC.carts = @[cart];
        [self.navigationController pushViewController:cartVC animated:YES];
    }
}

- (void)handleCartList
{
    ProductCartViewController *cartVC = [[ProductCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (void)handleCollect
{
    ProductCollectParam *param = [ProductCollectParam new];
    param.item_id = self.dmProduct.item_id;
    
    [HUDProgressTool showIndicatorWithText:nil];
    
    if (self.dmProduct.collected_flag) {
        [ProductCollectReq cancelWithParam:param success:^(BaseResponse *response) {
            if (response.success) {
                self.dmProduct.collected_flag = NO;
                [self.vDetail setCollect:NO];
                [HUDProgressTool showOnlyText:@"取消收藏"];
            } else {
                [HUDProgressTool showOnlyText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    } else {
        [ProductCollectReq addWithParam:param success:^(BaseResponse *response) {
            if (response.success) {
                self.dmProduct.collected_flag = YES;
                [self.vDetail setCollect:YES];
                [HUDProgressTool showOnlyText:@"收藏成功"];
            } else {
                [HUDProgressTool showOnlyText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    }
}

- (void)handleAddCart
{
    if ([self checkAttribute]) {
        CartAddParam *param = [CartAddParam new];
        param.item_id = self.dmProduct.item_id;
        param.num = self.vDetail.productNum;
        param.mivid = self.vDetail.dmStock.mivid;
        
        [HUDProgressTool showIndicatorWithText:nil];
        [ProductCartReq addCartsWithParam:param success:^(BaseResponse *response) {
            if (response.success) {
                self.vDetail.cartNumber++;
                [HUDProgressTool showOnlyText:@"加入购物车成功"];
            } else {
                [HUDProgressTool showOnlyText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    }
}

// 检查商品规格数量
- (BOOL)checkAttribute
{
    __block NSString *msgError = nil;
    if (self.vDetail.dmStock) {
        if (self.vDetail.productNum > self.vDetail.dmStock.stock) {
            msgError = @"库存不足";
        }
    } else {
        
        if (!self.vDetail.isShowAttribute) {
            [self.vDetail showProductAttribute];
            return NO;
        }
        
        [self.vDetail.listAttribute enumerateObjectsUsingBlock:^(ProductAttListDM *dmList, NSUInteger idx, BOOL *stop) {
            __block BOOL isFound = NO;
            [self.vDetail.selAtt enumerateObjectsUsingBlock:^(ProductAttributeDM *dmAttr, NSUInteger idx, BOOL *stop) {
                if (dmList.prop_id == dmAttr.prop_id) {
                    isFound = YES;
                    *stop = YES;
                }
            }];
            
            if (!isFound) {
                msgError = [NSString stringWithFormat:@"请选择: %@", dmList.prop_name];
                *stop = YES;
            }
        }];
    }
    if (msgError.length > 0) {
        [HUDProgressTool showOnlyText:msgError];
        return NO;
    }
    return YES;
}
@end
