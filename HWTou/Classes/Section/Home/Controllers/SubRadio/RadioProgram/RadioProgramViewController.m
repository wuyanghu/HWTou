//
//  RadioProgramViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioProgramViewController.h"
#import "VTMagicController.h"
#import "PublicHeader.h"
#import "RadioProgramDetailViewController.h"

@interface RadioProgramViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic,strong) NSArray * listTitle;
@end

@implementation RadioProgramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"节目单";
    
    [self.view addSubview:self.magicController.magicView];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];
    [self.magicController.magicView switchToPage:1 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = CoordXSizeScale(30);
        _magicController.magicView.navigationHeight = 32;
        _magicController.magicView.itemWidth = kMainScreenWidth/self.listTitle.count;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSArray *)listTitle
{
    if (!_listTitle) {
        _listTitle = @[@"昨天",@"今天",@"明天"];
    }
    return _listTitle;
}

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
        menuItem.titleLabel.font = FontPFRegular(14.0f);
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString * recomId = nil;
    recomId = [NSString stringWithFormat:@"recom.identifier %ld",pageIndex];
    RadioProgramDetailViewController * contentVC = [magicView dequeueReusablePageWithIdentifier:recomId];
    
    if (pageIndex == 0) {
        if (!contentVC) {
            contentVC = [[RadioProgramDetailViewController alloc] initWithTimeType:yesterdayType];
        }
    }else if (pageIndex == 1){
        if (!contentVC) {
            contentVC = [[RadioProgramDetailViewController alloc] initWithTimeType:todayType];
        }
    }else if(pageIndex == 2){
        if (!contentVC) {
            contentVC = [[RadioProgramDetailViewController alloc] initWithTimeType:tomorrowType];
        }
    }
    contentVC.channelId = _channelId;
    return contentVC;
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
