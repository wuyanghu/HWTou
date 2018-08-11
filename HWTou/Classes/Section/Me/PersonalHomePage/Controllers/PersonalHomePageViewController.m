//
//  PersonalHomePageViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonalHomePageViewController.h"
#import "PersonHomePageView.h"
#import "PublicHeader.h"
#import "PersonInfoViewController.h"
#import "PersonalAttendViewController.h"
#import "PersonDynamicStateViewController.h"
#import "PersonTopicViewController.h"
#import "PersonEditDataViewController.h"
#import "PersonHomeReq.h"
#import "TopicWorkDetailModel.h"

@interface PersonalHomePageViewController ()<PersonInfoViewControllerDelegate,PersonHomePageViewDelegate,PersonDynamicStateViewControllerDelegate,PersonTopicViewControllerDelegate,UIScrollViewDelegate>
{
    UIScrollView * scrollView;
}
@property (nonatomic,strong) PersonHomePageView * personHomePageView;
@property (nonatomic, strong) PersonInfoViewController * infoVC;
@property (nonatomic, strong) PersonDynamicStateViewController * stateVC;
@property (nonatomic, strong) PersonTopicViewController *topicVC;

@end

@implementation PersonalHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"个人主页"];
    [self addView];
    
}

- (void)addView{
    scrollView = [[UIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(kMainScreenWidth*2,0);
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [scrollView addSubview:self.infoVC.view];
//    [scrollView addSubview:self.stateVC.view];
    
    [self.infoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(5);
        make.left.equalTo(scrollView);
        make.height.equalTo(kMainScreenHeight-64);
        make.width.equalTo(kMainScreenWidth);
        
    }];
//
//    [self.stateVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(scrollView).offset(5);
//        make.left.equalTo(self.infoVC.view.mas_right);
//        make.width.equalTo(kMainScreenWidth);
//        make.height.equalTo(kMainScreenHeight-64);
//    }];
//
//    if (_isHost) {
//        scrollView.contentSize = CGSizeMake(kMainScreenWidth*3,0);
//        [scrollView addSubview:self.topicVC.view];
//
//        [self.topicVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(scrollView).offset(5);
//            make.left.equalTo(self.stateVC.view.mas_right);
//            make.width.equalTo(kMainScreenWidth);
//            make.height.equalTo(kMainScreenHeight-64);
//        }];
//    }
//
//
    [self.view addSubview:self.personHomePageView];
//    if (_isHost) {
//        [scrollView setContentOffset:CGPointMake(kMainScreenWidth*2, 0) animated:NO];
//    }else{
//        [scrollView setContentOffset:CGPointMake(kMainScreenWidth, 0) animated:NO];
//    }
    
}

- (void)segmentChange:(UISegmentedControl *)segmentedControl{
    self.personHomePageView.segment.selectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [scrollView setContentOffset:CGPointMake(kMainScreenWidth*segmentedControl.selectedSegmentIndex, 0) animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self request];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView{
    [self request];
    [self.stateVC requestUserDynamic:YES];
}

- (void)request{
    UserInfoParam * homeParam = [UserInfoParam new];
    if (_buttonType == editDataButtonType) {
        homeParam.uid = 0;
    }else{
        homeParam.uid = _uid;
    }
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    //个人资料
    [PersonHomeRequest getUserInfo:homeParam Success:^(PersonHomeResponse *response) {
        [HUDProgressTool dismiss];
        [self.personHomePageView setPersonHomeModel:response.data];
        
        [self.infoVC setPersonHomeModel:response.data];
        self.infoVC.personHomeModel.isSelf = _buttonType == editDataButtonType?YES:NO;
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];

}


#pragma mark - 底部的scrollView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger kItemheight = 40;
    CGFloat placeholderOffset = 0;
    if (self.personHomePageView.segment.selectedSegmentIndex == 0) {
        if (self.infoVC.tableView.contentOffset.y > self.personHomePageView.frame.size.height - kItemheight) {
            placeholderOffset = self.personHomePageView.frame.size.height - kItemheight;
        }
        else {
            placeholderOffset = self.infoVC.tableView.contentOffset.y;
        }
        [self.stateVC.tableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
        [self.topicVC.tableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }
    else if(self.personHomePageView.segment.selectedSegmentIndex == 1){
        if (self.stateVC.tableView.contentOffset.y > self.personHomePageView.frame.size.height - kItemheight) {
            placeholderOffset = self.personHomePageView.frame.size.height - kItemheight;
        }
        else {
            placeholderOffset = self.stateVC.tableView.contentOffset.y;
        }
        [self.infoVC.tableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
        [self.topicVC.tableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }else{
        if (self.topicVC.tableView.contentOffset.y > self.personHomePageView.frame.size.height - kItemheight) {
            placeholderOffset = self.personHomePageView.frame.size.height - kItemheight;
        }
        else {
            placeholderOffset = self.topicVC.tableView.contentOffset.y;
        }
        [self.infoVC.tableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
        [self.stateVC.tableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }
    NSInteger index = ceilf(scrollView.contentOffset.x / kMainScreenWidth);
    self.personHomePageView.segment.selectedSegmentIndex = index;
}

#pragma mark - PersonDynamicStateViewControllerDelegate

- (void)didSelectRowAtIndexPath:(UserDetailModel *)detailModel{
    [Navigation showAudioPlayerViewController:self radioModel:detailModel];
}

- (void)didTotpicSelectRowAtIndexPath:(MyTopicListModel *)detailModel{
    [Navigation showAudioPlayerViewController:self radioModel:detailModel];
}

#pragma mark - PersonHomePageViewDelegate

- (void)focusSomeOne:(FocusSomeOneParam *)param {
    [PersonHomeRequest focusSomeOne:param Success:^(TopicWorkDetailResponse *response) {
        [HUDProgressTool dismiss];
        if (response.status == 200) {
            NSInteger state = [response.data[@"state"] integerValue];
            [HUDProgressTool showSuccessWithText:state == 0?@"取消关注成功":@"关注成功"];
            [self.personHomePageView isAttend:state];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)buttonClick:(UIButton *)button{
    if (button.tag == 1){//关注列表
        PersonalAttendViewController * attendVC = [[PersonalAttendViewController alloc] init];
        attendVC.uid = _uid;
        attendVC.personalAttendType = personalAttendType;
        [self.navigationController pushViewController:attendVC animated:YES];
    }else if (button.tag == 2){//粉丝列表
        PersonalAttendViewController * attendVC = [[PersonalAttendViewController alloc] init];
        attendVC.uid = _uid;
        attendVC.personalAttendType = personalFansType;
        [self.navigationController pushViewController:attendVC animated:YES];
    }
}

- (void)buttonSelectedEdit:(UIButton *)button{
    if (_buttonType == editDataButtonType) {
        PersonEditDataViewController * editDataVC = [[PersonEditDataViewController alloc] init];
        [editDataVC setPersonHomeModel:self.personHomePageView.personHomeModel];
        [self.navigationController pushViewController:editDataVC animated:YES];
    }else if(_buttonType == dynamicButtonType){
        FocusSomeOneParam * param = [FocusSomeOneParam new];
        param.focusId = [NSString stringWithFormat:@"%ld",_uid];
        [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
        [self focusSomeOne:param];
    }
}

#pragma mark - PersonInfoViewControllerDelegate
- (void)jumpVcDelegate{
    PersonalAttendViewController * attendVC = [[PersonalAttendViewController alloc] init];
    attendVC.personalAttendType = personalAttendType;
    attendVC.uid = _uid;
    [self.navigationController pushViewController:attendVC animated:YES];
}

#pragma mark - getter,setter

-  (void)setIsHost:(BOOL)isHost{
    _isHost = isHost;
    self.personHomePageView.isHost = _isHost;
    if (_isHost) {
        _personHomePageView.segment.selectedSegmentIndex = 2;
    }else{
        _personHomePageView.segment.selectedSegmentIndex = 1;
    }
}

- (void)setButtonType:(PersonHomePageButtonType)buttonType{
    _buttonType = buttonType;
    self.stateVC.editDataButtonType = buttonType;
    [self.personHomePageView setButtonType:buttonType];
}

- (void)setUid:(NSInteger)uid{
    _uid = uid;
    self.stateVC.uid = uid;
}

- (PersonDynamicStateViewController *)stateVC{
    if (!_stateVC) {
        _stateVC = [[PersonDynamicStateViewController alloc] init];
        _stateVC.dynamicDeleagte = self;
        _stateVC.personHomePageView = self.personHomePageView;
    }
    return _stateVC;
}

- (PersonInfoViewController *)infoVC{
    if (!_infoVC) {
        _infoVC = [[PersonInfoViewController alloc] init];
        _infoVC.personInfoDelegate = self;
        _infoVC.personHomePageView = self.personHomePageView;
    }
    return _infoVC;
}

- (PersonTopicViewController *)topicVC {
    if (!_topicVC) {
        _topicVC = [[PersonTopicViewController alloc] init];
        _topicVC.personHomePageView = self.personHomePageView;
        _topicVC.dynamicDeleagte = self;
    }
    return _topicVC;
}

- (PersonHomePageView *)personHomePageView{
    if (!_personHomePageView) {
        _personHomePageView = [[PersonHomePageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 300)];
        _personHomePageView.homePageDelegate = self;
    }
    return _personHomePageView;
}


@end
