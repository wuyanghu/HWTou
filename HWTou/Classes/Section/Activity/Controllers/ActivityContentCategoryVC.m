//
//  ActivityContentCategoryVC.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityContentCategoryVC.h"
#import "ActivityContentListVC.h"
#import "ActivityNewsDM.h"
#import "PublicHeader.h"
#import "VTMagic.h"

@interface ActivityContentCategoryVC () <VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;

@end

@implementation ActivityContentCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.magicController.magicView];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];
    [self.magicController switchToPage:self.currentPage animated:NO];
}

- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = 8;
        _magicController.magicView.navigationHeight = 32;
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    NSMutableArray *arrTitle = [NSMutableArray arrayWithCapacity:self.category.count];
    [self.category enumerateObjectsUsingBlock:^(ActivityCategoryDM *category, NSUInteger idx, BOOL *stop) {
        [arrTitle addObject:category.name];
    }];
    return arrTitle;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [menuItem setTitleColor:UIColorFromHex(0xb4292d) forState:UIControlStateSelected];
        menuItem.titleLabel.font = FontPFRegular(14.0f);
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString *recomId = @"recom.identifier";
    ActivityContentListVC *viewController = [magicView dequeueReusablePageWithIdentifier:recomId];
    if (!viewController) {
        viewController = [[ActivityContentListVC alloc] init];
    }
    ActivityCategoryDM *dmCategory;
    OBJECTOFARRAYATINDEX(dmCategory, self.category, pageIndex);
    viewController.ncid = dmCategory.ncid;
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    ActivityCategoryDM *dmCategory;
    OBJECTOFARRAYATINDEX(dmCategory, self.category, pageIndex);
    self.navigationItem.title = dmCategory.name;
}

@end
