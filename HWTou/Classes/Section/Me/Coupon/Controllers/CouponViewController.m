//
//  CouponViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CouponViewController.h"

#import "VTMagic.h"
#import "PublicHeader.h"

#import "CouponColViewController.h"

@interface CouponViewController ()<VTMagicViewDataSource,VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *m_MagicController;

@end

@implementation CouponViewController
@synthesize m_MagicController;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"优惠劵"];
    
    [self dataInitialization];
    [self addMainView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addViews];
    
}

- (void)addViews{
    
    VTMagicController *magicController = [[VTMagicController alloc] init];
    
    [magicController.magicView setDelegate:self];
    [magicController.magicView setDataSource:self];
    
    [magicController.magicView setSliderHeight:2.5];
    [magicController.magicView setSliderExtension:8];
    [magicController.magicView setNavigationHeight:32];
    [magicController.magicView setItemWidth:kMainScreenWidth/3];
    [magicController.magicView setSliderColor:UIColorFromHex(0xb4292d)];
    [magicController.magicView setNavigationColor:[UIColor whiteColor]];
    [magicController.magicView setSeparatorColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [magicController.magicView setScrollEnabled:NO];
    [magicController.magicView setSwitchAnimated:NO];
    [magicController.magicView setMenuScrollEnabled:NO];
    
    [self setM_MagicController:magicController];
    
    [self.view addSubview:magicController.magicView];
    
    [self.m_MagicController.magicView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
    [m_MagicController.magicView reloadData];
    
    [m_MagicController switchToPage:0 animated:NO];
    
}

#pragma mark - VTMagicViewDataSource Manager
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView{
    
    return @[@"抵用券", @"加息劵", @"体验劵"];
    
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex{
    
    static NSString *itemIdentifier = @"itemIdentifier";
    
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    
    if (!menuItem) {
        
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [menuItem.titleLabel setFont:FontPFRegular(CLIENT_COMMON_FONT_CONTENT_SIZE)];
        
    }
    
    return menuItem;
    
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    
    static NSString *recomId = @"recom.identifier";
    
    CouponColViewController *couponColVC = [magicView dequeueReusablePageWithIdentifier:recomId];
    
    if (!couponColVC) {

        couponColVC = [[CouponColViewController alloc] init];
        
    }
    [couponColVC setCouponColViewControllerType:pageIndex + 1];
    
    return couponColVC;
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers

@end
