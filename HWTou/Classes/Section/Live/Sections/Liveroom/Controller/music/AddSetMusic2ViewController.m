//
//  AddSetMusic2ViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AddSetMusic2ViewController.h"
#import "VTMagicController.h"
#import "PublicHeader.h"
#import "AddSetMusicDetailViewController.h"
#import "UIView+NTES.h"
#import "DeviceInfoTool.h"

@interface AddSetMusic2ViewController ()<VTMagicViewDataSource,VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic,strong) NSMutableArray * listTitle;
@end

@implementation AddSetMusic2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加配乐";
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.magicController.magicView];
    self.magicController.magicView.frame = self.view.frame;
    self.magicController.magicView.ntesTop = [DeviceInfoTool getNavigationBarHeight];
    [self.magicController.magicView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    AddSetMusicDetailViewController * contentVC = [magicView dequeueReusablePageWithIdentifier:recomId];

    if (!contentVC) {
        contentVC = [[AddSetMusicDetailViewController alloc] init];
//        contentVC.detailBlock = ^(GuessULikeModel *model) {
//            //            [Navigation showAudioPlayerViewController:self radioModel:model];
//            [Navigation lookLiveRoom:self model:model];
//        };
    }
    NSDictionary * dict = _dataArr[pageIndex];
    contentVC.labelId = [dict[@"labelId"] integerValue];
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
        for (NSDictionary * dict in _dataArr) {
            [_listTitle addObject:dict[@"labelName"]];
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
