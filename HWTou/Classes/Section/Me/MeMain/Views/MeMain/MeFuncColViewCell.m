//
//  MeFuncColViewCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MeFuncColViewCell.h"

#import "PublicHeader.h"

@interface MeFuncColViewCell()

@property (nonatomic, strong) UILabel *m_TitleLbl;
@property (nonatomic, strong) UIImageView *m_ImgView;

@property (nonatomic, strong) MeFuncModel *m_Model;
@property (nonatomic, assign) NSIndexPath *m_IndexPath;

@end

@implementation MeFuncColViewCell
@synthesize m_TitleLbl;
@synthesize m_ImgView;

@synthesize m_Model;
@synthesize m_IndexPath;

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addMainView];
    }
    return self;
}

#pragma mark - Add UI

- (void)addMainView{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titlelbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(0x2B2B2B)
                                                          size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    [m_TitleLbl setTextAlignment:NSTextAlignmentCenter];
    [self setM_TitleLbl:titlelbl];
 
    UIImageView *imgView = [BasisUITool getImageViewWithImage:nil withIsUserInteraction:NO];
    [self setM_ImgView:imgView];
    
    [self addSubview:imgView];
    [self addSubview:titlelbl];
    
    UIImageView * rightView = [BasisUITool getImageViewWithImage:@"btn_next" withIsUserInteraction:NO];
    [self addSubview:rightView];
    
    [m_ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.size.equalTo(CGSizeMake(22, 20));
        make.top.equalTo(self).offset(12);
    }];
    
    [m_TitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20);
        make.left.equalTo(m_ImgView.mas_right).offset(10);
        make.top.equalTo(m_ImgView);
        make.width.equalTo(200);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(9, 17));
        make.right.equalTo(self).offset(-10);
    }];
}

#pragma mark - Public Functions

- (void)setPackageCellUpDataSource:(MeFuncModel *)model
             cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [m_TitleLbl setText:nil];
    [m_ImgView setImage:nil];
    
    if (!IsNilOrNull(model)) {
        
        [self setM_Model:model];
        [self setM_IndexPath:indexPath];
        
        [m_TitleLbl setText:model.m_Title];
        [m_ImgView setImage:ImageNamed(model.m_IcoName)];
        
    }
  
}

@end
