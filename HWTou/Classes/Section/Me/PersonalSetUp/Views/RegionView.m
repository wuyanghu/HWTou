//
//  RegionView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RegionView.h"

#import "PublicHeader.h"

@interface RegionView()<UITableViewDelegate,UITableViewDataSource>{

    RegionType g_RegionType;

}

@property (nonatomic, strong) UIView *m_TableHeaderView;
@property (nonatomic, strong) UILabel *m_TitleLbl;
@property (nonatomic, strong) UITableView *m_TableView;
@property (nonatomic, strong) NSMutableArray *m_TableArray;         // list<RegionResult>
@property (nonatomic, strong) NSMutableDictionary *m_RegionDic;     // 缓存选择的地区数据

@end

@implementation RegionView
@synthesize m_Delegate;
@synthesize m_TableHeaderView;
@synthesize m_TitleLbl;
@synthesize m_TableView;
@synthesize m_TableArray;
@synthesize m_RegionDic;

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
    
    [self addTableHeaderView];
    [self addTableView];
    
}

- (void)addTableHeaderView{

    CGFloat width = kMainScreenWidth;
    CGFloat height = 44;
    
    UIView *bgView = [self createTableViewHeaderView:CGRectMake(0, 0, width, height)];
    
    [self setM_TableHeaderView:bgView];
    
}

- (void)addTableView{
    
    UITableView *tableView = [BasisUITool getTableViewWithFrame:CGRectZero
                                                          style:UITableViewStylePlain
                                                       delegate:self
                                                     dataSource:self
                                                  scrollEnabled:YES
                                                 separatorStyle:UITableViewCellSeparatorStyleNone];
    
    [tableView setRowHeight:44];
    [tableView setSectionHeaderHeight:44];
    
    [self setM_TableView:tableView];
    [self addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        
    }];
    
}

#pragma mark - UITableViewDataSource Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [m_TableArray count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return m_TableHeaderView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger row = [indexPath row];
    static NSString *regionCellID = @"regionCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:regionCellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:regionCellID];
        
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
    
    RegionResult *model;
    OBJECTOFARRAYATINDEX(model, m_TableArray, row);
    
    if (!IsNilOrNull(model)) {
        
        BOOL isEnd = row + 1 == [m_TableArray count] ? YES : NO;
        
        [self setTableViewCell:cell withDataSource:model withIsEnd:isEnd];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RegionResult *model;
    OBJECTOFARRAYATINDEX(model, m_TableArray, [indexPath row]);
    
    if (!IsNilOrNull(model)) {
        
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:m_RegionDic];
        
        RegionType regionType;
        
        switch (g_RegionType) {
            case RegionType_Province:{
                
                regionType = RegionType_City;
                
                SETOBJECT(tmpDic, model, kDIC_Region_Province);
                
                break;}
            case RegionType_City:{
                
                regionType = RegionType_Area;
                
                SETOBJECT(tmpDic, model, kDIC_Region_City);
                
                break;}
            case RegionType_Area:{
                
                regionType = RegionType_End;
                
                SETOBJECT(tmpDic, model, kDIC_Region_Area);
                
                break;}
            default:
                break;
        }
        
        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onAreaSelection:withType:)]) {
            
            [m_Delegate onAreaSelection:tmpDic withType:regionType];
            
        }
        
    }
    
}

#pragma mark - 获取数据源
- (void)accessDataSourceWithType:(RegionType)regionType withDataSource:(NSDictionary *)dic{
    
    g_RegionType = regionType;
    
    [m_RegionDic setDictionary:dic];
    
    NSString *aTitle = @"请选择";
    
    NSInteger type = 1;
    NSInteger region_id = -1;
    
    switch (regionType) {
        case RegionType_Province:{
            
            
            
            break;}
        case RegionType_City:{

            RegionResult *provinceModel;
            OBJECTOFNSDICTIONARYBYKEY(provinceModel, dic, kDIC_Region_Province);
            
            type = 2;
            region_id = provinceModel.id;
            
            aTitle = [NSString stringWithFormat:@"%@ 请选择",provinceModel.name];
            
            break;}
        case RegionType_Area:{
            
            RegionResult *provinceModel;
            OBJECTOFNSDICTIONARYBYKEY(provinceModel, dic, kDIC_Region_Province);
            
            RegionResult *cityModel;
            OBJECTOFNSDICTIONARYBYKEY(cityModel, dic, kDIC_Region_City);
            
            type = 3;
            region_id = cityModel.id;
            
            aTitle = [NSString stringWithFormat:@"%@ %@ 请选择",provinceModel.name,cityModel.name];
            
            break;}
        default:
            break;
    }

    RegionParam *param = [[RegionParam alloc] init];
    
    [param setType:type];
    if (region_id != -1) [param setRegion_id:region_id];
    
    [m_TitleLbl setText:aTitle];
    [self obtainRegionListWithParam:param];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    if (IsNilOrNull(m_TableArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [self setM_TableArray:tmpArray];
        
    }
    
    if (IsNilOrNull(m_RegionDic)) {
        
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [self setM_RegionDic:tmpDic];
        
    }
    
}

- (void)setTableViewCell:(UITableViewCell *)cell withDataSource:(RegionResult *)model
               withIsEnd:(BOOL)isEnd{

    UIView *bgView = [[UIView alloc] initWithFrame:
                      CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];

    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    // title
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:TABLEVIEW_COMMON_FONT_TITLE_SIZE];
    
    [titleLbl setText:model.name];
    
    [bgView addSubview:titleLbl];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(20);
        make.top.equalTo(bgView.mas_centerY).offset(-10);
        
    }];
    
    // 分割线
    if (!isEnd) {
        
        UIView *lineView = [[UIView alloc] init];
        
        [bgView addSubview:lineView];
        
        [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.size.equalTo(CGSizeMake(bgView.frame.size.width, 0.5));
            make.bottom.equalTo(bgView.mas_bottom).offset(-0.5);
            
        }];
        
    }
    
    [cell addSubview:bgView];
    
}

- (UIView *)createTableViewHeaderView:(CGRect)frame{
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    [bgView setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
    
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                          size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [self setM_TitleLbl:titleLbl];
    [bgView addSubview:titleLbl];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(20);
        make.top.equalTo(bgView.mas_centerY).offset(-10);
        
    }];
    
    return bgView;
    
}

#pragma mark - Button Handlers

#pragma mark - NetworkRequest Manager
- (void)obtainRegionListWithParam:(RegionParam *)param{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [RegionRequest obtainRegionListWithParam:param success:^(RegionResponse *response) {
        
        if (response.success) {
            
            if (!IsArrEmpty(m_TableArray)) [m_TableArray removeAllObjects];
            
            if (!IsArrEmpty(response.data)) {
             
                [m_TableArray addObjectsFromArray:response.data];
                
            }

            [m_TableView reloadData];
            
            [HUDProgressTool dismiss];
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
