//
//  ProductCartView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderCommitViewController.h"
#import "ProductEnjoyCell.h"
#import "ProductCartView.h"
#import "ProductCartReq.h"
#import "ProductCartDM.h"
#import "PublicHeader.h"

@interface ProductCartView () <UITableViewDelegate, UITableViewDataSource, CartCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *vBottom;
@property (nonatomic, strong) UILabel     *labNumber;
@property (nonatomic, strong) UIButton    *btnCheck;
@property (nonatomic, strong) UIButton    *btnBuy;
@property (nonatomic, assign) NSUInteger   numSelect; // 选中数量

@end

@implementation ProductCartView

static NSString * const kCellIdNomal = @"CellIdNomal";
static NSString * const kCellIdEdit  = @"CellIdEdit";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.numSelect = 0;
    self.isEdit = NO;
}
- (void)createUI
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = CoordXSizeScale(100);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ProductCartCell class] forCellReuseIdentifier:kCellIdNomal];
    [self.tableView registerClass:[ProductCartEditCell class] forCellReuseIdentifier:kCellIdEdit];
    
    self.vBottom = [[UIView alloc] init];
    self.vBottom.backgroundColor = UIColorFromHex(0xfafafa);
    
    [self addSubview:self.tableView];
    [self addSubview:self.vBottom];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.vBottom.top);
    }];
    
    [self.vBottom makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(49);
    }];
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorFromHex(0xc4c4c4);
    [self addSubview:vLine];
    
    self.btnCheck = [[UIButton alloc] init];
    [self.btnCheck setImage:[UIImage imageNamed:@"com_radio_nor"] forState:UIControlStateNormal];
    [self.btnCheck setImage:[UIImage imageNamed:@"com_radio_sel"] forState:UIControlStateSelected];
    [self.btnCheck addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    
    self.labNumber = [[UILabel alloc] init];
    self.labNumber.textColor = UIColorFromHex(0x7f7f7f);
    self.labNumber.font = FontPFRegular(14.0f);
    
    self.btnBuy = [[UIButton alloc] init];
    self.btnBuy.titleLabel.font = FontPFRegular(14.0f);
    [self.btnBuy setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xb4292d)] forState:UIControlStateNormal];
    [self.btnBuy setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:1]] forState:UIControlStateDisabled];
    [self.btnBuy addTarget:self action:@selector(actionBuy:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.vBottom addSubview:vLine];
    [self.vBottom addSubview:self.btnBuy];
    [self.vBottom addSubview:self.btnCheck];
    [self.vBottom addSubview:self.labNumber];
    
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.vBottom);
        make.height.equalTo(Single_Line_Width);
    }];
    
    [self.btnCheck makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(self.vBottom);
        make.width.equalTo(CoordXSizeScale(50));
    }];
    
    [self.labNumber makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vBottom);
        make.leading.equalTo(self.btnCheck.trailing);
    }];
    
    [self.btnBuy makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(self.vBottom);
        make.width.equalTo(self.vBottom).multipliedBy(0.33);
    }];
}

- (void)setNumSelect:(NSUInteger)numSelect
{
    _numSelect = numSelect;
    if (numSelect == 0) {
        self.labNumber.text = @"全选";
        self.btnBuy.enabled = NO;
    } else {
        self.labNumber.text = [NSString stringWithFormat:@"已选(%d)", (int)numSelect];
        self.btnBuy.enabled = YES;
    }
    
    if (self.cartList.count > 0 && numSelect == self.cartList.count) {
        self.btnCheck.selected = YES;
    } else {
        self.btnCheck.selected = NO;
    }
}

- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    if (isEdit) {
        [self.btnBuy setTitle:@"删除所选" forState:UIControlStateNormal];
    } else {
        [self.btnBuy setTitle:@"下单" forState:UIControlStateNormal];
    }
    
    if (self.numSelect > 0) {
        self.numSelect = 0;
        [self.cartList enumerateObjectsUsingBlock:^(ProductCartDM *dmCart, NSUInteger idx, BOOL *stop) {
            dmCart.selected = NO;
        }];
    }
    [self.tableView reloadData];
}

- (void)setCartList:(NSMutableArray *)cartList
{
    _cartList = cartList;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cartList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCartCell *cell = [tableView dequeueReusableCellWithIdentifier:self.isEdit ? kCellIdEdit : kCellIdNomal];
    [cell setCartProduct:self.cartList[indexPath.row]];
    
    if (!cell.delegate) {
        cell.delegate = self;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - CartCellDelegate
- (void)cartCell:(ProductCartCell *)cell didSelectItem:(BOOL)select
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ProductCartDM *cart = self.cartList[indexPath.row];
    cart.selected = select;
    if (select) {
        self.numSelect++;
    } else {
        self.numSelect--;
    }
}

#pragma mark - Event
- (void)actionCheck:(UIButton *)button
{
    BOOL selected = YES;
    if (self.numSelect == self.cartList.count) { // 非全选状态
        self.numSelect = 0;
        selected = NO;
    } else {
        self.numSelect = self.cartList.count;
    }
    
    for (ProductCartDM *cart in self.cartList) {
        cart.selected = selected;
    }
    [self.tableView reloadData];
}

- (void)actionBuy:(UIButton *)button
{
    if (self.isEdit) {
        [self deleteCartData];
    } else {
        OrderCommitViewController *buyVC = [[OrderCommitViewController alloc] init];
        
        if (self.numSelect == self.cartList.count) { // 全选
            buyVC.carts = self.cartList;
        } else {
            NSMutableArray *selectCarts = [NSMutableArray array];
            [self.cartList enumerateObjectsUsingBlock:^(ProductCartDM *dmCart, NSUInteger idx, BOOL *stop) {
                if (dmCart.selected) {
                    [selectCarts addObject:dmCart];
                }
            }];
            buyVC.carts = selectCarts;
        }
        
        [self.viewController.navigationController pushViewController:buyVC animated:YES];
    }
}

- (void)deleteCartData
{
    [HUDProgressTool showIndicatorWithText:nil];
    NSMutableArray *cartIds = [NSMutableArray array];
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSMutableArray *removeObj = [NSMutableArray array];
    [self.cartList enumerateObjectsUsingBlock:^(ProductCartDM *cart, NSUInteger idx, BOOL *stop) {
        if (cart.selected) {
            [cartIds addObject:@(cart.cart_id)];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
            [removeObj addObject:cart];
        }
    }];
    
    CartDeleteParam *param = [[CartDeleteParam alloc] init];
    param.ids = cartIds;
    [ProductCartReq deleteCartsWithParam:param success:^(BaseResponse *response) {
        
        self.numSelect = 0;
        [self.cartList removeObjectsInArray:removeObj];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [HUDProgressTool dismiss];
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

@end
