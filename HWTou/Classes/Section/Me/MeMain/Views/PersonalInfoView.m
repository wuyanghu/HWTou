//
//  PersonalInfoView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonalInfoView.h"

#import "PublicHeader.h"

#import "ComImageUpload.h"
#import "PersonalInfoReq.h"

#define kInputTextBoxTag        (98)
#define kTextFieldLength        (14)

@interface PersonalInfoView()<UITextFieldDelegate>{

    BOOL g_IsModify;
    
}

@property (nonatomic, strong) UIView *m_AvatarBgView;
@property (nonatomic, strong) UIImageView *m_AvatarImgView;

@property (nonatomic, strong) UIView *m_InfoView;
@property (nonatomic, strong) UITextField *m_NicknameTF;
@property (nonatomic, strong) UILabel *m_PhoneLbl;

@property (nonatomic, strong) PersonalInfoDM *m_Model;

@end

@implementation PersonalInfoView
@synthesize m_Delegate;

@synthesize m_AvatarBgView;
@synthesize m_AvatarImgView;

@synthesize m_InfoView;
@synthesize m_NicknameTF;
@synthesize m_PhoneLbl;

@synthesize m_Model;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self dataInitialization];
        [self addMainView];
        
        [self setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addAvatarBgView];
    [self addInfoView];
    
}

- (void)addAvatarBgView{

    UIView *bgView = [[UIView alloc] init];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *avatarImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR
                                              withIsUserInteraction:NO];
    
    [avatarImgView setContentMode:UIViewContentModeScaleToFill];
    
    [self setM_AvatarImgView:avatarImgView];
    [bgView addSubview:avatarImgView];
    
    UILabel *promptLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                           size:CLIENT_COMMON_FONT_DETAILS_SIZE];
    
    [promptLbl setText:@"点击修改头像"];
    [bgView addSubview:promptLbl];
    
    UIButton *avatarBtn = [BasisUITool getBtnWithTarget:self
                                                 action:@selector(avatarBtnClick:)];
    
    [avatarBtn.layer setCornerRadius:0];
    [avatarBtn.layer setMasksToBounds:NO];
    
    [bgView addSubview:avatarBtn];
    
    [self setM_AvatarBgView:bgView];
    [self addSubview:bgView];
    
    /* ********** layout UI ********** */
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self);
        make.left.and.right.equalTo(self);
        make.height.equalTo(115);
        
    }];
    
    [avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView).offset(12.5);
        make.centerX.equalTo(bgView.mas_centerX);
        make.size.equalTo(CGSizeMake(65, 65));
        
    }];
    
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(avatarImgView.mas_bottom).offset(11.5);
        make.centerX.equalTo(avatarImgView.mas_centerX);
        
    }];

    [avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(avatarImgView);
        make.leading.trailing.equalTo(promptLbl);
        make.bottom.equalTo(promptLbl.mas_bottom);
        
    }];
    
    /* ********** layout UI End ********** */
    
}

- (void)addInfoView{

    UIView *bgView = [[UIView alloc] init];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *nicknameView = [self createInputTextBoxViewWithTitle:@"昵 称" withInputType:1];
    
    [self setM_NicknameTF:[nicknameView viewWithTag:kInputTextBoxTag]];
    [bgView addSubview:nicknameView];
    
    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [bgView addSubview:lineView];
    
    UIView *phoneView = [self createInputTextBoxViewWithTitle:@"手机号" withInputType:2];
    
    [self setM_PhoneLbl:[phoneView viewWithTag:kInputTextBoxTag]];
    [bgView addSubview:phoneView];
    
    [self setM_InfoView:bgView];
    [self addSubview:bgView];
    
    /* ********** layout UI ********** */

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(m_AvatarBgView.mas_bottom).offset(10);
        make.left.and.right.equalTo(self);
        make.height.equalTo(80);
        
    }];
    
    [nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView);
        make.left.and.right.equalTo(bgView);
        make.height.equalTo(39.75);
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nicknameView.mas_bottom);
        make.left.and.right.equalTo(bgView);
        make.height.equalTo(0.5);
        
    }];
    
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView.mas_bottom);
        make.left.and.right.equalTo(bgView);
        make.height.equalTo(nicknameView);
        
    }];
    
    /* ********** layout UI End ********** */
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    g_IsModify = NO;
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (void)setPersonalInfo:(PersonalInfoDM *)model{

    [self setM_Model:model];
    
    if (IsStrEmpty(model.head_url)) {
        
        [m_AvatarImgView setImage:ImageNamed(PUBLIC_IMG_SYSTEM_AVATAR)];
        
    }else{
    
        NSString *urlStr = model.head_url;
        
        NSURL *url = [NSURL URLWithString:
                      [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [m_AvatarImgView sd_setImageWithURL:url placeholderImage:ImageNamed(PUBLIC_IMG_SYSTEM_AVATAR) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            // 圆处理
            CGSize size = m_AvatarImgView.bounds.size;
            
            CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:MIN(size.width, size.height)];
            
            [m_AvatarImgView.layer setMask:shape];
            
        }];
        
    }
    
    [m_NicknameTF setAttributedText:[self underline:model.nickname]];
    [m_PhoneLbl setAttributedText:[self underline:model.phone]];
    
}

- (void)modifyPersonalInfo{

    if (g_IsModify || ![m_NicknameTF.text isEqualToString:m_Model.nickname]) {
        
        if (g_IsModify) {// 有修改头像
            
            [self singleImgUploadWithParam:m_AvatarImgView.image];
            
        }else{
            
            [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
            
            PersonalInfoUpdateParam *param = [[PersonalInfoUpdateParam alloc] init];
            
            [param setHead_url:m_Model.head_url];
            [param setNickname:m_NicknameTF.text];
            
            [self updatePersonalInfo:param];
            
        }
        
    }else{
        
        [HUDProgressTool showOnlyText:@"未做任何修改!"];
        
    }
    
}

- (void)returnsMedia:(UIImage *)img{
    
    g_IsModify = YES;
    
    if (IsNilOrNull(img)) {
        
        [m_AvatarImgView setImage:ImageNamed(PUBLIC_IMG_SYSTEM_AVATAR)];
        
    }else{
        
        [m_AvatarImgView setImage:img];
        
        // 圆处理
        CGSize size = m_AvatarImgView.bounds.size;
        
        CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:MIN(size.width, size.height)];
        
        [m_AvatarImgView.layer setMask:shape];
        
    }
    
}

- (UIView *)createInputTextBoxViewWithTitle:(NSString *)title withInputType:(NSInteger)type{

    UIView *bgView = [[UIView alloc] init];
    
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [titleLbl setText:title];
    
    [bgView addSubview:titleLbl];
    
    if (type == 1) {
        
        UITextField *tf = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                            withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                     withPlaceholder:title
                                                        withDelegate:self];
        
        [tf setTag:kInputTextBoxTag];
        
        // 输入监听
        [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [bgView addSubview:tf];
        
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(titleLbl.mas_centerY);
            make.leading.equalTo(titleLbl.mas_trailing).offset(10);
            make.trailing.equalTo(bgView).offset(-16);
            
        }];
        
    }else if (type == 2){
    
        UILabel *lbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                         size:CLIENT_COMMON_FONT_CONTENT_SIZE];
        
        [lbl setTag:kInputTextBoxTag];
        [bgView addSubview:lbl];
        
        UIButton *btn = [BasisUITool getBtnWithTarget:self action:@selector(phoneBtnClick:)];
        
        [bgView addSubview:btn];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(titleLbl.mas_centerY);
            make.leading.equalTo(titleLbl.mas_trailing).offset(10);
            make.trailing.equalTo(bgView).offset(-16);
            
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(lbl);
            
        }];
        
    }
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(bgView.mas_centerY);
        make.leading.equalTo(bgView).offset(16);
        make.width.equalTo(55);
        
    }];
    
    return bgView;
    
}

- (NSMutableAttributedString *)underline:(NSString *)text{

    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRange contentRange = {0,[content length]};
    
    [content addAttribute:NSUnderlineStyleAttributeName
                    value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                    range:contentRange];
    
    //设置下划线颜色...
    [content addAttribute:NSUnderlineColorAttributeName
                    value:UIColorFromHex(CLIENT_LINE_GRAY_BG)
                    range:contentRange];
    
    return content;
    
}

- (void)textFieldDidChange:(UITextField *)textField{
    
    if ([textField isEqual:m_NicknameTF]) {
        
        if (textField.text.length > kTextFieldLength) {
            
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:kTextFieldLength];
            
            [textField setText:[textField.text substringToIndex:range.location]];
            
        }
        
    }
    
}

#pragma mark - Button Handlers
- (void)avatarBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onSelMediaResource)]) {
        
        [m_Delegate onSelMediaResource];
        
    }
    
}

- (void)phoneBtnClick:(id)sender{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onModifyPhone:)]) {
        
        [m_Delegate onModifyPhone:m_PhoneLbl.text];
        
    }
    
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:m_NicknameTF]){// 失去焦点操作
        
        NSString *text = m_NicknameTF.text;
        
        if (IsStrEmpty(text) || text.length == 0) {
            
            [m_NicknameTF setAttributedText:[self underline:m_Model.nickname]];
            
        }else{
            
            [m_NicknameTF setAttributedText:[self underline:text]];
            
        }
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    if ([textField isEqual:m_NicknameTF]){
        
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        NSInteger length = existedLength - selectedLength + replaceLength;
        
        if (length > kTextFieldLength) {
            
            return NO;
            
        }
        
    }
    
    return YES;
    
}

#pragma mark - NetworkRequest Manager
- (void)singleImgUploadWithParam:(UIImage *)image{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ComImageUpload singleWithImage:image success:^(NSString *url) {
        
        PersonalInfoUpdateParam *param = [[PersonalInfoUpdateParam alloc] init];
        
        [param setHead_url:url];
        [param setNickname:m_NicknameTF.text];
        
        [self updatePersonalInfo:param];
        
    } failure:^(NSString *errMsg) {
        
        [HUDProgressTool showErrorWithText:errMsg];
        
    }];
    
}

- (void)updatePersonalInfo:(PersonalInfoUpdateParam *)param{
    
    [PersonalInfoReq updatePersonalInfo:param Success:^(BaseResponse *response) {
        if (response.status == 200) {
            [HUDProgressTool showSuccessWithText:ReqSuccessful];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
    
}

@end
