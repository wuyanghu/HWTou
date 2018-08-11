//
//  AddressColViewCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AddressColViewCell.h"

#import "PublicHeader.h"

#define kImageTag           998

@interface AddressColViewCell()

@property (nonatomic, strong) UILabel *m_NameLbl;
@property (nonatomic, strong) UILabel *m_TelLbl;
@property (nonatomic, strong) UILabel *m_AddressLbl;

@property (nonatomic, strong) UIView *m_LineView;
@property (nonatomic, strong) UIImageView *m_SelImgView;

@property (nonatomic, strong) UIView *m_FuncView;
@property (nonatomic, strong) UIButton *m_DefAddrBtn;
@property (nonatomic, strong) UIButton* m_EditorBtn;
@property (nonatomic, strong) UIButton* m_DeleteBtn;

@property (nonatomic, strong) NSIndexPath *m_IndexPath;

@end

@implementation AddressColViewCell
@synthesize m_Delegate;
@synthesize m_Model;
@synthesize m_NameLbl,m_TelLbl,m_AddressLbl;
@synthesize m_LineView;
@synthesize m_SelImgView;
@synthesize m_FuncView;
@synthesize m_DefAddrBtn,m_EditorBtn,m_DeleteBtn;
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

#pragma mark - Add UI
- (void)addMainView{
    
    [self addViews];
    
}

- (void)addViews{

    UILabel *nameLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                         size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    [self setM_NameLbl:nameLbl];
    
    UILabel *telLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                        size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    [self setM_TelLbl:telLbl];
    
    UILabel *addressLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                            size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [self setM_AddressLbl:addressLbl];
    
    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [self setM_LineView:lineView];
    
    UIView *funcView = [[UIView alloc] init];
    
    [self setM_FuncView:funcView];
    
    UIButton *defAddrBtn = [self createBtnViewWithImgName:PUBLIC_IMG_RADIO_NOR
                                                 withText:@"设置默认地址"
                                               withTarget:self
                                               withAction:@selector(defAddrBtnClick:)];
    
    [self setM_SelImgView:[defAddrBtn viewWithTag:kImageTag]];
    
    [self setM_DefAddrBtn:defAddrBtn];

    UIButton *editorBtn = [self createBtnViewWithImgName:PUBLIC_IMG_EDIT_ICO
                                                withText:@"编辑"
                                              withTarget:self
                                              withAction:@selector(editorBtnClick:)];
    
    [self setM_EditorBtn:editorBtn];
    
    UIButton *deleteBtn = [self createBtnViewWithImgName:PUBLIC_IMG_DELETED_ICO
                                                withText:@"删除"
                                              withTarget:self
                                              withAction:@selector(deleteBtnClick:)];
    
    [self setM_DeleteBtn:deleteBtn];
    
    [self addSubview:nameLbl];
    [self addSubview:telLbl];
    [self addSubview:addressLbl];
    
    [self addSubview:lineView];
    
    [funcView addSubview:defAddrBtn];
    [funcView addSubview:editorBtn];
    [funcView addSubview:deleteBtn];

    [self addSubview:funcView];
    
}

#pragma mark - Public Functions
- (void)layoutUI{
    
    [m_NameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.width.lessThanOrEqualTo(@150);
        
    }];
    
    [m_TelLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_NameLbl);
        make.left.equalTo(m_NameLbl.mas_right).offset(20);
        
    }];
    
    [m_AddressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(m_NameLbl.mas_bottom).offset(10);
        
    }];
    
    [m_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(15);
        make.right.equalTo(0);
        make.height.equalTo(0.5);
        make.top.equalTo(m_AddressLbl.mas_bottom).offset(20);
        
    }];
    
    [m_FuncView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self);
        make.top.equalTo(m_LineView.mas_bottom);
        make.bottom.equalTo(self);
        
    }];
    
    [m_DefAddrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(10);
        make.centerY.equalTo(m_FuncView.mas_centerY);
        
    }];

    [m_EditorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-90);
        make.top.equalTo(m_DefAddrBtn);
        
    }];
    
    [m_DeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(m_EditorBtn.top);
        
    }];

}

- (void)setAddressColCellUpDataSource:(AddressGoodsDM *)model
                cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [m_NameLbl setText:nil];
    [m_TelLbl setText:nil];
    [m_AddressLbl setText:nil];
    [m_SelImgView setImage:ImageNamed(PUBLIC_IMG_RADIO_NOR)];
    
    [self setM_Model:nil];
    [self setM_IndexPath:indexPath];
    
    if (!IsNilOrNull(model)) {
        
        [self setM_Model:model];
        
        [m_NameLbl setText:model.name];
        [m_TelLbl setText:model.tel];
        [m_AddressLbl setText:model.full_name];
     
        [self setDefaultAddress:model.is_top ? YES : NO];
        
    }
    
}

- (UIButton *)createBtnViewWithImgName:(NSString *)imgName withText:(NSString *)text
                            withTarget:(id)target withAction:(SEL)actionMethod{
    
    UIButton *btn = [BasisUITool getBtnWithTarget:target action:actionMethod];
    
    UIImageView *imgView = [BasisUITool getImageViewWithImage:imgName withIsUserInteraction:NO];
    
    [imgView setTag:kImageTag];
    [btn addSubview:imgView];
    
    UILabel *lbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                     size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [lbl setText:text];
    
    [btn addSubview:lbl];
   
    CGFloat spacingWidth = 7;

    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(btn).offset(spacingWidth);
        make.centerY.equalTo(btn.mas_centerY);
        
    }];

    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imgView);
        make.left.equalTo(imgView.mas_right).offset(spacingWidth);
        make.right.equalTo(btn).offset(-spacingWidth);
        
    }];
 
    return btn;
    
}

- (void)setDefaultAddress:(BOOL)isChoose{
    
    if (isChoose) {
        [m_SelImgView setImage:ImageNamed(PUBLIC_IMG_RADIO_SEL)];
    }else{
        [m_SelImgView setImage:ImageNamed(PUBLIC_IMG_RADIO_NOR)];
    }
 
}

#pragma mark - Button Handlers
- (void)defAddrBtnClick:(id)sender{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onDefAddr:cellForRowAtIndexPath:)]) {
        
        if (m_Model.is_top == 0) {

            [m_Delegate onDefAddr:m_Model cellForRowAtIndexPath:m_IndexPath];
            
        }
        
    }

}

- (void)editorBtnClick:(id)sender{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onEditor:cellForRowAtIndexPath:)]) {
        
        [m_Delegate onEditor:m_Model cellForRowAtIndexPath:m_IndexPath];
        
    }
    
}

- (void)deleteBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onDelete:cellForRowAtIndexPath:)]) {
        
        [m_Delegate onDelete:m_Model cellForRowAtIndexPath:m_IndexPath];
        
    }
    
}

@end
