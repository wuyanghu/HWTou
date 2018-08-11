//
//  CouponSelectViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CouponSelectViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "CouponColSelView.h"
#import "PublicHeader.h"

@interface CouponSelectViewController ()

@property (nonatomic, copy) NSArray<CouponSelDM *> *selCoupon;
@property (nonatomic, strong) CouponColSelView *vCoupon;
@property (nonatomic, strong) UIButton      *btnDeselect;

@end

@implementation CouponSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.title = @"选择优惠券";
    self.view.backgroundColor = UIColorFromHex(ME_BG_COLOR);
    CGFloat topViewH = 50 + 15;
    self.btnDeselect = [[UIButton alloc] init];
    self.btnDeselect.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
    self.btnDeselect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnDeselect setTitle:@"不使用优惠券" forState:UIControlStateNormal];
    [self.btnDeselect setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    self.btnDeselect.backgroundColor = [UIColor whiteColor];
    self.btnDeselect.titleLabel.font = FontPFRegular(14.0f);
    [self.btnDeselect setRoundWithCorner:4.0f];
    [self.btnDeselect addTarget:self action:@selector(actionDeselect) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.btnDeselect];
    [self.btnDeselect makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-8);
        make.height.equalTo(50);
        make.leading.equalTo(8);
        make.top.equalTo(10);
    }];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = topViewH;
    frame.size.height -= topViewH + 64;
    
    self.vCoupon = [[CouponColSelView alloc] initWithFrame:frame];
    [self.view addSubview:self.vCoupon];
    
    NSLog(@"%@", self.coupons);
    // 拷贝一份出来，临时使用
    NSArray *tempCoupons = [[NSArray alloc] initWithArray:self.coupons copyItems:YES];
    NSLog(@"%@", tempCoupons);
    
    self.vCoupon.totalPrice = self.totalPrice;
    self.vCoupon.coupons = tempCoupons;
    
    [tempCoupons enumerateObjectsUsingBlock:^(CouponSelDM *obj, NSUInteger idx, BOOL *stop) {
        if (obj.selected) {
            [self.vCoupon.selCoupons addObject:obj];
        }
    }];
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithTitle:@"完成" withColor:UIColorFromHex(0x333333) target:self action:@selector(actionCompleted)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)actionDeselect
{
    if (self.m_Delegate && [self.m_Delegate respondsToSelector:@selector(onDidSelectCoupons:)]) {
        [self.m_Delegate onDidSelectCoupons:nil];
    }
}

- (void)actionCompleted
{
    if (self.m_Delegate && [self.m_Delegate respondsToSelector:@selector(onDidSelectCoupons:)]) {
        [self.m_Delegate onDidSelectCoupons:self.vCoupon.selCoupons];
    }
}
@end
