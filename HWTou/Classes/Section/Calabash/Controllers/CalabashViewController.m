//
//  CalabashViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/30.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CalabashViewController.h"

#import "VTMagic.h"
#import "PublicHeader.h"

#import "BannerAdDM.h"
#import "BannerAdReq.h"
#import "ComFloorEvent.h"
#import "ComCarouselView.h"
#import "MomentsViewController.h"
#import "CourseListViewController.h"
#import "TeacherListViewController.h"
#import "CalabashColViewController.h"
#import "CourseDetailsViewController.h"
#import "TeacherDetailsViewController.h"

#define kReqNum         3

typedef NS_ENUM(NSInteger, CalabashFucnType){
    
    CalabashFucnType_Course = 1,    // 课程
    CalabashFucnType_Teachers,      // 教师
    CalabashFucnType_Moments,       // 朋友圈
    
};

@interface CalabashViewController ()<CalabashColViewControllerDelegate,ComCarouselViewDelegate,
VTMagicViewDataSource,VTMagicViewDelegate>{

    NSInteger g_ReqNum;
    NSUInteger g_CurrentPage;
    
}

@property (nonatomic, copy) NSArray<BannerAdDM *> *banners;
@property (nonatomic, strong) ComCarouselImageView *m_ComBanner;        // 滑动广告
@property (nonatomic, strong) UIView *m_FucnView;

@property (nonatomic, strong) VTMagicController *m_MagicController;

@property (nonatomic, strong) NSMutableArray *m_AdsArray;               // 缓存广告 list <BannerAdDM>

@end

@implementation CalabashViewController
@synthesize m_ComBanner;
@synthesize m_FucnView;
@synthesize m_MagicController;

@synthesize m_AdsArray;

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

        [self setTitle:@"乐葫芦"];
        [self dataInitialization];
        [self addMainView];
        
        [self.view setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
        
    }
    
    return self;
    
}

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self obtainAdvertisingPictureList];
    
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
    
    [self addSlidingAdvertisingView];
    [self addFucnView];
    [self addTabView];
    
}

- (void)addSlidingAdvertisingView{
    
    ComCarouselImageView *comBanner = [[ComCarouselImageView alloc] init];
    
    [comBanner setDelegate:self];
    
    [self setM_ComBanner:comBanner];
    [self.view addSubview:comBanner];
    
    [comBanner makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(comBanner.width).multipliedBy(0.5);
        
    }];
    
}

- (void)addFucnView{
    
    UIView *bgView = [[UIView alloc] init];
    
    // 课程
    UIView *courseView = [self createFucnBtnViewWithTag:CalabashFucnType_Course
                                              withTitle:@"课程"
                                                withIco:CALABASH_FUNC_COURSE_ICO];
    
    [bgView addSubview:courseView];
    
    // 教师
    UIView *teachersView = [self createFucnBtnViewWithTag:CalabashFucnType_Teachers
                                                withTitle:@"教师"
                                                  withIco:CALABASH_FUNC_TEACHERS_ICO];
    
    [bgView addSubview:teachersView];
    
    // 朋友圈
    UIView *momentsView = [self createFucnBtnViewWithTag:CalabashFucnType_Moments
                                               withTitle:@"朋友圈"
                                                 withIco:CALABASH_FUNC_MOMENTS_ICO];
    
    [bgView addSubview:momentsView];
    
    [self setM_FucnView:bgView];
    [self.view addSubview:bgView];
    
    // layout
    CGFloat spacingWidth = 1;
    CGFloat fucnWidth = (kMainScreenWidth - spacingWidth * 2) / 3;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_ComBanner.mas_bottom);
        make.leading.and.trailing.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kMainScreenWidth, CoordYSizeScale(126)));
        
    }];
    
    [courseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.height.equalTo(bgView);
        make.width.equalTo(fucnWidth);
        
    }];
    
    [teachersView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(courseView);
        make.leading.equalTo(courseView.trailing).offset(spacingWidth);
        make.size.equalTo(courseView);
        
    }];
    
    [momentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(teachersView);
        make.leading.equalTo(teachersView.trailing).offset(spacingWidth);
        make.size.equalTo(teachersView);
        
    }];
    
}

- (void)addTabView{
    
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
        
        make.top.equalTo(m_FucnView.mas_bottom).offset(CoordYSizeScale(10));
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        
    }];
    
    [m_MagicController.magicView reloadData];
    
    [m_MagicController switchToPage:g_CurrentPage animated:NO];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    g_ReqNum = 0;
    g_CurrentPage = 0;
    
    if (IsNilOrNull(m_AdsArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [self setM_AdsArray:tmpArray];
        
    }
    
}

- (UIView *)createFucnBtnViewWithTag:(CalabashFucnType)type withTitle:(NSString *)title
                             withIco:(NSString *)ico{
    
    UIView *bgView = [[UIView alloc] init];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                     size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [lbl setText:title];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    
    [bgView addSubview:lbl];
    
    UIImageView *imgView = [BasisUITool getImageViewWithImage:ico withIsUserInteraction:NO];
    
    [bgView addSubview:imgView];
    
    UIButton *btn = [BasisUITool getBtnWithTarget:self action:@selector(fucnBtnClick:)];
    
    [btn setTag:type];
    
    [bgView addSubview:btn];
    
    // layout
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(CoordYSizeScale(20));
        make.left.and.right.equalTo(bgView);
        
    }];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGSize imgSize = imgView.frame.size;
        
        make.top.equalTo(lbl.mas_bottom).offset(CoordYSizeScale(15));
        make.centerX.equalTo(lbl.mas_centerX);
        make.size.equalTo(CGSizeMake(CoordXSizeScale(imgSize.width),CoordYSizeScale(imgSize.height)));
        
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(bgView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
    return bgView;
    
}

#pragma mark - Button Handlers
- (void)fucnBtnClick:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    CalabashFucnType type = [btn tag];
    
    UIViewController *vc;
    
    switch (type) {
        case CalabashFucnType_Course:{// 课程
            
            vc = [[CourseListViewController alloc] init];
            
            break;}
        case CalabashFucnType_Teachers:{// 教师
            
            vc = [[TeacherListViewController alloc] init];
            
            break;}
        case CalabashFucnType_Moments:{// 朋友圈
            
            vc = [[MomentsViewController alloc] init];
            
            break;}
        default:
            break;
    }

    if (!IsNilOrNull(vc)) [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - VTMagicViewDataSource Manager
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView{
    
    return @[@"热门课程",@"热门教师"];
    
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
    
    CalabashColType colType = pageIndex == 0 ? CalabashColType_AllCourse : CalabashColType_Teachers;
    
    [calabashColVC setCalabashColViewType:colType];
    
    return calabashColVC;
    
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
            
            /*
            // 教师详情无需展示
            if ([object isKindOfClass:[TeacherModel class]]){

                TeacherDetailsViewController *teacherDetailsVC = [[TeacherDetailsViewController alloc] init];
                
                [teacherDetailsVC setTeacherDetailsDataSource:(TeacherModel *)object];
                
                [self.navigationController pushViewController:teacherDetailsVC animated:YES];
                
            }
            */
            
            break;}
        default:
            break;
    }
    
}

#pragma mark - ComCarouselViewDelegate
- (void)carouselView:(ComCarouselView *)view didSelectItemAtIndex:(NSInteger)index
{
    BannerAdDM *banner = [self.banners objectAtIndex:index];
    [ComFloorEvent handleEventWithFloor:banner];
}

#pragma mark - NetworkRequest Manager
- (void)obtainAdvertisingPictureList{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    BannerAdParam *bParam = [[BannerAdParam alloc] init];
    
    [bParam setType:BannerAdCalabash];
    
    [BannerAdReq bannerWithParam:bParam success:^(BannerAdResp *response) {
        
        if (response.success) {
            
            g_ReqNum = 0;
            
            if (!IsArrEmpty(m_AdsArray)) [m_AdsArray removeAllObjects];
            
            [m_AdsArray addObjectsFromArray:response.data.list];
            
            NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:[m_AdsArray count]];
            
            [m_AdsArray enumerateObjectsUsingBlock:^(BannerAdDM *obj, NSUInteger idx, BOOL *stop) {
                
                [urlArray addObject:obj.img_url];
                
            }];
            
            self.banners = response.data.list;
            
            [m_ComBanner setImageURLStringsGroup:urlArray];
            
            [HUDProgressTool dismiss];
            
        }else{
            
            if (g_ReqNum < kReqNum) {
             
                // 延迟执行
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self obtainAdvertisingPictureList];
                    
                });
                
            }

//            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        if (g_ReqNum < kReqNum) {
            
            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self obtainAdvertisingPictureList];
                
            });
            
        }
        
//        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
