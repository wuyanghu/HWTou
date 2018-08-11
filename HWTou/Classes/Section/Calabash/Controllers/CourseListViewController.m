//
//  CourseListViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CourseListViewController.h"

#import "VTMagic.h"
#import "PublicHeader.h"

#import "CourseModel.h"
#import "CalabashColViewController.h"
#import "CourseDetailsViewController.h"
#import "CalabashSearchViewController.h"

@interface CourseListViewController ()<CalabashColViewControllerDelegate,
VTMagicViewDataSource,VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *m_MagicController;

@end

@implementation CourseListViewController
@synthesize m_MagicController;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
//    [self setTitle:@"课程列表"];
    
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
    
//    [self addSearchBar];
    [self addViews];
    
}

- (void)addSearchBar{

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth * 0.8, 32)];

    [titleView.layer setCornerRadius:6.0];
    [titleView.layer setMasksToBounds:YES];
    [titleView setBackgroundColor:UIColorFromHex(NAVIGATION_SEARCHBAR_GRAY_BG)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(tapGestureFloor:)];

    [titleView addGestureRecognizer:tapGesture];

    
    UIImageView *searchImgView = [BasisUITool getImageViewWithImage:NAVIGATION_IMG_SEARCH_ICO
                                              withIsUserInteraction:NO];
    
    [titleView addSubview:searchImgView];
    
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                          size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [titleLbl setText:@"搜索您想要的课程"];
    [titleView addSubview:titleLbl];
    
    [self.navigationItem setTitleView:titleView];

    [searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(titleView);
        make.trailing.equalTo(titleLbl.leading).offset(-5);
        make.size.equalTo(CGSizeMake(14, 14));
        
    }];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(titleView);
        
    }];
    
}

- (void)addViews{

    VTMagicController *magicController = [[VTMagicController alloc] init];
    
    [magicController.magicView setDelegate:self];
    [magicController.magicView setDataSource:self];
    
    [magicController.magicView setSliderHeight:2.5];
    [magicController.magicView setSliderExtension:8];
    [magicController.magicView setNavigationHeight:32];
    [magicController.magicView setItemWidth:kMainScreenWidth/2];
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
    
    return @[@"最新课程",@"所有课程"];
    
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
    
    CalabashColViewController *calabashColVC = [magicView dequeueReusablePageWithIdentifier:recomId];
    
    if (!calabashColVC) {
        
        calabashColVC = [[CalabashColViewController alloc] init];
        
        [calabashColVC setM_Delegate:self];

    }
    
    CalabashColType colType = pageIndex == 0 ? CalabashColType_NewCourse : CalabashColType_AllCourse;
    
    [calabashColVC setCalabashColViewType:colType];
    
    return calabashColVC;
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - UITapGestureRecognizer Handler
- (void)tapGestureFloor:(UITapGestureRecognizer *)tapGesture{

    CalabashSearchViewController *calabashSearchVC = [[CalabashSearchViewController alloc] init];
    
    [calabashSearchVC setCalabashSearchColViewType:CalabashColType_AllCourse];
    
    [self.navigationController pushViewController:calabashSearchVC animated:YES];
    
}

#pragma mark - CalabashColViewController Delegate Manager
- (void)onViewSelectedInformationWithColType:(CalabashColType)colType withDataSource:(NSObject *)object{
    
    switch (colType) {
        case CalabashColType_NewCourse:
            
        case CalabashColType_AllCourse:{
            
            if ([object isKindOfClass:[CourseModel class]]) {
                
                CourseDetailsViewController *courseDetailsVC = [[CourseDetailsViewController alloc] init];
                
                [courseDetailsVC setCourseDetailsViewControllerDataSource:(CourseModel *)object];
                
                [self.navigationController pushViewController:courseDetailsVC animated:YES];
                
            }
            
            break;}
        case CalabashColType_Teachers:{
            
            
            
            break;}
        default:
            break;
    }
    
}

@end
