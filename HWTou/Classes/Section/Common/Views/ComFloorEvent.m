//
//  ComFloorEvent.m
//  HWTou
//
//  Created by 彭鹏 on 2017/5/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ProductDetailViewController.h"
#import "ProductListViewController.h"
#import "CalabashViewController.h"
#import "ActivityContentListVC.h"
#import "ComWebViewController.h"
#import "ProductCategoryReq.h"
#import "VersionUpdateTool.h"
#import "ProductCategoryDM.h"
#import "ProductDetailDM.h"
#import "ActivityNewsReq.h"
#import "ActivityNewsDM.h"
#import "ComFloorEvent.h"
#import "PublicHeader.h"
#import "ActivityReq.h"

@implementation ComFloorEvent

+ (void)handleEventWithFloor:(FloorItemDM *)dmFloor
{
    switch (dmFloor.type) {
        case FloorEventNews: // 文章
            [self handleActivityNews:dmFloor.param];
            break;
        case FloorEventProduct: // 商品详情
            [self handleProductDetail:dmFloor.param];
            break;
        case FloorEventLink: // 链接
            [self handleWebLink:dmFloor.param];
            break;
        case FloorEventParam:
            [self handleWebParm:dmFloor];
            break;
        case FloorEventMall: // 商城首页
            if ([VersionUpdateTool shared].isShowInvest) {
                [self handleTabbarItem:2];
            } else {
                [self handleTabbarItem:1];
            }
            break;
        case FloorEventInvest: // 投资首页
            if ([VersionUpdateTool shared].isShowInvest){
                [self handleTabbarItem:1];
            }
            break;
        case FloorEventNewsCate: // 文章分类
            [self handleActivityCategory:dmFloor.param];
            break;
        case FloorEventCalabash: // 乐葫芦
            [self handleCalabashVC];
            break;
        case FloorEventActivity: // 活动
            [self handleActivityDetail:dmFloor.param];
            break;
        case FloorEventProduct1: // 商品一级分类
            [self handleProductCategory:dmFloor.param cidTwo:nil];
            break;
        case FloorEventProduct2: // 商品二级分类
            [self handleProductCategory:dmFloor.param cidTwo:dmFloor.ext];
            break;
        default:
            break;
    }
}

+ (void)handleCalabashVC
{
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    CalabashViewController *calabashVC = [[CalabashViewController alloc] init];
    [[UIApplication topViewController].navigationController pushViewController:calabashVC animated:YES];
}

+ (void)handleActivityCategory:(NSString *)param
{
    ActivityContentListVC *activityVC = [[ActivityContentListVC alloc] init];
    activityVC.ncid = [param integerValue];
    [[UIApplication topViewController].navigationController pushViewController:activityVC animated:YES];
}

+ (void)handleTabbarItem:(NSInteger)index
{
    [[UIApplication topViewController].navigationController popToRootViewControllerAnimated:NO];
    [UIApplication topViewController].tabBarController.selectedIndex = index;
}

+ (void)handleProductCategory:(NSString *)strId cidTwo:(NSString *)cidTwo
{
    [HUDProgressTool showIndicatorWithText:@"加载中..."];
    CategoryChildParam *param = [CategoryChildParam new];
    param.mcid = [strId integerValue];
    [ProductCategoryReq childCategoryWithParam:param success:^(CategoryChildResp *response) {
        if (response.success) {
            ProductListViewController *productVC = [[ProductListViewController alloc] init];
            productVC.category = response.data;
            
            if (IsStrEmpty(cidTwo) == NO) {
                // 如果有二级分类，则判断二级分类位置
                [response.data.children enumerateObjectsUsingBlock:^(ProductCategoryDM *obj, NSUInteger idx, BOOL *stop) {
                    if (obj.mcid == [cidTwo integerValue]) {
                        productVC.currentPage = idx;
                        *stop = YES;
                    }
                }];
            }
            [[UIApplication topViewController].navigationController pushViewController:productVC animated:YES];
            [HUDProgressTool dismiss];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

+ (void)handleActivityNews:(NSString *)strId
{
    NewsDetailParam *param = [NewsDetailParam new];
    param.news_id = [strId integerValue];
    
    [HUDProgressTool showIndicatorWithText:@"加载中..."];
    [ActivityNewsReq detailWithParam:param success:^(NewsDetailResp *response) {
        if (response.success) {
            [HUDProgressTool dismiss];
            
            ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc] init];
            detailVC.dmNews = response.data;
            detailVC.type = ActivityDetailNews;
            [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

+ (void)handleActivityDetail:(NSString *)strId
{
    ActDetailParam *param = [ActDetailParam new];
    param.act_id = [strId integerValue];
    
    [HUDProgressTool showIndicatorWithText:@"加载中..."];
    [ActivityReq detailWithParam:param success:^(ActDetailResp *response) {
        if (response.success) {
            [HUDProgressTool dismiss];
            ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc] init];
            detailVC.dmActivity = response.data;
            detailVC.type = ActivityDetailList;
            [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

+ (void)handleProductDetail:(NSString *)productId
{
    ProductDetailViewController *productVC = [[ProductDetailViewController alloc] init];
    ProductDetailDM *dmProduct = [ProductDetailDM new];
    dmProduct.item_id = [productId integerValue];
    productVC.dmProduct = dmProduct;
    [[UIApplication topViewController].navigationController pushViewController:productVC animated:YES];
}

+ (void)handleWebLink:(NSString *)link
{
    ComWebViewController *webVC = [[ComWebViewController alloc] init];
    webVC.webUrl = link;
    [[UIApplication topViewController].navigationController pushViewController:webVC animated:YES];
}

+ (void)handleWebParm:(FloorItemDM *)item
{
    ComWebViewController *webVC = [[ComWebViewController alloc] init];
    webVC.webUrl = item.param;
    webVC.title = item.title;
    [[UIApplication topViewController].navigationController pushViewController:webVC animated:YES];
}

@end
