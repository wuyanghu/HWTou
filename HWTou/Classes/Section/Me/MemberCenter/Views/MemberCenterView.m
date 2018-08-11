//
//  MemberCenterView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MemberCenterView.h"

#import "PublicHeader.h"

#import "TaskCell.h"
#import "LevelView.h"
#import "PersonalInfoReq.h"

#define kDIC_Title          (@"Title")
#define kDIC_Array          (@"Array")

#define MemberCenterCellID (@"MemberCenterCellID")

#define MemberCenterSectionHeaderTitleTag   (98)

@interface MemberCenterView()<TaskCellDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *m_TableView;

@property (nonatomic, strong) UIView *m_TableHeaderView;

@property (nonatomic, strong) UIImageView *m_AvatarImgView;
@property (nonatomic, strong) UIImageView *m_MarkImgView;
@property (nonatomic, strong) UILabel *m_NicknameLbl;
@property (nonatomic, strong) UILabel *m_IntegralLbl;
@property (nonatomic, strong) LevelView *m_LevelView;

@property (nonatomic, strong) NSMutableArray *m_TableArray;

@end

@implementation MemberCenterView
@synthesize m_Delegate;

@synthesize m_TableView;

@synthesize m_TableHeaderView;
@synthesize m_AvatarImgView,m_MarkImgView;
@synthesize m_NicknameLbl,m_IntegralLbl;
@synthesize m_LevelView;

@synthesize m_TableArray;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addMainView];
        
        [self setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addTableView];
    
}

- (void)addTableView{

    UITableView *tableView = [BasisUITool getTableViewWithFrame:CGRectZero
                                                          style:UITableViewStylePlain
                                                       delegate:self
                                                     dataSource:self
                                                  scrollEnabled:YES
                                                 separatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *tableHeaderView = [self createTableHeaderViewWithFrame:
                               CGRectMake(0, 0, kMainScreenWidth, 183)];

    [tableView setTableHeaderView:tableHeaderView];
    
    [tableView setRowHeight:CoordXSizeScale(84)];
    [tableView setSectionHeaderHeight:CoordXSizeScale(35)];
    [tableView setSectionFooterHeight:CoordXSizeScale(10)];
    
    [tableView registerClass:[TaskCell class] forCellReuseIdentifier:MemberCenterCellID];
    
    [self setM_TableView:tableView];
    [self addSubview:tableView];
    
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        
    }];
    
    // 下拉刷新
    
    WeakObj(self);
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [selfWeak loadNewData];
        
    }];
    
    [header.lastUpdatedTimeLabel setHidden:YES];
    
    tableView.mj_header = header;

}

#pragma mark - UITableViewDataSource Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [m_TableArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *dic;
    OBJECTOFARRAYATINDEX(dic, m_TableArray, section);
    
    NSArray *array;
    OBJECTOFNSDICTIONARYBYKEY(array, dic, kDIC_Array);
    
    return [array count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [self createTableSectionHeaderView];
    
    NSDictionary *dic;
    OBJECTOFARRAYATINDEX(dic, m_TableArray, section);
    
    NSString *titleStr;
    OBJECTOFNSDICTIONARYBYKEY(titleStr, dic, kDIC_Title);
    
    UILabel *lbl = [headerView viewWithTag:MemberCenterSectionHeaderTitleTag];
    
    [lbl setText:titleStr];
    
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [self createTableSectionFooterView];
    
    return footerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];

    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberCenterCellID];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dic;
    OBJECTOFARRAYATINDEX(dic, m_TableArray, section);
    
    NSArray *array;
    OBJECTOFNSDICTIONARYBYKEY(array, dic, kDIC_Array);
    
    TaskModel *model;
    OBJECTOFARRAYATINDEX(model, array, row);
    
    [cell setM_Delegate:self];
    
    [cell setTaskCellWithDataSource:model withIsEnd:row + 1 == [array count] ? YES : NO
          withCellForRowAtIndexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
}

#pragma mark - 获取数据源
- (void)accessDataSource{
    
    [self obtainPersonalInfo];
    
}

#pragma mark - 下拉刷新数据
- (void)loadNewData{
    
    // 马上进入刷新状态
    [m_TableView.mj_header beginRefreshing];
    
    [self accessDataSource];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    if (IsNilOrNull(m_TableArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [tmpArray addObjectsFromArray:@[
  @{kDIC_Title:@"理财任务", kDIC_Array:@[[self createTaskModelWithTaskType:TaskType_Investment
                                                             withTitle:@"投资任务"
                                                            withRemark:@"投资相应的金额获得相应积分。"
                                                           withImgName:ME_IMG_ACTIVITY_DEFAULT]]},
  @{kDIC_Title:@"购物任务", kDIC_Array:@[[self createTaskModelWithTaskType:TaskType_Shopping
                                                             withTitle:@"购物"
                                                            withRemark:@"购买相应的金额获得相应积分。"
                                                           withImgName:ME_IMG_ACTIVITY_DEFAULT],
                                     [self createTaskModelWithTaskType:TaskType_Evaluation
                                                             withTitle:@"评价"
                                                            withRemark:@"完成购物评价获得积分。"
                                                           withImgName:ME_IMG_ACTIVITY_DEFAULT]]},
  @{kDIC_Title:@"活动任务", kDIC_Array:@[[self createTaskModelWithTaskType:TaskType_Activity
                                                             withTitle:@"参加活动"
                                                            withRemark:@"参加相应的活动获得相应积分。"
                                                           withImgName:ME_IMG_ACTIVITY_DEFAULT],
                                     [self createTaskModelWithTaskType:TaskType_EvaluationActivity
                                                             withTitle:@"评价活动"
                                                            withRemark:@"完成相应活动的评价获得积分。"
                                                           withImgName:ME_IMG_ACTIVITY_DEFAULT]]}
                     ]];
        
        [self setM_TableArray:tmpArray];
        
    }
    
}

- (TaskModel *)createTaskModelWithTaskType:(TaskType)taskType withTitle:(NSString *)title
                                withRemark:(NSString *)remark withImgName:(NSString *)imgName{

    TaskModel *model = [[TaskModel alloc] init];
    
    [model setM_TaskType:taskType];
    [model setM_Title:title];
    [model setM_Remark:remark];
    [model setM_ImgName:imgName];
    
    return model;
    
}

- (void)setMemberInfo:(PersonalInfoDM *)model{
    
    if (IsNilOrNull(model)) {
        
        [self obtainPersonalInfo];
        
    }else{
        
        [self updateMemberInfo:model];
        
    }
    
}

- (void)updateMemberInfo:(PersonalInfoDM *)model{

    if (IsStrEmpty(model.head_url)) {
        
        [m_AvatarImgView setImage:ImageNamed(PUBLIC_IMG_SYSTEM_AVATAR)];
        
    }else{
        
        NSString *urlStr = model.head_url;
        
        NSURL *url = [NSURL URLWithString:
                      [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [m_AvatarImgView sd_setImageWithURL:url placeholderImage:ImageNamed(PUBLIC_IMG_SYSTEM_AVATAR) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            // 圆处理
            CGSize size = m_AvatarImgView.bounds.size;
            
            CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:MIN(size.width, size.height)];
            
            [m_AvatarImgView.layer setMask:shape];
            
        }];
        
        
    }
    
    [m_NicknameLbl setText:model.nickname];
    
    NSString *vipLevel;
    
    switch (model.level) {
        case 1:{
            
            vipLevel = VIP_MARK_LEVEL_ONE_ICO;
            
            break;}
        case 2:{
            
            vipLevel = VIP_MARK_LEVEL_TWO_ICO;
            
            break;}
        case 3:{
            
            vipLevel = VIP_MARK_LEVEL_THREE_ICO;
            
            break;}
        default:{
            
            vipLevel = VIP_MARK_LEVEL_ZERO_ICO;
            
            break;}
    }
    
    [m_MarkImgView setImage:ImageNamed(vipLevel)];
    
    [m_LevelView updateSelectLevel:[NSString stringWithFormat:@"V%zd",model.level]];
    
    [m_IntegralLbl setText:[NSString stringWithFormat:@"当前积分:%zd",model.score]];
    
}

- (UIView *)createTableHeaderViewWithFrame:(CGRect)frame{
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:frame];
    
    UIView *bgView = [[UIView alloc] init];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    [tableHeaderView addSubview:bgView];
    
    // 头像
    UIImageView *avatarImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR
                                              withIsUserInteraction:NO];
    
    [avatarImgView setContentMode:UIViewContentModeScaleToFill];
    
    [self setM_AvatarImgView:avatarImgView];
    [bgView addSubview:avatarImgView];
    
    // 昵称
    UILabel *nicknameLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                             size:CLIENT_COMMON_FONT_TITLE_INCREASE_SIZE];
    
    [self setM_NicknameLbl:nicknameLbl];
    [bgView addSubview:nicknameLbl];
    
    // 会员等级
    UIImageView *markImgView = [BasisUITool getImageViewWithImage:VIP_MARK_LEVEL_ZERO_ICO
                                            withIsUserInteraction:NO];
    
    [self setM_MarkImgView:markImgView];
    [bgView addSubview:markImgView];
    
    // 积分说明
    UILabel *integralLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                             size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [integralLbl setText:@"当前积分: 0"];
    
    [self setM_IntegralLbl:integralLbl];
    [bgView addSubview:integralLbl];
    
    // 会员等级说明
    UIButton *lvInfoBtn = [BasisUITool getBtnWithTarget:self action:@selector(lvInfoBtnClick:)];
    
    [lvInfoBtn.layer setCornerRadius:0];
    [lvInfoBtn.layer setMasksToBounds:NO];
    
    [bgView addSubview:lvInfoBtn];
    
    UILabel *lvInfoLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                           size:CLIENT_COMMON_FONT_DETAILS_SIZE];
    
    [lvInfoLbl setText:@"等级说明"];
    [lvInfoLbl setTextAlignment:NSTextAlignmentRight];
    
    [bgView addSubview:lvInfoLbl];
    
    UIImageView *extImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_EXTENSION_ICO
                                           withIsUserInteraction:NO];
    
    [bgView addSubview:extImgView];

    // 积分等级
    NSArray *names = @[@"V0", @"V1", @"V2", @"V3"];
    NSArray *icons = @[VIP_CROWN_LEVEL_ZERO_ICO, VIP_CROWN_LEVEL_ONE_ICO, VIP_CROWN_LEVEL_TWO_ICO,
                       VIP_CROWN_LEVEL_THREE_ICO];
    
    LevelView *levelView = [[LevelView alloc] initWithFrame:CGRectZero
                                                      Names:names
                                                      icons:icons];
    
    [self setM_LevelView:levelView];
    [bgView addSubview:levelView];
    
    /* ********* HeaderView layout ********** */
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tableHeaderView);
        make.left.and.right.equalTo(tableHeaderView);
        make.bottom.equalTo(tableHeaderView).offset(-10);
        
    }];
    
    [avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView).offset(14);
        make.leading.equalTo(bgView).offset(12);
        make.trailing.equalTo(nicknameLbl.mas_leading).offset(-16);
        make.size.equalTo(CGSizeMake(65, 65));
        
    }];
    
    [nicknameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(avatarImgView).offset(5);
        make.trailing.equalTo(markImgView.mas_leading).offset(-8);
        make.height.equalTo(20);
        
    }];
    
    [markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGSize size = markImgView.frame.size;
        
        make.centerY.equalTo(nicknameLbl.mas_centerY);
        make.size.equalTo(CGSizeMake(size.width, size.height));
        
    }];
    
    [integralLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nicknameLbl.mas_bottom).offset(15);
        make.leading.equalTo(nicknameLbl);
        make.width.greaterThanOrEqualTo(@0.f);
        make.width.lessThanOrEqualTo(CoordXSizeScale(175));
        
    }];
    
    [lvInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGSize size = [BasisUITool calculateSize:lvInfoLbl.text font:lvInfoLbl.font];
        
        make.centerY.equalTo(integralLbl);
        make.trailing.equalTo(extImgView.mas_leading).offset(-8);
        make.width.equalTo(size);
        
    }];
    
    [extImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGSize size = extImgView.frame.size;
        
        make.centerY.equalTo(lvInfoLbl.mas_centerY);
        make.trailing.equalTo(bgView).offset(-12);
        make.size.equalTo(CGSizeMake(size.width, size.height));
        
    }];
    
    [lvInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(lvInfoLbl);
        make.leading.equalTo(lvInfoLbl);
        make.trailing.equalTo(extImgView);
        make.height.equalTo(30);
        
    }];
    
    [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(integralLbl.mas_bottom).offset(16);
        make.centerX.equalTo(bgView.mas_centerX).offset(- (levelView.frame.size.width / 2));
        
    }];
    
    /* ********* HeaderView layout end ********** */
    
    return tableHeaderView;
    
}

- (UIView *)createTableSectionHeaderView{

    UIView *headerView = [[UIView alloc] init];
    
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    // 标题
    UILabel *lbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                     size:CLIENT_COMMON_FONT_DETAILS_SIZE];
    
    [lbl setTag:MemberCenterSectionHeaderTitleTag];
    [headerView addSubview:lbl];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [headerView addSubview:lineView];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(headerView.mas_centerY);
        make.left.equalTo(headerView).offset(10);
        make.right.equalTo(headerView).offset(-10);
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(headerView.mas_bottom);
        make.left.and.right.equalTo(headerView);
        make.height.equalTo(0.5);
        
    }];
    
    return headerView;
    
}

- (UIView *)createTableSectionFooterView{
    
    UIView *footerView = [[UIView alloc] init];
    
    return footerView;
    
}

#pragma mark - Button Handlers
- (void)lvInfoBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onDidLevelDescription)]) {
        
        [m_Delegate onDidLevelDescription];
        
    }
    
}

#pragma mark - TaskCell Delegate Manager
- (void)onSelTaskItem:(TaskModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onDidSelTask:)]) {
        
        [m_Delegate onDidSelTask:model];
        
    }
    
}

#pragma mark - NetworkRequest Manager
- (void)obtainPersonalInfo{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [PersonalInfoReq personalInfoSuccess:^(PersonalInfoResp *response) {
        
        if (response.success) {
            
            [self updateMemberInfo:response.data];
            
            [HUDProgressTool dismiss];
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
        [m_TableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [m_TableView.mj_header endRefreshing];
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
