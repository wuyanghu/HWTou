//
//  CourseColViewCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CourseColViewCell.h"

#import "PublicHeader.h"

@interface CourseColViewCell()

@property (nonatomic, strong) UILabel *m_TitleLbl;
@property (nonatomic, strong) UILabel *m_RemarkLbl;
@property (nonatomic, strong) UILabel *m_CreateTimeLbl;

@property (nonatomic, strong) UIView *m_LineView;

@property (nonatomic, strong) UIImageView *m_RightImgView;
@property (nonatomic, strong) UIImageView *m_TimeImgView;

@property (nonatomic, strong) CourseModel *m_Model;
@property (nonatomic, strong) NSIndexPath *m_IndexPath;

@end

@implementation CourseColViewCell
@synthesize m_Model;
@synthesize m_Delegate;

@synthesize m_TitleLbl,m_RemarkLbl,m_CreateTimeLbl;
@synthesize m_LineView;
@synthesize m_RightImgView,m_TimeImgView;

@synthesize m_IndexPath;

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addMainView];
        [self layoutUI];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    return self;
    
}

- (void)addMainView{
    
    [self addViews];
    
}

- (void)addViews{
    
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [self setM_TitleLbl:titleLbl];
    
    UILabel *remarkLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                           size:CLIENT_COMMON_FONT_DETAILS_SIZE];

    [remarkLbl setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self setM_RemarkLbl:remarkLbl];
    
    UILabel *createTimeLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                               size:CLIENT_COMMON_FONT_DETAILS_SIZE];
    
    [self setM_CreateTimeLbl:createTimeLbl];
    
    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [self setM_LineView:lineView];
    
    UIImageView *rightImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_DEFAULT
                                             withIsUserInteraction:NO];
    
    [rightImgView setContentMode:UIViewContentModeScaleToFill];
    
    [self setM_RightImgView:rightImgView];
    
    UIImageView *timeImgView = [BasisUITool getImageViewWithImage:CALABASH_TIME_ICO
                                               withIsUserInteraction:NO];
    
    [self setM_TimeImgView:timeImgView];
    
    [self addSubview:titleLbl];
    [self addSubview:remarkLbl];
    [self addSubview:createTimeLbl];
    [self addSubview:lineView];
    [self addSubview:rightImgView];
    [self addSubview:timeImgView];
    
}

#pragma mark - Public Functions
- (void)layoutUI{

    [m_RightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(-15);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(78, 78));
        
    }];
    
    [m_TitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.equalTo(self).offset(15);
        make.right.equalTo(m_RightImgView.mas_left).offset(-15);
        make.height.equalTo(17);
        
    }];
    
    [m_RemarkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(m_TitleLbl.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(m_RightImgView.mas_left).offset(-15);
        make.height.equalTo(17);
        
    }];
    
    [m_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_RemarkLbl.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.size.equalTo(CGSizeMake(CoordXSizeScale(115), 0.5));
        
    }];
    
    [m_TimeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGSize size = m_TimeImgView.frame.size;
        
        make.top.equalTo(m_LineView.mas_bottom).offset(6);
        make.left.equalTo(self).offset(15);
        make.size.equalTo(CGSizeMake(size.width, size.height));
        
    }];
    
    [m_CreateTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(m_TimeImgView.mas_centerY);
        make.left.equalTo(m_TimeImgView.mas_right).offset(5);
        make.right.equalTo(m_RightImgView.mas_left).offset(-15);
        make.height.equalTo(17);
        
    }];
    
}

- (void)setCourseColCellUpDataSource:(CourseModel *)model
               cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [self setM_Model:model];
    [self setM_IndexPath:indexPath];
    
    if (IsNilOrNull(model)) {
        
        [m_TitleLbl setText:nil];
        [m_RemarkLbl setText:nil];
        [m_CreateTimeLbl setText:nil];
        [m_RightImgView setImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
        
    }else{
        
        [m_TitleLbl setText:model.title];
        [m_RemarkLbl setText:model.remark];
        [m_CreateTimeLbl setText:[DateFormatTool dateConversion:model.create_time]];
        [BasisUITool imgLoadingProcessing:m_RightImgView imgUrl:model.img_url
                         placeholderImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
        
    }
    
}

@end
