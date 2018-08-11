//
//  CustomerAndFeedbackView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CustomerAndFeedbackView.h"

#import "PublicHeader.h"

@interface CustomerAndFeedbackView()

@property (nonatomic, strong) UIView *m_HotlineView;

@end

@implementation CustomerAndFeedbackView
@synthesize m_Delegate;
@synthesize m_HotlineView;

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
    
    [self addHotlineView];
    [self addQQView];
    
}

- (void)addHotlineView{
    
    UIView *bgView = [[UIView alloc] init];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *hotlineLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                            size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [hotlineLbl setText:@"客服热线: "];
    
    UILabel *telLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_RED_COLOR)
                                                        size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [telLbl setText:@"0571-87689328"];
    
    UILabel *srvTime = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                         size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [srvTime setText:@"服务时间: "];
    
    UILabel *timeLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                         size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [timeLbl setText:@"工作日 9:00 - 17:30"];
    
    UIButton *callBtn = [BasisUITool getBtnWithTarget:self action:@selector(callBtnClick:)];
    
    [callBtn setImage:ImageNamed(ME_IMG_CALL_NOR) forState:UIControlStateNormal];
    [callBtn setImage:ImageNamed(ME_IMG_CALL_NOR) forState:UIControlStateDisabled];
    
    [bgView addSubview:hotlineLbl];
    [bgView addSubview:telLbl];
    [bgView addSubview:srvTime];
    [bgView addSubview:timeLbl];
    [bgView addSubview:callBtn];
    
    [self setM_HotlineView:bgView];
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self);
        make.left.and.right.equalTo(self);
        make.size.equalTo(CGSizeMake(kMainScreenWidth, 82));
        
    }];
    
    [hotlineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView).offset(15);
        make.left.equalTo(bgView).offset(10);
        make.width.greaterThanOrEqualTo(@70);
        
    }];
    
    [telLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(hotlineLbl);
        make.left.equalTo(hotlineLbl.mas_right).offset(5);
        make.right.equalTo(bgView).offset(-10);
        
    }];
    
    [srvTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(hotlineLbl.mas_bottom).offset(12);
        make.left.equalTo(bgView).offset(10);
        make.width.greaterThanOrEqualTo(@70);
        
    }];
    
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(srvTime);
        make.left.equalTo(srvTime.mas_right).offset(5);
        make.right.equalTo(bgView).offset(-10);
        
    }];
    
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(bgView.mas_centerY);
        make.right.equalTo(bgView).offset(-22);
        make.size.equalTo(CGSizeMake(26.5, 26.5));
        
    }];
    
}

- (void)addQQView{

    UIView *bgView = [[UIView alloc] init];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *srvqqLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [srvqqLbl setText:@"客服QQ: "];
    
    UILabel *qqLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_RED_COLOR)
                                                       size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [qqLbl setText:@"2464649441"];
    
    [bgView addSubview:srvqqLbl];
    [bgView addSubview:qqLbl];
    
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_HotlineView.mas_bottom).offset(10);
        make.left.and.right.equalTo(self);
        make.size.equalTo(CGSizeMake(kMainScreenWidth, 54));
        
    }];
    
    [srvqqLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(bgView).offset(10);
        make.width.greaterThanOrEqualTo(@70);
        
    }];
    
    [qqLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(srvqqLbl);
        make.left.equalTo(srvqqLbl.mas_right).offset(5);
        make.right.equalTo(bgView).offset(-10);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)layoutUI{

    
    
}

#pragma mark - Button Handlers
- (void)callBtnClick:(id)sender
{
    [self callPhone:@"0571-87689328"];
}

- (void)callPhone:(NSString *)phoneNum
{
    if (phoneNum.length == 0) {
        return;
    }
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNum];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    });
}

@end
