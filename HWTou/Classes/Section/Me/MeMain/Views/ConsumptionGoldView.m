//
//  ConsumptionGoldView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumptionGoldView.h"

#import "PublicHeader.h"

#define ConsumptionGoldCellID (@"ConsumptionGoldCellID")

@interface ConsumptionGoldView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *m_HeadView;
@property (nonatomic, strong) UILabel *m_AmtLbl;

@end

@implementation ConsumptionGoldView
@synthesize m_Delegate;
@synthesize m_HeadView;
@synthesize m_AmtLbl;

@synthesize m_TableView;

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
    
    [self addHeadView];
    [self addTableView];
    
}

- (void)addHeadView{
    
    UIView *bgView = [[UIView alloc] init];
    
    // 背景图片
    UIImageView *imgBgView = [BasisUITool getImageViewWithImage:CONSUMPTION_GOLD_BG
                                          withIsUserInteraction:NO];
    
    [imgBgView setContentMode:UIViewContentModeScaleToFill];
    
    [bgView addSubview:imgBgView];
    
    // 提前花 title
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor whiteColor]
                                                          size:CLIENT_COMMON_FONT_DETAILS_SIZE];
    
    [titleLbl setText:@"提前花(元)"];
    
    [imgBgView addSubview:titleLbl];
    
    // 金额 amount
    UILabel *amountLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor whiteColor]
                                                           size:32.5];
    
    [amountLbl setText:@"0.00"];
    
    [self setM_AmtLbl:amountLbl];
    [imgBgView addSubview:amountLbl];
    
    [self setM_HeadView:bgView];
    [self addSubview:bgView];
    
    /* ********** layout UI ********** */
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@150);
        
    }];
    
    [imgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView);
    }];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(amountLbl.top).offset(5);
        make.leading.equalTo(imgBgView).offset(20);
        make.trailing.equalTo(imgBgView).offset(-15);
    }];
    
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.centerY).multipliedBy(1.1);
        make.leading.trailing.equalTo(titleLbl);
    }];
    
    /* ********** layout UI End ********** */
    
}

- (void)addTableView{
    
    UITableView *tableView = [BasisUITool getTableViewWithFrame:CGRectZero
                                                          style:UITableViewStylePlain
                                                       delegate:self
                                                     dataSource:self
                                                  scrollEnabled:NO
                                                 separatorStyle:UITableViewCellSeparatorStyleNone];
    
    [tableView setRowHeight:45];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ConsumptionGoldCellID];
    
    [self setM_TableView:tableView];
    [self addSubview:tableView];
    
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_HeadView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.offset(45);
    }];

}

#pragma mark - UITableViewDataSource Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ConsumptionGoldCellID];
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [cell.textLabel setText:@"提现"];
    [cell.textLabel setTextColor:UIColorFromHex(0x333333)];
    [cell.textLabel setFont:FontPFRegular(14.0f)];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onTableViewDidSelectRowAtIndexPath:)]) {
        
        [m_Delegate onTableViewDidSelectRowAtIndexPath:indexPath];
        
    }
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)setPersonalInfo:(PersonalInfoDM *)model{

    [m_AmtLbl setText:[NSString stringWithFormat:@"%.2f",model.gold]];
    
}

@end
