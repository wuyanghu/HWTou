//
//  TeachersColViewCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TeachersColViewCell.h"

#import "PublicHeader.h"

@interface TeachersColViewCell()

@property (nonatomic, strong) UILabel *m_TitleLbl;
@property (nonatomic, strong) UILabel *m_RemarkLbl;

@property (nonatomic, strong) UIImageView *m_RightImgView;

@property (nonatomic, strong) TeacherModel *m_Model;
@property (nonatomic, strong) NSIndexPath *m_IndexPath;

@end

@implementation TeachersColViewCell
@synthesize m_Model;
@synthesize m_Delegate;

@synthesize m_TitleLbl,m_RemarkLbl;
@synthesize m_RightImgView;

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

    [remarkLbl setNumberOfLines:0];
    [remarkLbl setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self setM_RemarkLbl:remarkLbl];
    
    UIImageView *rightImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_DEFAULT
                                             withIsUserInteraction:NO];
    
    [rightImgView setContentMode:UIViewContentModeScaleToFill];
    
    [self setM_RightImgView:rightImgView];

    [self addSubview:titleLbl];
    [self addSubview:remarkLbl];
    [self addSubview:rightImgView];
    
}

#pragma mark - Public Functions
- (void)layoutUI{

    [m_RightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.size.equalTo(CGSizeMake(78, 78));
        
    }];
    
    CGSize titleSize = [BasisUITool calculateSize:m_TitleLbl.text font:m_TitleLbl.font];
    [m_TitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.equalTo(15);
        make.right.equalTo(m_RightImgView.mas_left).offset(-15);
        make.height.equalTo(titleSize.height);
        
    }];
    
    [m_RemarkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_TitleLbl.mas_bottom).offset(10);
        make.left.and.right.equalTo(m_TitleLbl);
        make.height.lessThanOrEqualTo(titleSize.height * 3);
        
    }];
    
}

- (void)setTeachersColCellUpDataSource:(TeacherModel *)model
                 cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [self setM_Model:model];
    [self setM_IndexPath:indexPath];
    
    if (IsNilOrNull(model)) {
        
        [m_TitleLbl setText:nil];
        [m_RemarkLbl setText:nil];
        [m_RightImgView setImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
        
    }else{
        
        [m_TitleLbl setText:model.name];
        [m_RemarkLbl setText:model.remark];
        [BasisUITool imgLoadingProcessing:m_RightImgView imgUrl:model.img_url
                         placeholderImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
        
    }
    
}

@end
