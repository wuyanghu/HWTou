//
//  PersonalSetUpView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonalSetUpView.h"

#import "PublicHeader.h"

typedef NS_ENUM(NSInteger,CellFuncType){
    
    CellFuncType_Default = 0,
    CellFuncType_Extension,             // 扩展
    CellFuncType_Switch,                // 开关
    CellFuncType_Text,                  // 文本
    
};

#define kDIC_Ico            (@"Picture")
#define kDIC_Title          (@"Title")
#define kDIC_Subtitle       (@"Subtitle")
#define kDIC_FuncType       (@"FuncType")
#define kDIC_CellFuncType   (@"CellFuncType")

@interface PersonalSetUpView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *m_TableView;
@property (nonatomic, strong) NSArray *m_TableArray;    // list<list<Dic>,list<Dic>>
@property (nonatomic, strong) UISwitch *switchPush;     // 推送开关
@property (nonatomic, strong) UIButton *m_LogOutBtn;

@end

@implementation PersonalSetUpView
@synthesize m_Delegate;
@synthesize m_TableView;
@synthesize m_TableArray;
@synthesize m_LogOutBtn;

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
                                                  scrollEnabled:NO
                                                 separatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self setM_TableView:tableView];
    [self addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        
    }];
    
}

- (void)rrefreshPushState
{
    self.switchPush.on = [self isAllowedNotification];
}

#pragma mark - UITableViewDataSource Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [m_TableArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *tmpArray;
    OBJECTOFARRAYATINDEX(tmpArray, m_TableArray, section);
    
    return [tmpArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height = 10;
    
    if (section + 1 == [m_TableArray count]) {
        
        height = 92;
        
    }
    
    return height;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc] initWithFrame:tableView.tableFooterView.bounds];;

    [bgView setBackgroundColor:[UIColor clearColor]];
    
    if (section + 1 == [m_TableArray count]){

        if (IsNilOrNull(m_LogOutBtn)) {
            
            UIButton *logOutBtn = [BasisUITool getBtnWithTarget:self action:@selector(logOutBtnClick:)];
            
            [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            [logOutBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                                  forState:UIControlStateNormal];
            [logOutBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                                  forState:UIControlStateDisabled];
            
            [self setM_LogOutBtn:logOutBtn];
            [bgView addSubview:logOutBtn];
            
            [logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                CGFloat btnHeight = 40;
                
                make.left.equalTo(bgView).offset(25);
                make.right.equalTo(bgView).offset(-25);
                make.height.equalTo(btnHeight);
                make.top.equalTo(26);
                
            }];
            
        }
        
    }
    
    return bgView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    static NSString *psCellID = @"psCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:psCellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:psCellID];
        
        if (cell.frame.size.width != tableView.frame.size.width) {
            
            CGRect frame = cell.frame;
            
            frame.size.width = tableView.frame.size.width;
            
            [cell setFrame:frame];
            [cell.contentView setFrame:cell.bounds];
            
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    }else{
    
        [cell removeFromSuperview];
        
    }
    
    NSArray *tmpArray;
    OBJECTOFARRAYATINDEX(tmpArray, m_TableArray, section);

    NSDictionary *tmpDic;
    OBJECTOFARRAYATINDEX(tmpDic, tmpArray, row);

    if (!IsNilOrNull(tmpDic)) {

        BOOL isEnd = row + 1 == [tmpArray count] ? YES : NO;

        [self setTableViewCell:cell withDataDic:tmpDic withIsEnd:isEnd];

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSArray *tmpArray;
    OBJECTOFARRAYATINDEX(tmpArray, m_TableArray, section);
    
    NSDictionary *tmpDic;
    OBJECTOFARRAYATINDEX(tmpDic, tmpArray, row);

    if (!IsNilOrNull(tmpDic)) {
        
        PSFuncType funcType = [[tmpDic objectForKey:kDIC_FuncType] integerValue];

        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onCellEventProcessing:)]) {
            
            [m_Delegate onCellEventProcessing:funcType];
            
        }
        
    }
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    if (IsNilOrNull(m_TableArray)) {
        
        /***** UITableViewCell Section 1 *****/
        NSArray *tmpOneArray = @[[self createFuncDicWithIco:nil withTitle:@"屏蔽的人" withSubtitle:nil
                                                   withFunc:PSFuncType_Shiled withCellFuncType:CellFuncType_Extension],
                                 [self createFuncDicWithIco:nil withTitle:@"常用收件人" withSubtitle:nil
                                                   withFunc:PSFuncType_Addressee withCellFuncType:CellFuncType_Extension],
                                 [self createFuncDicWithIco:nil withTitle:@"支付密码设置" withSubtitle:nil
                                                   withFunc:PSFuncType_SetPayPswd withCellFuncType:CellFuncType_Extension],
                                [self createFuncDicWithIco:PUBLIC_IMG_PASSWORD_ICO withTitle:@"密码管理"
                                               withSubtitle:nil withFunc:PSFuncType_PwdManage
                                           withCellFuncType:CellFuncType_Extension]];
        // 获取当前设备中应用的版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *curVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        
        NSArray *tmpTwoArray = @[[self createFuncDicWithIco:nil withTitle:@"消息推送设置" withSubtitle:nil
                                                   withFunc:PSFuncType_SmsPush withCellFuncType:CellFuncType_Switch],
                                 [self createFuncDicWithIco:nil withTitle:@"清除本地缓存" withSubtitle:@"清除"
                                                   withFunc:PSFuncType_ClearCache withCellFuncType:CellFuncType_Text],
                                 [self createFuncDicWithIco:nil withTitle:@"关于发耶" withSubtitle:curVersion
                                                   withFunc:PSFuncType_About withCellFuncType:CellFuncType_Extension]];
        
        /***** UITableViewCell Section 2 End *****/

        m_TableArray = @[tmpOneArray,tmpTwoArray];
        
    }
    
}

- (NSDictionary *)createFuncDicWithIco:(NSString *)imgName withTitle:(NSString *)title
                          withSubtitle:(NSString *)subtitle withFunc:(PSFuncType)func
                      withCellFuncType:(CellFuncType)cellFuncType{
    
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    SETOBJECT(tmpDic, imgName, kDIC_Ico);
    SETOBJECT(tmpDic, title, kDIC_Title);
    SETOBJECT(tmpDic, subtitle, kDIC_Subtitle);
    SETOBJECT(tmpDic, [NSNumber numberWithInteger:func], kDIC_FuncType);
    SETOBJECT(tmpDic, [NSNumber numberWithInteger:cellFuncType], kDIC_CellFuncType);
    
    return tmpDic;
    
}

- (void)setTableViewCell:(UITableViewCell *)cell withDataDic:(NSDictionary *)dic
               withIsEnd:(BOOL)isEnd{
    
    UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:bgView];
    
    NSString *imgName;
    OBJECTOFNSDICTIONARYBYKEY(imgName, dic, kDIC_Ico);
    
    NSString *title;
    OBJECTOFNSDICTIONARYBYKEY(title, dic, kDIC_Title);
    
    NSString *subtitle;
    OBJECTOFNSDICTIONARYBYKEY(subtitle, dic, kDIC_Subtitle);
    
    PSFuncType funcType = [[dic objectForKey:kDIC_FuncType] integerValue];
    CellFuncType cellFuncType = [[dic objectForKey:kDIC_CellFuncType] integerValue];
    
    // ico
    UIImageView *imgView;
    
    if (!IsStrEmpty(imgName)) {
        
        imgView = [BasisUITool getImageViewWithImage:imgName withIsUserInteraction:NO];
        
        [bgView addSubview:imgView];
        CGFloat imgWidth = imgView.frame.size.width;
        CGFloat imgHeight = imgView.frame.size.height;
        
        imgView.frame = CGRectMake(15, 10, imgWidth, imgHeight);
        
    }

    // title
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:TABLEVIEW_COMMON_FONT_TITLE_SIZE];
    
    [titleLbl setText:title];
    
    [bgView addSubview:titleLbl];
    
    CGSize titleSize = [BasisUITool calculateSize:titleLbl.text font:titleLbl.font];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(titleSize.width, titleSize.height));
        
        if (IsNilOrNull(imgView)) {
            
            make.left.equalTo(15);
            make.top.equalTo(bgView.mas_centerY).offset(-titleSize.height / 2);
            
        }else{
            
            make.left.equalTo(42);
            make.top.equalTo(imgView.mas_centerY).offset(-titleSize.height / 2);
            
        }
        
    }];

    if (PSFuncType_About == funcType) {
        UILabel *subtitleLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                                 size:TABLEVIEW_COMMON_FONT_TITLE_SIZE];
        
        [subtitleLbl setText:subtitle];
        
        [bgView addSubview:subtitleLbl];
        
        CGSize subtitleSize = [BasisUITool calculateSize:subtitleLbl.text
                                                    font:subtitleLbl.font];
        [subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.equalTo(CGSizeMake(subtitleSize.width, subtitleSize.height));
            make.top.equalTo(bgView.mas_centerY).offset(-subtitleSize.height / 2);
            make.right.equalTo(bgView.mas_right).offset(-30);
            
        }];
    }
    
    // 右侧功能
    switch (cellFuncType) {
        case CellFuncType_Extension:{
            
            UIImageView *imgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_EXTENSION_ICO
                                                withIsUserInteraction:NO];
            
            [bgView addSubview:imgView];
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                CGFloat imgWidth = imgView.frame.size.width;
                CGFloat imgHeight = imgView.frame.size.height;
                
                make.size.equalTo(CGSizeMake(imgWidth, imgHeight));
                make.right.equalTo(bgView.mas_right).offset(-15);
                make.top.equalTo(bgView.mas_centerY).offset(-imgHeight / 2);
                
            }];
            
            break;}
        case CellFuncType_Switch:{
            
            UISwitch *switchView = [[UISwitch alloc] init];
            
            if (PSFuncType_SmsPush == funcType) {
                self.switchPush = switchView;
                switchView.on = [self isAllowedNotification];
            } else {
                [switchView setOn:NO];
            }
            [switchView setTag:funcType];
            [switchView addTarget:self action:@selector(switchActionBtnClick:)
                 forControlEvents:UIControlEventValueChanged];
            
            [bgView addSubview:switchView];
            
            [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                CGFloat width = 53;
                CGFloat height = 32;
                
                make.size.equalTo(CGSizeMake(width, height));
                make.right.equalTo(bgView.mas_right).offset(-15);
                make.top.equalTo(bgView.mas_centerY).offset(-height / 2);
                
            }];
            
            break;}
        case CellFuncType_Text:{
            
            UILabel *subtitleLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                                     size:TABLEVIEW_COMMON_FONT_TITLE_SIZE];
            
            [subtitleLbl setText:subtitle];
            
            [bgView addSubview:subtitleLbl];
            
            CGSize subtitleSize = [BasisUITool calculateSize:subtitleLbl.text
                                                        font:subtitleLbl.font];
            [subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.equalTo(CGSizeMake(subtitleSize.width, subtitleSize.height));
                make.top.equalTo(bgView.mas_centerY).offset(-subtitleSize.height / 2);
                make.right.equalTo(bgView.mas_right).offset(-15);

            }];
            
            break;}
        default:
            break;
    
    }
    
    // 分割线
    if (!isEnd) {
        
        UIView *lineView = [[UIView alloc] init];
        
        [bgView addSubview:lineView];
        
        [lineView setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(0.5);
            make.top.equalTo(bgView.bottom).offset(-0.5);
            
        }];
        
    }
    
}

- (BOOL)isAllowedNotification
{
    UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    return (types != UIUserNotificationTypeNone);
}

#pragma mark - Button Handlers
- (void)switchActionBtnClick:(id)sender{

    UISwitch *switchView = (UISwitch *)sender;
    
    if ([switchView tag] == PSFuncType_SmsPush) {// 消息推送逻辑处理
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        NSLog(@"消息推送 %@",switchView.on ? @"打开" : @"关闭");
    }
    
}

- (void)logOutBtnClick:(id)sender{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onLogOut)]) {
        
        [m_Delegate onLogOut];
        
    }
    
}

@end
