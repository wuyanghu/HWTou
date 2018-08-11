//
//  CoursesEnrolmentSuccessView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CoursesEnrolmentSuccessView.h"

#import "PublicHeader.h"
#import "DateFormatTool.h"

@interface CoursesEnrolmentSuccessView()

@property (nonatomic, strong) UIImageView *m_AdsImgView;
@property (nonatomic, strong) UIView *m_CourseInfoView;
@property (nonatomic, strong) UILabel *m_TitleLbl;
@property (nonatomic, strong) UILabel *m_RemarkLbl;
@property (nonatomic, strong) UILabel *m_TimeLbl;
@property (nonatomic, strong) UILabel *m_AddressLbl;
@property (nonatomic, strong) UIView *m_LineView;
@property (nonatomic, strong) UIImageView *m_TimeIcoImgView;
@property (nonatomic, strong) UIImageView *m_AddressIcoImgView;

@end

@implementation CoursesEnrolmentSuccessView
@synthesize m_AdsImgView;
@synthesize m_CourseInfoView;
@synthesize m_TitleLbl,m_RemarkLbl,m_TimeLbl,m_AddressLbl;
@synthesize m_LineView;
@synthesize m_TimeIcoImgView,m_AddressIcoImgView;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addMainView];
        [self layoutUI];
        
        [self setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addAdsImgView];
    [self addCourseInfoView];
    
}

- (void)addAdsImgView{

    UIImageView *adsImgView = [BasisUITool getImageViewWithImage:nil withIsUserInteraction:NO];
    
    [adsImgView setContentMode:UIViewContentModeScaleToFill];
    
    [self setM_AdsImgView:adsImgView];
    [self addSubview:adsImgView];
    
}

- (void)addCourseInfoView{

    UIView *bgView = [[UIView alloc] init];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:CLIENT_COMMON_FONT_TITLE_SIZE];
    
    [self setM_TitleLbl:titleLbl];
    [bgView addSubview:titleLbl];
    
    UILabel *remarkLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                           size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [remarkLbl setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self setM_RemarkLbl:remarkLbl];
    [bgView addSubview:remarkLbl];
    
    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [self setM_LineView:lineView];
    [bgView addSubview:lineView];
    
    UIImageView *timeIcoImgView = [BasisUITool getImageViewWithImage:CALABASH_TIME_ICO
                                               withIsUserInteraction:NO];
    
    [self setM_TimeIcoImgView:timeIcoImgView];
    [bgView addSubview:timeIcoImgView];
    
    UIImageView *addressIcoImgView = [BasisUITool getImageViewWithImage:CALABASH_ADDRESS_ICO
                                                  withIsUserInteraction:NO];

    [self setM_AddressIcoImgView:addressIcoImgView];
    [bgView addSubview:addressIcoImgView];
    
    UILabel *timeLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                         size:CLIENT_COMMON_FONT_CONTENT_SIZE];;
    
    [self setM_TimeLbl:timeLbl];
    [bgView addSubview:timeLbl];
    
    UILabel *addressLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                            size:CLIENT_COMMON_FONT_CONTENT_SIZE];;
    
    [self setM_AddressLbl:addressLbl];
    [bgView addSubview:addressLbl];
    
    [self setM_CourseInfoView:bgView];
    [self addSubview:bgView];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)layoutUI{
    
    [m_AdsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(m_AdsImgView.width).multipliedBy(0.5);
        
    }];
    
    [m_CourseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_AdsImgView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(135);
        
    }];
    
    [m_TitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.and.left.equalTo(15);
        make.right.equalTo(m_CourseInfoView).offset(-15);
        
    }];
    
    [m_RemarkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_TitleLbl.mas_bottom).offset(10);
        make.left.and.right.equalTo(m_TitleLbl);
        
    }];
    
    [m_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_RemarkLbl.mas_bottom).offset(15);
        make.left.and.right.equalTo(m_TitleLbl);
        make.height.equalTo(0.5);
        
    }];
    
    [m_TimeIcoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        CGSize size = m_TimeIcoImgView.frame.size;
        
        make.top.equalTo(m_LineView.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(size.width, size.height));
        
    }];
    
    [m_TimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(m_TimeIcoImgView.mas_centerY);
        make.left.equalTo(m_TimeIcoImgView.right).offset(5);
        make.right.equalTo(m_CourseInfoView).offset(-15);;
        
    }];
    
    [m_AddressIcoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGSize size = m_TimeIcoImgView.frame.size;
        
        make.top.equalTo(m_TimeIcoImgView.mas_bottom).offset(10);
        make.left.equalTo(m_LineView);
        make.size.equalTo(CGSizeMake(size.width, size.height));
        
    }];
    
    [m_AddressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(m_AddressIcoImgView.mas_centerY);
        make.left.equalTo(m_AddressIcoImgView.right).offset(5);
        make.right.equalTo(m_CourseInfoView).offset(-15);;
        
    }];
    
}

- (void)setSuccessViewDataSource:(CourseModel *)courseModel
                 withAddressInfo:(CoursesAddressModel *)coursesAddressModel{

    [BasisUITool imgLoadingProcessing:m_AdsImgView imgUrl:courseModel.img_url
                     placeholderImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
    
    [m_TitleLbl setText:courseModel.title];
    [m_RemarkLbl setText:courseModel.remark];
    
    [m_TimeLbl setText:[DateFormatTool dateConversion:coursesAddressModel.create_time]];
    [m_AddressLbl setText:coursesAddressModel.full_name];
    
}

- (void)setSuccessViewDataSource:(CourseModel *)courseModel
                  withEnlistInfo:(EnlistModel *)enlistModel{
    
    [BasisUITool imgLoadingProcessing:m_AdsImgView imgUrl:courseModel.img_url
                     placeholderImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
    
    [m_TitleLbl setText:courseModel.title];
    [m_RemarkLbl setText:courseModel.remark];
    
    [m_TimeLbl setText:[DateFormatTool dateConversion:enlistModel.create_time]];
    [m_AddressLbl setText:enlistModel.full_name];
    
}

#pragma mark - Button Handlers

@end
