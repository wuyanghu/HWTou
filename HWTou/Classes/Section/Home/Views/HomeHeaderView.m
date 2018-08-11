//
//  HomeHeaderView.m
//  HWTou
//
//  Created by pengpeng on 17/3/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ComWebViewController.h"
#import <UIButton+WebCache.h>
#import "ComCarouselView.h"
#import "HomeHeaderView.h"
#import "ComFloorEvent.h"
#import "PublicHeader.h"
#import "HomeNoticeDM.h"
#import "HomeConfigDM.h"
#import "BannerAdDM.h"

@interface HomeHeaderView () <ComCarouselViewDelegate>
{
    ComCarouselImageView    *_vCarouselImg; // 图片轮播
    ComCarouselLabelView    *_vCarouselLab; // 公告轮播
    
    UIButton    *_btnLeft;   // 左图
    UIButton    *_btnRightT; // 右上
    UIButton    *_btnRightB; // 右下
    
    UIView      *_vBanner;   // 头部内容
    UIView      *_vFunction; // 功能入口
}

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBannerView];
        [self setupFunctionView];
    }
    return self;
}

- (void)setupBannerView
{
    self.backgroundColor = UIColorFromHex(0xf4f4f4);
    _vBanner = [[UIView alloc] init];
    _vBanner.backgroundColor = [UIColor whiteColor];
    
    _vCarouselImg = [[ComCarouselImageView alloc] init];
    _vCarouselLab = [[ComCarouselLabelView alloc] init];
    _vCarouselImg.delegate = self;
    _vCarouselLab.delegate = self;
    
    UIView *vBottom = [[UIView alloc] init];
    UIImageView *imgvNews = [[UIImageView alloc] init];
    imgvNews.image = [UIImage imageNamed:@"home_img_news"];
    
    [self addSubview:_vBanner];
    [_vBanner addSubview:vBottom];
    [_vBanner addSubview:_vCarouselImg];
    
    [vBottom addSubview:imgvNews];
    [vBottom addSubview:_vCarouselLab];
    
    [_vBanner makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.bottom.equalTo(vBottom);
    }];
    
    [_vCarouselImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(_vBanner);
        make.height.equalTo(_vCarouselImg.width).multipliedBy(kScale_9_16);
    }];
    
    [vBottom makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vCarouselImg.bottom);
        make.leading.trailing.equalTo(_vBanner);
        make.height.equalTo(@30);
    }];
    
    [imgvNews makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vBottom);
        make.leading.equalTo(@15);
    }];
    
    [_vCarouselLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(vBottom);
        make.leading.equalTo(imgvNews.trailing);
    }];
}

- (void)setBanners:(NSArray<BannerAdDM *> *)banners
{
    _banners = banners;
    
    NSMutableArray *urlGroup = [NSMutableArray arrayWithCapacity:banners.count];
    [banners enumerateObjectsUsingBlock:^(BannerAdDM *obj, NSUInteger idx, BOOL *stop) {
        [urlGroup addObject:obj.img_url];
    }];
    _vCarouselImg.imageURLStringsGroup = urlGroup;
}

- (void)setNotices:(NSArray<HomeNoticeDM *> *)notices
{
    _notices = notices;
    NSMutableArray *titlesGroup = [NSMutableArray arrayWithCapacity:notices.count];
    [notices enumerateObjectsUsingBlock:^(HomeNoticeDM *obj, NSUInteger idx, BOOL *stop) {
        [titlesGroup addObject:obj.content];
    }];
    _vCarouselLab.titlesGroup = titlesGroup;
}

- (void)setConfig:(NSArray<HomeConfigDM *> *)config
{
    _config = config;
    for (HomeConfigDM *dmConfig in config) {
        switch (dmConfig.id) {
            case HomePositionLeft:
                [_btnLeft sd_setImageWithURL:[NSURL URLWithString:dmConfig.img_url] forState:UIControlStateNormal];
                break;
            case HomePositionRightT:
                [_btnRightT sd_setImageWithURL:[NSURL URLWithString:dmConfig.img_url] forState:UIControlStateNormal];
                break;
            case HomePositionRightB:
                [_btnRightB sd_setImageWithURL:[NSURL URLWithString:dmConfig.img_url] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

- (void)setupFunctionView
{
    _btnLeft   = [self createButton:HomePositionLeft imgName:nil];
    _btnRightT = [self createButton:HomePositionRightT imgName:nil];
    _btnRightB = [self createButton:HomePositionRightB imgName:nil];
    
    _vFunction = [[UIView alloc] init];
    _vFunction.backgroundColor = [UIColor whiteColor];
    [self addSubview:_vFunction];
    
    [_vFunction addSubview:_btnLeft];
    [_vFunction addSubview:_btnRightT];
    [_vFunction addSubview:_btnRightB];
    
    [_vFunction makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(_vBanner.bottom).equalTo(10);
        make.height.equalTo(self.width).multipliedBy(0.54);
    }];
    
    [_btnLeft makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_vFunction).offset(CoordXSizeScale(15));
        make.trailing.equalTo(_vFunction.centerX).offset(-CoordXSizeScale(1.5));
        make.height.equalTo(_vFunction).offset(-20);
        make.centerY.equalTo(_vFunction);
    }];
    
    [_btnRightT makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_vFunction.centerX).offset(CoordXSizeScale(1.5));
        make.trailing.equalTo(_vFunction).offset(-CoordXSizeScale(15));
        make.bottom.equalTo(_vFunction.centerY).offset(-CoordXSizeScale(1.5));
        make.top.equalTo(_btnLeft);
    }];
    
    [_btnRightB makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_btnLeft);
        make.size.right.equalTo(_btnRightT);
    }];
}

- (UIButton *)createButton:(HomePosition)postion imgName:(NSString *)imgName
{
    UIButton *button = [[UIButton alloc] init];
    button.adjustsImageWhenHighlighted = NO;
    button.tag = postion;
    [button setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionFuncation:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)actionFuncation:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onHomeConfigPosition:)]) {
        [self.delegate onHomeConfigPosition:button.tag];
    }
}

#pragma mark - ComRollViewDelegate
- (void)carouselView:(ComCarouselView *)view didSelectItemAtIndex:(NSInteger)index
{
    if (view == _vCarouselImg) {
        BannerAdDM *banner = [self.banners objectAtIndex:index];
        [ComFloorEvent handleEventWithFloor:banner];
    } else {
        HomeNoticeDM *notice = [self.notices objectAtIndex:index];
        if (notice.link.length > 0) {
            ComWebViewController *webVC = [[ComWebViewController alloc] init];
            webVC.webUrl = notice.link;
            [self.viewController.navigationController pushViewController:webVC animated:YES];
        }
    }
}
@end
