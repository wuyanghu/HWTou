//
//  CommodityShowViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityShowViewController.h"
#import "VTMagicController.h"
#import "PublicHeader.h"
#import "CommodityShowDetailViewController.h"
#import "CommodityShowDetail2ViewController.h"
#import "UIView+NTES.h"
#import "DeviceInfoTool.h"

@interface CommodityShowViewController ()<VTMagicViewDataSource,VTMagicViewDelegate,CommodityShowDetailDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic,strong) NSMutableArray * listTitle;
@end

@implementation CommodityShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"唯艺商品";
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.magicController.magicView];
    self.magicController.magicView.frame = self.view.frame;
    [self.magicController.magicView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CommodityShowDetailDelegate
- (void)commodityShowDetailPushAction:(GetGoodsListModel *)model{
    CommodityShowDetail2ViewController * detail2VC = [[CommodityShowDetail2ViewController alloc] initWithNibName:nil bundle:nil];
    detail2VC.getGoodsListModel = model;
    [self.navigationController pushViewController:detail2VC animated:YES];
}

#pragma mark - VTMagicView

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.listTitle;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [menuItem setTitleColor:UIColorFromHex(0xb4292d) forState:UIControlStateSelected];
        menuItem.titleLabel.font = FontPFRegular(16.0f);
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString * recomId;
    recomId = [NSString stringWithFormat:@"recom.identifier%ld",pageIndex];
    CommodityShowDetailViewController * contentVC = [magicView dequeueReusablePageWithIdentifier:recomId];

    if (!contentVC) {
        contentVC = [[CommodityShowDetailViewController alloc] init];
        contentVC.delegate = self;
    }
    GetGoodsClassesModel * model = _dataArray[pageIndex];
    contentVC.labelId = model.classId;
    return contentVC;
}

#pragma mark - getter
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = 30;
        _magicController.magicView.navigationHeight = 44;
        CGFloat itemWidth = self.listTitle.count>5?kMainScreenWidth/5:kMainScreenWidth/self.listTitle.count;
        _magicController.magicView.itemWidth = itemWidth;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSMutableArray *)listTitle
{
    if (!_listTitle) {
        _listTitle = [NSMutableArray array];
        for (GetGoodsClassesModel * model in _dataArray) {
            [_listTitle addObject:model.className];
        }
    }
    return _listTitle;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
