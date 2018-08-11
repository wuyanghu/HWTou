//
//  MakeCopperView.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MakeCopperView.h"
#import "PublicHeader.h"
#import "MakeCopperTableViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface MakeCopperView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *luckyBtn;
@property (nonatomic, strong) UIButton *aheadBtn;
@property (nonatomic, strong) UIImageView *imageV;
@end

@implementation MakeCopperView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHeaderView];
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _headerView;
    [_tableView registerClass:[MakeCopperTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UIView *)createHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, CoordYSizeScale(175))];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    _imageV = [BasisUITool getImageViewWithImage:@"WechatIMG22" withIsUserInteraction:NO];
    [_headerView addSubview:_imageV];
    [_imageV makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(_headerView);
        make.height.equalTo(CoordYSizeScale(77));
    }];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = UIColorFromHex(0xf4f4f4);
    [_headerView addSubview:lineV];
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(_headerView);
        make.top.equalTo(_imageV.bottom);
        make.height.equalTo(1);
    }];
    
    _luckyBtn = [BasisUITool getBtnWithTarget:self action:@selector(luckyBtnAction)];
    [_luckyBtn setBackgroundImage:[UIImage imageNamed:@"WechatIMG21"] forState:UIControlStateNormal];
    _aheadBtn = [BasisUITool getBtnWithTarget:self action:@selector(aheadBtnAction)];
    [_aheadBtn setBackgroundImage:[UIImage imageNamed:@"WechatIMG20"] forState:UIControlStateNormal];
    [_headerView addSubview:_luckyBtn];
    [_headerView addSubview:_aheadBtn];
    [_luckyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_headerView.leading).offset(CoordXSizeScale(10));
        make.top.equalTo(lineV.bottom).offset(CoordYSizeScale(10));
        make.size.equalTo(CGSizeMake(CoordXSizeScale(175), CoordYSizeScale(70)));
    }];
    
    [_aheadBtn makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_luckyBtn.trailing).offset(CoordXSizeScale(5));
        make.trailing.equalTo(_headerView.trailing).offset(CoordXSizeScale(-10));
        make.centerY.equalTo(_luckyBtn.centerY);
        make.size.equalTo(CGSizeMake(CoordXSizeScale(175), CoordYSizeScale(70)));
    }];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = UIColorFromHex(0xf4f4f4);
    [_headerView addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(_headerView);
        make.height.equalTo(CoordYSizeScale(10));
    }];
    
    return _headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, CoordYSizeScale(50))];
    _sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:18];
    titleLab.text = @"精选产品";
    [_sectionView addSubview:titleLab];
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_sectionView.centerX);
        make.centerY.equalTo(_sectionView.centerY);
    }];
    UIImageView *imgV = [BasisUITool getImageViewWithImage:@"WechatIMG23" withIsUserInteraction:NO];
    [_sectionView addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab.centerY);
        make.trailing.equalTo(titleLab.leading).offset(CoordYSizeScale(-12));
    }];
    
    return _sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CoordYSizeScale(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CoordYSizeScale(150);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MakeCopperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    OBJECTOFARRAYATINDEX(cell.dmProduct, self.listData, indexPath.row);
    return cell;
}

- (void)luckyBtnAction
{
    NSLog(@"点我点我");
}
- (void)aheadBtnAction
{
    
}
- (void)setListData:(NSArray *)listData
{
    _listData = listData;
    [self.tableView reloadData];
}

- (void)setModelLeft:(makeCopperListReq *)modelLeft
{
    if (_modelLeft != modelLeft) {
        _modelLeft = modelLeft;
    }
    [_luckyBtn sd_setBackgroundImageWithURL:[NSURL URLWithString: modelLeft.images] forState:UIControlStateNormal];
}

- (void)setModelRight:(makeCopperListReq *)modelRight
{
    if (_modelRight != modelRight) {
        _modelRight = modelRight;
    }
    [_aheadBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:modelRight.images] forState:UIControlStateNormal];
}

- (void)setModelBanner:(BannerAdDM *)modelBanner
{
    if (_modelBanner != modelBanner) {
        _modelBanner = modelBanner;
    }
    [_imageV sd_setImageWithURL:[NSURL URLWithString:modelBanner.img_url]];
}

@end
