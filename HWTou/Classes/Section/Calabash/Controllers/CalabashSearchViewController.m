//
//  CalabashSearchViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CalabashSearchViewController.h"

#import "PYSearch.h"
#import "PublicHeader.h"
#import "CustomNavigationController.h"

#import "CourseModel.h"

#import "CourseDetailsViewController.h"

@interface CalabashSearchViewController ()<PYSearchViewControllerDelegate,CalabashColViewDelegate>{

    CalabashColType g_ColType;
    
}

@property (nonatomic, strong) UILabel *m_SearchLbl;
@property (nonatomic, strong) PYSearchViewController *m_SearchVC;

@property (nonatomic, strong) CalabashColView *m_CalabashColView;


@end

@implementation CalabashSearchViewController
@synthesize m_SearchLbl;
@synthesize m_SearchVC;
@synthesize m_CalabashColView;

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self dataInitialization];
        [self addMainView];
        
    }
    
    return self;
    
}

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
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
    [self addCalabashColView];
    
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
    
    [titleLbl setText:@"搜索您想要的内容"];
    
    [self setM_SearchLbl:titleLbl];
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

- (PYSearchViewController *)m_SearchVC{

    if (IsNilOrNull(m_SearchVC)) {
        
        PYSearchViewController *searchVC = [PYSearchViewController searchViewControllerWithHotSearches:[NSArray array] searchBarPlaceholder:@"搜索您想要的内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            
            if (IsStrEmpty(searchText)) {
                
                [m_SearchLbl setText:searchViewController.searchBar.placeholder];
                
            }else{
                
                [m_SearchLbl setText:searchText];
                
                [m_CalabashColView setCalabashColViewType:g_ColType withSearchKey:searchText];
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
                [searchViewController dismissViewControllerAnimated:YES completion:nil];
                
            });
            
        }];
        // 3.设置风格
        [searchVC setHotSearchStyle:PYHotSearchStyleDefault]; // 热门搜索风格为默认
        [searchVC setSearchHistoryStyle:PYSearchHistoryStyleDefault]; // 搜索历史风格根据选择
        
        // 4. 设置代理
        [searchVC setDelegate:self];
        
        [self setM_SearchVC:searchVC];
        
    }
    
    return m_SearchVC;
    
}

- (void)addCalabashColView{

    CalabashColView *calabashColView = [[CalabashColView alloc] init];
    
    [calabashColView setM_Delegate:self];
    
    [self setM_CalabashColView:calabashColView];
    [self.view addSubview:calabashColView];
    
    [calabashColView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{

    g_ColType = CalabashColType_Unknown;
    
}

- (void)setCalabashSearchColViewType:(CalabashColType)colType{
    
    g_ColType = colType;
    
    if (colType == CalabashColType_NewCourse || colType == CalabashColType_AllCourse) {

        [m_SearchLbl setText:@"搜索您想要的课程"];
        [self.m_SearchVC.searchBar setPlaceholder:m_SearchLbl.text];
        
    }
    
    // 延迟执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CustomNavigationController *nav = [[CustomNavigationController alloc]
                                           initWithRootViewController:self.m_SearchVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
    });
    
}

#pragma mark - UITapGestureRecognizer Handler
- (void)tapGestureFloor:(UITapGestureRecognizer *)tapGesture{
    
    CustomNavigationController *nav = [[CustomNavigationController alloc]
                                       initWithRootViewController:self.m_SearchVC];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - CalabashColView Delegate Manager
- (void)onSelCalabashColViewWithColType:(CalabashColType)colType withDataSource:(NSObject *)object{
    
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
