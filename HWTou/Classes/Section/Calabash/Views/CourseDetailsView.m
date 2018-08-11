//
//  CourseDetailsView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CourseDetailsView.h"

#import "PublicHeader.h"

@interface CourseDetailsView()

@property (nonatomic, strong) UIImageView *m_AdsImgView;
@property (nonatomic, strong) UIView *m_RemarkView;
@property (nonatomic, strong) UITextView *m_RemarkTV;
@property (nonatomic, strong) UIButton *m_EnrolmentBtn;

@property (nonatomic, strong) CourseModel *m_CourseModel;

@end

@implementation CourseDetailsView
@synthesize m_Delegate;
@synthesize m_AdsImgView;
@synthesize m_RemarkView;
@synthesize m_RemarkTV;
@synthesize m_EnrolmentBtn;

@synthesize m_CourseModel;

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
    
    [self addViews];
    
}

- (void)addViews{

    UIImageView *adsImgView = [BasisUITool getImageViewWithImage:nil withIsUserInteraction:NO];
    
    [adsImgView setContentMode:UIViewContentModeScaleToFill];
    [self setM_AdsImgView:adsImgView];
    
    UIView *remarkView = [[UIView alloc] init];
    
    [self setM_RemarkView:remarkView];
    
    UITextView *remarkTV = [[UITextView alloc] init];
    
    [remarkTV setEditable:NO];
    [remarkTV setScrollEnabled:NO];
    [remarkTV setBackgroundColor:[UIColor clearColor]];
    [remarkTV setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [remarkTV setFont:FontPFRegular(CLIENT_COMMON_FONT_CONTENT_SIZE)];
    
    [self setM_RemarkTV:remarkTV];
    
    UIButton *enrolmentBtn = [BasisUITool getBtnWithTarget:self action:@selector(enrolmentBtnClick:)];
    
    [enrolmentBtn.layer setCornerRadius:0];
    [enrolmentBtn.layer setMasksToBounds:NO];
    
    [enrolmentBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [enrolmentBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                              forState:UIControlStateNormal];
    [enrolmentBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                              forState:UIControlStateDisabled];
    
    [self setM_EnrolmentBtn:enrolmentBtn];
    
    [self addSubview:adsImgView];
    [self addSubview:remarkView];
    [remarkView addSubview:remarkTV];
    [self addSubview:enrolmentBtn];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)layoutUI{
    
    [m_AdsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(m_AdsImgView.width).multipliedBy(0.5);
        
    }];
    
    [m_RemarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_AdsImgView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(m_EnrolmentBtn.mas_top);
        
    }];
    
    [m_RemarkTV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(m_RemarkView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        
    }];

    [m_EnrolmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_RemarkView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(40);
        make.bottom.equalTo(self);
        
    }];
    
}

- (void)setCourseDetailsViewDataSource:(CourseModel *)model{
    
    [self setM_CourseModel:model];
    
    [BasisUITool imgLoadingProcessing:m_AdsImgView imgUrl:model.img_url
                     placeholderImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
    
    [m_RemarkTV setText:nil];
    [m_RemarkTV setAttributedText:nil];
    
    if (!IsStrEmpty(model.remark)) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:5]; // 字体的行间距
        
        NSDictionary *attributes = @{NSFontAttributeName:m_RemarkTV.font,
                                     NSForegroundColorAttributeName:[UIColor grayColor],
                                     NSParagraphStyleAttributeName:paragraphStyle};
        
        [m_RemarkTV setAttributedText:[[NSAttributedString alloc] initWithString:model.remark
                                                                      attributes:attributes]];
        
    }
    
    if (model.enlist_type == 2) {
        
//        [m_EnrolmentBtn setEnabled:NO];
        [m_EnrolmentBtn setTitle:@"已报名" forState:UIControlStateNormal];
        
    }
    
}

#pragma mark - Button Handlers
- (void)enrolmentBtnClick:(id)sender{
    
    if (m_CourseModel.enlist_type == 2) {// 已报名处理
        
        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onCoursesEnrolmentInfo:)]) {
            
            [m_Delegate onCoursesEnrolmentInfo:m_CourseModel];
            
        }
        
    }else{// 未报名处理
        
        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onCoursesEnrolment:)]) {
            
            [m_Delegate onCoursesEnrolment:m_CourseModel];
            
        }
        
    }
    
}

@end
