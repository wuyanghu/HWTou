//
//  MediaColViewCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MediaColViewCell.h"

#import "PublicHeader.h"

@interface MediaColViewCell()

@property (nonatomic, strong) UIButton *m_MediaBtn;
@property (nonatomic, strong) UIButton *m_DeleteBtn;
@property (nonatomic, strong) UIImageView *m_MediaImgView;

@property (nonatomic, strong) MediaModel *m_Model;
@property (nonatomic, strong) NSIndexPath *m_IndexPath;

@end

@implementation MediaColViewCell
@synthesize m_Delegate;
@synthesize m_MediaBtn,m_DeleteBtn;
@synthesize m_MediaImgView;
@synthesize m_Model;
@synthesize m_IndexPath;

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self dataInitialization];
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

    UIButton *btn = [BasisUITool getBtnWithTarget:self action:@selector(mediaBtnClick:)];
    
    [btn.layer setCornerRadius:0];
    [btn.layer setMasksToBounds:NO];
    
    [self setM_MediaBtn:btn];
    
    UIImageView *imgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_DEFAULT
                                        withIsUserInteraction:NO];
    
    [imgView setContentMode:UIViewContentModeScaleToFill];
    
    [self setM_MediaImgView:imgView];
    [btn addSubview:imgView];

    UIButton *deleteBtn = [BasisUITool getBtnWithTarget:self action:@selector(deleteBtnClick:)];
    
    [deleteBtn setHidden:YES];
    [deleteBtn setImage:ImageNamed(CALABASH_DELETE_ICO) forState:UIControlStateNormal];
    [deleteBtn setImage:ImageNamed(CALABASH_DELETE_ICO) forState:UIControlStateDisabled];
    
    [self setM_DeleteBtn:deleteBtn];
    [btn addSubview:deleteBtn];
    
    [self addSubview:btn];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
   
    
}

- (void)layoutUI{
    
    [m_MediaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
        
    }];
    
    [m_MediaImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(m_MediaBtn);
        
    }];
    
    [m_DeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.right.equalTo(m_MediaBtn);
        make.size.equalTo(CGSizeMake(20, 20));
        
    }];
    
}

- (void)setMediaColViewCellUpDataSource:(MediaModel *)model
                  cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [self setM_Model:model];
    [self setM_IndexPath:indexPath];
    
    [m_DeleteBtn setHidden:YES];
    
    if (model.m_MediaType == MediaType_Button) {
        
        [m_MediaImgView setImage:ImageNamed(CALABASH_UPLOAD_PICTURES_BTN_NOR)];
        
    }else if (model.m_MediaType == MediaType_NetworkImg) {
    
        [BasisUITool imgLoadingProcessing:m_MediaImgView
                                   imgUrl:model.img_url
                         placeholderImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
        
    }else if (model.m_MediaType == MediaType_LocalImg) {
        
        [m_DeleteBtn setHidden:NO];
    
        [m_MediaImgView setImage:model.m_Image];
        
    }
    
}

#pragma mark - Button Handlers
- (void)mediaBtnClick:(id)sender{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onDidSelectItem:cellForRowAtIndexPath:)]) {
        
        [m_Delegate onDidSelectItem:m_Model cellForRowAtIndexPath:m_IndexPath];
        
    }
    
}

- (void)deleteBtnClick:(id)sender{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onDeleteItem:cellForRowAtIndexPath:)]) {
        
        [m_Delegate onDeleteItem:m_Model cellForRowAtIndexPath:m_IndexPath];
        
    }
    
}

@end
