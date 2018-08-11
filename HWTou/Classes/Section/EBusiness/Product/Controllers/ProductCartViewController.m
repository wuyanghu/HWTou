//
//  ProductCartViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCartViewController.h"
#import "ProductCartView.h"
#import "ProductCartReq.h"
#import "PublicHeader.h"

@interface ProductCartViewController ()

@property (nonatomic, strong) ProductCartView *vProductCart;
@property (nonatomic, strong) UIButton *btnEdit;

@end

@implementation ProductCartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)createUI
{
    self.title = @"购物车";
    
    UIBarButtonItem *itemEdit = [UIBarButtonItem itemWithTitle:@"编辑" withColor:UIColorFromHex(0x333333) target:self action:@selector(actionEdit)];
    self.btnEdit = itemEdit.customView;
    [self.btnEdit setTitle:@"完成" forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = itemEdit;
    
    self.vProductCart = [[ProductCartView alloc] init];
    [self.view addSubview:self.vProductCart];
    
    [self.vProductCart makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (BOOL)isShowCloseButton
{
    return YES;
}

- (void)loadData
{
    [HUDProgressTool showIndicatorWithText:@"加载中..."];
    [ProductCartReq listCartsSuccess:^(CartListResp *response) {
        if (response.success) {
            [HUDProgressTool dismiss];
            self.vProductCart.cartList = [NSMutableArray arrayWithArray:response.data];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)actionEdit
{
    self.btnEdit.selected = !self.btnEdit.selected;
    self.vProductCart.isEdit = self.btnEdit.selected;
}
@end
