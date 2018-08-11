//
//  InvestView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <SDWebImage/UIButton+WebCache.h>
#import "ComWebViewController.h"
#import "InvestProductCell.h"
#import "InvestActivityDM.h"
#import "InvestProductDM.h"
#import "ComCarouselView.h"
#import "RongduManager.h"
#import "ComFloorEvent.h"
#import <HWTSDK/HWTAPI.h>
#import "PublicHeader.h"
#import "InvestView.h"
#import "BannerAdDM.h"
#import "RDInfoReq.h"

@interface InvestView () <UITableViewDelegate, UITableViewDataSource, ComCarouselViewDelegate>

@property (nonatomic, strong) ComCarouselImageView *vBanner;

@property (nonatomic, strong) UIView *vHeader;
@property (nonatomic, strong) UIView *vSection;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation InvestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupHeader];
        [self viewSection];
        [self createUI];
    }
    return self;
}

- (void)scrollToProductPosition
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.listData.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    });
}

- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = self.vHeader;
    [_tableView registerClass:[InvestProductCell class] forCellReuseIdentifier:NSStringFromClass([InvestProductCell class])];
    
    [self addSubview:_tableView];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)viewSection
{
    self.vSection = [[UIView alloc] init];
    self.vSection.backgroundColor = [UIColor whiteColor];
    
    UILabel *labTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:18];
    labTitle.text = @"精选产品";
    
    [self.vSection addSubview:labTitle];
    
    [labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vSection);
    }];
    
    UIImageView *imgvIcon = [BasisUITool getImageViewWithImage:@"WechatIMG23" withIsUserInteraction:NO];
    [self.vSection addSubview:imgvIcon];
    
    UIView *vLine = [UIView new];
    vLine.backgroundColor = UIColorFromHex(0xd6d7dc);
    [self.vSection addSubview:vLine];
    
    [imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labTitle);
        make.trailing.equalTo(labTitle.leading).offset(-10);
    }];
    
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.leading.equalTo(self.vSection);
        make.height.equalTo(0.5);
    }];
}

- (void)setupHeader
{
    self.vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, CoordXSizeScale(170) + 10)];
    self.vHeader.backgroundColor = UIColorFromHex(0xf4f4f4);
    
    self.vBanner = [[ComCarouselImageView alloc] init];
    self.vBanner.delegate = self;
    self.vBanner.autoScroll = NO;
    self.vBanner.infiniteLoop = NO;
    self.vBanner.showPageControl = NO;
    self.vBanner.contentMode = UIViewContentModeScaleToFill;
    
    UIView *vActivity = [UIView new];
    vActivity.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnLeft = [[UIButton alloc] init];
    [btnLeft addTarget:self action:@selector(actionActivity:) forControlEvents:UIControlEventTouchUpInside];
    self.btnLeft = btnLeft;
    
    UIButton *btnRight = [[UIButton alloc] init];
    [btnRight addTarget:self action:@selector(actionActivity:) forControlEvents:UIControlEventTouchUpInside];
    self.btnRight = btnRight;
    
    [self.vHeader addSubview:self.vBanner];
    [self.vHeader addSubview:vActivity];
    
    [self.vBanner makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.vHeader);
        make.height.equalTo(CoordXSizeScale(80));
    }];
    
    [vActivity makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.vHeader);
        make.top.equalTo(self.vBanner.bottom).offset(1);
        make.height.equalTo(CoordXSizeScale(90));
    }];
    
    [vActivity addSubview:btnLeft];
    [vActivity addSubview:btnRight];
    
    [btnLeft makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vActivity);
        make.leading.equalTo(vActivity).offset(10);
        make.trailing.equalTo(vActivity.centerX).offset(-3).priorityHigh();
        make.height.equalTo(CoordXSizeScale(70));
    }];
    
    [btnRight makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(btnLeft);
        make.trailing.equalTo(vActivity).offset(-10);
        make.leading.equalTo(vActivity.centerX).offset(3).priorityHigh();
    }];
}

- (void)actionActivity:(UIButton *)button
{
    [self.ativity enumerateObjectsUsingBlock:^(InvestActivityDM *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.t_id integerValue] == button.tag) {
            if (IsStrEmpty(obj.url)) {
                
                NSInteger userId = [[RongduManager share] getRdUserId];
                if (userId == 0) {
                    [[HWTAPI sharedInstance] jumpToLoginVC:self.viewController];
                } else {
                    if (obj.classify == 4) { // 体验标
                        [[HWTAPI sharedInstance] jumpToExpBorrowDetailFromVC:self.viewController withModuleType:ProductTypeNormal withBorrowId:obj.t_id withMoneyFromHWT:obj.rate];
                    } else { // 普通标
                        [[HWTAPI sharedInstance] jumpToProductDetailFromVC:self.viewController withModuleType:ProductTypeNormal withBorrowId:obj.t_id withMoneyFromHWT:obj.rate];
                    }
                }
            } else {
                ComWebViewController *webVC = [ComWebViewController new];
                webVC.webUrl = obj.url;
                [self.viewController.navigationController pushViewController:webVC animated:YES];
            }
            *stop = YES;
        }
    }];
}

- (void)setAtivity:(NSArray<InvestActivityDM *> *)ativity
{
    _ativity = ativity;
    InvestActivityDM *dmLeft = ativity.firstObject;
    InvestActivityDM *dmRight = ativity.lastObject;
    self.btnLeft.tag = [dmLeft.t_id integerValue];
    self.btnRight.tag = [dmRight.t_id integerValue];
    
    [self.btnLeft sd_setBackgroundImageWithURL:[NSURL URLWithString:dmLeft.images] forState:UIControlStateNormal];
    [self.btnRight sd_setBackgroundImageWithURL:[NSURL URLWithString:dmRight.images] forState:UIControlStateNormal];
}

- (void)setBanners:(NSArray<BannerAdDM *> *)banners
{
    _banners = banners;
    
    NSMutableArray *urlGroup = [NSMutableArray arrayWithCapacity:banners.count];
    [banners enumerateObjectsUsingBlock:^(BannerAdDM *obj, NSUInteger idx, BOOL *stop) {
        [urlGroup addObject:obj.img_url];
    }];
    self.vBanner.imageURLStringsGroup = urlGroup;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.vSection;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 55.0f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvestProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InvestProductCell class])];
    OBJECTOFARRAYATINDEX(cell.dmProduct, self.listData, indexPath.section);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger userId = [[RongduManager share] getRdUserId];
    if (userId == 0) {
        [[HWTAPI sharedInstance] jumpToLoginVC:self.viewController];
        return;
    }
    
    InvestProductDM *dmProduct;
    OBJECTOFARRAYATINDEX(dmProduct, self.listData, indexPath.section);
    if (dmProduct.type == 0) { // 体验标
        [[HWTAPI sharedInstance] jumpToExpBorrowDetailFromVC:self.viewController withModuleType:ProductTypeNormal withBorrowId:dmProduct.id withMoneyFromHWT:dmProduct.dmForward.rate];
    } else {
        [[HWTAPI sharedInstance] jumpToProductDetailFromVC:self.viewController withModuleType:ProductTypeNormal withBorrowId:dmProduct.id withMoneyFromHWT:dmProduct.dmForward.rate];
    }
}

- (void)setListData:(NSArray<InvestProductDM *> *)listData
{
    _listData = listData;
    [self.tableView reloadData];
}

#pragma mark - ComRollViewDelegate
- (void)carouselView:(ComCarouselView *)view didSelectItemAtIndex:(NSInteger)index
{
    BannerAdDM *banner = [self.banners objectAtIndex:index];
    [ComFloorEvent handleEventWithFloor:banner];
}

@end
