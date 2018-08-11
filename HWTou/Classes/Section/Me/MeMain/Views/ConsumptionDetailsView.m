//
//  ConsumptionDetailsView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumptionDetailsView.h"
#import "PublicHeader.h"
#import "ConsumpGoldDetailDM.h"
#import "ConsumptionDetailCell.h"

#define kDIC_Title          (@"Title")
#define kDIC_Array          (@"Array")

#define ConsumptionDetailSectionHeaderTitleTag   (98)

@interface ConsumptionDetailsView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ConsumptionDetailsView

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
                                                 separatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [tableView setRowHeight:60];
    [tableView setSectionHeaderHeight:CoordXSizeScale(40)];
    
    
    tableView.separatorColor = UIColorFromHex(0xf4f4f4);
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [tableView registerClass:[ConsumptionDetailCell class] forCellReuseIdentifier:ConsumptionDetailCellID];
    
    [self setTableView:tableView];
    [self addSubview:tableView];
    
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDataSource Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listData.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *headerView = [self createTableSectionHeaderView];
//    
//    NSDictionary *dic;
//    OBJECTOFARRAYATINDEX(dic, self.listData, section);
//    
//    NSString *titleStr;
//    OBJECTOFNSDICTIONARYBYKEY(titleStr, dic, kDIC_Title);
//    
//    UILabel *lbl = [headerView viewWithTag:ConsumptionDetailSectionHeaderTitleTag];
//    
//    [lbl setText:titleStr];
//    
//    return headerView;
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConsumptionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ConsumptionDetailCellID];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ConsumpGoldDetailDM *dmDetail;
    OBJECTOFARRAYATINDEX(dmDetail, self.listData, indexPath.row);
    [cell setDmDetail:dmDetail];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
}

- (void)setPersonalInfo:(PersonalInfoDM *)model
{
}

- (void)setListData:(NSArray *)listData
{
    _listData = listData;
    [self.tableView reloadData];
}


- (UIView *)createTableSectionHeaderView{
    
    UIView *headerView = [[UIView alloc] init];
    
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    // 标题
    UILabel *lbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                     size:CLIENT_COMMON_FONT_DETAILS_SIZE];
    
    [lbl setTag:ConsumptionDetailSectionHeaderTitleTag];
    [headerView addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(headerView.mas_centerY);
        make.leading.equalTo(headerView).offset(10);
        make.trailing.equalTo(headerView).offset(-10);
        
    }];
    
    return headerView;
    
}

@end
