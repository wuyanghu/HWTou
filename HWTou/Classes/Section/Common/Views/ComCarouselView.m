//
//  ComCarouselView.m
//  HWTou
//
//  Created by pengpeng on 17/3/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SDCycleScrollView.h"
#import "ComCarouselView.h"
#import "PublicHeader.h"

@interface ComCarouselView () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *vCycleScroll;

@end

@implementation ComCarouselView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCycleScrollView];
    }
    return self;
}

- (void)setupCycleScrollView
{
    self.vCycleScroll = [[SDCycleScrollView alloc] init];
    self.vCycleScroll.autoScrollTimeInterval = 5.0f;
    self.vCycleScroll.backgroundColor = UIColorFromHex(0xfafafa);
    self.vCycleScroll.delegate = self;
    
    [self addSubview:self.vCycleScroll];
    [self.vCycleScroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    self.vCycleScroll.imageURLStringsGroup = imageURLStringsGroup;
}

- (void)setLocalImageNamesGroup:(NSArray *)localImageNamesGroup
{
    self.vCycleScroll.localizationImageNamesGroup = localImageNamesGroup;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndex:)]) {
        [self.delegate carouselView:self didSelectItemAtIndex:index];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(carouselView:didScrollToIndex:)]) {
        [self.delegate carouselView:self didScrollToIndex:index];
    }
}

@end

@implementation ComCarouselImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPageView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setupPageView
{
//    self.vCycleScroll.pageControlRightOffset = 5.0f;
//    self.vCycleScroll.pageControlBottomOffset = 6.0f;
    self.vCycleScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.vCycleScroll.pageDotImage = [UIImage imageNamed:@"com_banner_dot_nor"];
    self.vCycleScroll.currentPageDotImage = [UIImage imageNamed:@"com_banner_dot_sel"];
    self.vCycleScroll.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    self.vCycleScroll.imageURLStringsGroup = imageURLStringsGroup;
}

- (void)setLocalImageNamesGroup:(NSArray *)localImageNamesGroup
{
    self.vCycleScroll.localizationImageNamesGroup = localImageNamesGroup;
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    self.vCycleScroll.autoScroll = autoScroll;
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    self.vCycleScroll.infiniteLoop = infiniteLoop;
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    self.vCycleScroll.showPageControl = showPageControl;
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    self.vCycleScroll.bannerImageViewContentMode = contentMode;
}

@end

@implementation ComCarouselLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupParams];
    }
    return self;
}

- (void)setupParams
{
    self.vCycleScroll.titleLabelBackgroundColor = [UIColor whiteColor];
    self.vCycleScroll.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.vCycleScroll.titleLabelTextColor = UIColorFromHex(0x333333);
    self.vCycleScroll.titleLabelTextFont = FontPFRegular(12.0f);
    self.vCycleScroll.onlyDisplayText = YES;
}

- (void)setTitlesGroup:(NSArray *)titlesGroup
{
    self.vCycleScroll.titlesGroup = titlesGroup;
}

@end
