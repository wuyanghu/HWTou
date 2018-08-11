//
//  SearchViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SearchViewController.h"
#import "RotRequest.h"
#import "SearchViewModel.h"
#import "VTMagicController.h"
#import "PublicHeader.h"
#import "SearchContentViewController.h"

@interface SearchViewController ()<VTMagicViewDataSource,VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic,strong) NSArray * listTitle;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self addNavBarView];
    self.title = @"搜索结果";
    [self.view addSubview:self.magicController.magicView];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];

}


- (void)addNavBarView{
    
    UIView * navbarview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    [self.view addSubview:navbarview];
    
    UIButton *msgBtn = [BasisUITool getBtnWithTarget:self
                                              action:@selector(buttonSelected:)];
    [msgBtn setTitle:@"取消" forState:UIControlStateNormal];
    [msgBtn setTitleColor:UIColorFromHex(0x8E8F91) forState:UIControlStateNormal];
    [msgBtn.titleLabel setFont:FontPFRegular(17)];
    msgBtn.tag = 0;
    [navbarview addSubview:msgBtn];
    
    UILabel *labNavTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333)
                                                         size:NAVIGATION_FONT_TITLE_SIZE];
    labNavTitle.textAlignment = NSTextAlignmentCenter;
    [labNavTitle setText:@"搜索结果"];
    [navbarview addSubview:labNavTitle];
    
    
    [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(40, 34));
        make.bottom.equalTo(navbarview).offset(-5);
        make.left.equalTo(navbarview).offset(10);
    }];
    
    [labNavTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(150,34));
        make.left.equalTo((kMainScreenWidth-150)/2);
        make.bottom.equalTo(msgBtn);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonSelected:(UIButton *)button{
    
}

#pragma mark - magicController

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
    recomId = [NSString stringWithFormat:@"identifier %ld",pageIndex];
    SearchContentViewController * contentVC = [magicView dequeueReusablePageWithIdentifier:recomId];
    if (!contentVC) {
        contentVC = [[SearchContentViewController alloc] init];
        contentVC.searchVCBlock = ^(GuessULikeModel * likeModel){
            [Navigation showAudioPlayerViewController:self radioModel:likeModel];
        };
        contentVC.searchUserVCBlock = ^(PersonHomeDM *personHomeDM) {
            [Navigation showPersonalHomePageViewController:self attendType:[personHomeDM isSelfUid] == 0?editDataButtonType:dynamicButtonType uid:[personHomeDM isSelfUid]];
        };
    }
    contentVC.keywords = _keywords;
    if (pageIndex == 0) {
        contentVC.type = searchChatType;
    }else if (pageIndex == 1) {
        contentVC.type = searchTopicType;
    }else if (pageIndex == 2){
        contentVC.type = searchRadioType;
    }else if (pageIndex == 3){
        contentVC.type = searchUserType;
    }
    return contentVC;
}

#pragma mark - getter

- (NSArray *)listTitle
{
    if (!_listTitle) {
        _listTitle = @[@"聊吧",@"主播",@"电台",@"用户"];
    }
    return _listTitle;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
