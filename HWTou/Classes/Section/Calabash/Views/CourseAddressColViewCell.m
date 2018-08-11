//
//  CourseAddressColViewCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CourseAddressColViewCell.h"

#import "PublicHeader.h"

@interface CourseAddressColViewCell ()

@property (nonatomic, strong) UILabel *m_TitleLbl;
@property (nonatomic, strong) UIView *m_LineView;

@property (nonatomic, strong) CoursesAddressModel *m_Model;
@property (nonatomic, strong) NSIndexPath *m_IndexPath;

@end

@implementation CourseAddressColViewCell
@synthesize m_SelectView;
@synthesize m_TitleLbl;
@synthesize m_LineView;

@synthesize m_Model;
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
    
    UIView *selectView = [[UIView alloc] init];
    
    [selectView setHidden:YES];
    [selectView setBackgroundColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)];
    
    [self setM_SelectView:selectView];
    
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [titleLbl setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self setM_TitleLbl:titleLbl];
    
    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [self setM_LineView:lineView];
    
    [self addSubview:selectView];
    [self addSubview:titleLbl];
    [self addSubview:lineView];
    
}

#pragma mark - Public Functions
- (void)layoutUI{
    
    [m_SelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.and.bottom.equalTo(self);
        make.width.equalTo(6);
        make.height.equalTo(self);
        
    }];
    
    [m_TitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(m_SelectView.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    [m_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(0.5);
        
    }];
    
}

- (void)setCourseAddressColViewCellUpDataSource:(CoursesAddressModel *)model
                          cellForRowAtIndexPath:(NSIndexPath *)indexPath
                                      withIsEnd:(BOOL)isEnd{

    [self setM_Model:model];
    [self setM_IndexPath:indexPath];
    
    [m_LineView setHidden:isEnd];
    [m_TitleLbl setText:model.full_name];
    
}

#pragma mark - Button Handlers

@end
