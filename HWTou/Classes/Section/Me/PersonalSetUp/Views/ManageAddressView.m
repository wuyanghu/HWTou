//
//  ManageAddressView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ManageAddressView.h"
#import "PublicHeader.h"
#import "RegularExTool.h"
#import "RegionRequest.h"
#import "AddressRequest.h"
#import <YYModel/YYModel.h>

#define kButtonTag              997
#define kInputBoxTag            998

#define kDIC_Tag            (@"Tag")
#define kDIC_Title          (@"Title")
#define kDIC_Placeholder    (@"Placeholder")
#define kDIC_IsExt          (@"IsExtension")

typedef NS_ENUM(NSInteger, InputBoxType){
    
    InputBoxType_Contact = 0,   // 联系人
    InputBoxType_Phone,         // 手机号码
    InputBoxType_Region,        // 所在地区
    InputBoxType_Address,       // 详细地址
    InputBoxType_PostCode,      // 邮政编码
    
};

@interface ManageAddressView()<UITextFieldDelegate>{

    NSArray *g_DataArray;
    
    OperationsType g_OperationsType;
    
}

@property (nonatomic, strong) UITextField *m_ContactTF;
@property (nonatomic, strong) UITextField *m_PhoneTF;
@property (nonatomic, strong) UITextField *m_RegionTF;
@property (nonatomic, strong) UITextField *m_AddressTF;
@property (nonatomic, strong) UITextField *m_PostCodeTF;

@property (nonatomic, strong) UIButton *m_ActionBtn;

@property (nonatomic, strong) AddressGoodsDM *m_AddressGoodsDM;     // 用于缓存编辑时的数据
@property (nonatomic, strong) NSMutableDictionary *m_RegionDic;     // 用于缓存用户选择的地区数据

@end

@implementation ManageAddressView
@synthesize m_Delegate;
@synthesize m_ContactTF,m_PhoneTF,m_RegionTF,m_AddressTF,m_PostCodeTF;
@synthesize m_ActionBtn;

@synthesize m_AddressGoodsDM;
@synthesize m_RegionDic;

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
    
    [self addViews];
    
}

- (void)addViews{
    
    NSInteger count = [g_DataArray count];
    
    CGFloat width = kMainScreenWidth;
    CGFloat height = 40;
    
    for (NSInteger index = 0; index < count; index++) {
        
        NSDictionary *tmpDic;
        OBJECTOFARRAYATINDEX(tmpDic, g_DataArray, index);
        
        BOOL isExt = [[tmpDic objectForKey:kDIC_IsExt] boolValue];
        
        InputBoxType tag = [[tmpDic objectForKey:kDIC_Tag] integerValue];
       
        NSString *aTitle;
        OBJECTOFNSDICTIONARYBYKEY(aTitle, tmpDic, kDIC_Title);
        
        NSString *placeholder;
        OBJECTOFNSDICTIONARYBYKEY(placeholder, tmpDic, kDIC_Placeholder);
        
        CGFloat centerY = index * height;
        
        UIView *view = [self createInputBoxViewWithFrame:CGRectMake(0, centerY, width, height)
                                               withTitle:aTitle
                                         withPlaceholder:placeholder
                                         withIsExtension:isExt
                                          withIsShowLine:index + 1 == count ? NO : YES];
        
        UITextField *textTF = [view viewWithTag:kInputBoxTag];
        
        if (!IsNilOrNull(textTF)) {
            
            UIKeyboardType keyboardType = UIKeyboardTypeDefault;
            
            switch (tag) {
                case InputBoxType_Contact:{ // 联系人
                    
                    [self setM_ContactTF:textTF];
                    
                    break;}
                case InputBoxType_Phone:{ // 手机号码
                    
                    [self setM_PhoneTF:textTF];
                    
                    keyboardType = UIKeyboardTypeNumberPad;
                    
                    break;}
                case InputBoxType_Region:{ // 所在地区
                    
                    [self setM_RegionTF:textTF];
                    
                    UIButton *btn = [view viewWithTag:kButtonTag];
                    
                    [btn addTarget:self action:@selector(regionBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
                    
                    break;}
                case InputBoxType_Address:{ // 详细地址
                    
                    [self setM_AddressTF:textTF];
                    
                    break;}
                case InputBoxType_PostCode:{ // 邮政编码
                    
                    [self setM_PostCodeTF:textTF];
                    
                    keyboardType = UIKeyboardTypeNumberPad;
                    
                    break;}
                default:
                    break;
            }
            
            [textTF setKeyboardType:keyboardType];
            
        }

        [self addSubview:view];

    }
    
    UIButton *actionBtn = [BasisUITool getBtnWithTarget:self action:@selector(actionBtnClick:)];
    
    [self setM_ActionBtn:actionBtn];
    [self addSubview:actionBtn];
    
    [actionBtn setTitle:@"确认" forState:UIControlStateNormal];
    [actionBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                          forState:UIControlStateNormal];
    [actionBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                          forState:UIControlStateDisabled];
    [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(40);
        make.top.equalTo(count * height + 36);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    g_OperationsType = OperationsType_New;
    
    if (IsNilOrNull(g_DataArray)) {
        
        g_DataArray = @[@{kDIC_Tag:[NSNumber numberWithInteger:InputBoxType_Contact],kDIC_Title:@"联系人",kDIC_Placeholder:@"请输入姓名",kDIC_IsExt:[NSNumber numberWithBool:NO]},
                        @{kDIC_Tag:[NSNumber numberWithInteger:InputBoxType_Phone],kDIC_Title:@"手机号码",kDIC_Placeholder:@"请输手机号码",kDIC_IsExt:[NSNumber numberWithBool:NO]},
                        @{kDIC_Tag:[NSNumber numberWithInteger:InputBoxType_Region],kDIC_Title:@"所在地区",kDIC_Placeholder:@"请选择所在地区",kDIC_IsExt:[NSNumber numberWithBool:YES]},
                        @{kDIC_Tag:[NSNumber numberWithInteger:InputBoxType_Address],kDIC_Title:@"详细地址",kDIC_Placeholder:@"请输入详细地址",kDIC_IsExt:[NSNumber numberWithBool:NO]},
                        @{kDIC_Tag:[NSNumber numberWithInteger:InputBoxType_PostCode],kDIC_Title:@"邮政编码",kDIC_Placeholder:@"请输入邮政编码",kDIC_IsExt:[NSNumber numberWithBool:NO]}];
        
    }
    
    if (IsNilOrNull(m_RegionDic)) {
        
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [self setM_RegionDic:tmpDic];
        
    }
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (UIView *)createInputBoxViewWithFrame:(CGRect)frame withTitle:(NSString *)aTitle
                        withPlaceholder:(NSString *)placeholder withIsExtension:(BOOL)isExt
                         withIsShowLine:(BOOL)isShowLine{
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    // 标题
    UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [titleLbl setText:aTitle];
    
    [bgView addSubview:titleLbl];
    
    // 输入框
    UITextField *inputTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                             withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                      withPlaceholder:placeholder
                                                         withDelegate:self];
    
    [inputTF setTag:kInputBoxTag];
    [inputTF setClearsOnBeginEditing:NO];
    
    [bgView addSubview:inputTF];
    
    // 布局
    CGSize lblSize = [BasisUITool calculateSize:titleLbl.text font:titleLbl.font];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(bgView).offset(15);
        make.width.equalTo(lblSize.width);
        make.centerY.equalTo(bgView.mas_centerY);
        
    }];
    
    [inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGFloat right = isExt ? 43 : 15;
        
        make.leading.equalTo(80);
        make.trailing.equalTo(bgView).offset(-right);
        make.top.equalTo(titleLbl);
        
    }];
    
    // 扩展
    if (isExt) {
        
        [inputTF setUserInteractionEnabled:NO];
        
        // 按钮
        UIButton *extBtn = [BasisUITool getBtnWithTarget:nil action:nil];
        
        [extBtn setTag:kButtonTag];
        [extBtn.layer setCornerRadius:0];
        [extBtn.layer setMasksToBounds:NO];
        
        [bgView addSubview:extBtn];
        
        // ico
        UIImageView *icoImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_STRETCH_ICO
                                               withIsUserInteraction:NO];
        
        [bgView addSubview:icoImgView];
        
        [extBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(inputTF);
            make.right.equalTo(bgView);
            make.top.equalTo(0);
            make.bottom.equalTo(bgView);
            
        }];
        
        [icoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            CGRect frame = icoImgView.frame;
            
            make.right.equalTo(bgView).offset(-15);
            make.size.equalTo(CGSizeMake(frame.size.width,frame.size.height));
            make.top.equalTo(bgView.centerY).offset(-(frame.size.height / 2));
            
        }];
        
    }
    
    if (isShowLine) {
        
        UIView *lineView = [[UIView alloc] init];
        
        [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
        
        [bgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(0.5);
            make.top.equalTo(bgView.bottom).offset(-0.5);
            
        }];
        
    }
    
    return bgView;
    
}

- (void)setAddressData:(AddressGoodsDM *)model{
    
    [self setM_AddressGoodsDM:model];
    g_OperationsType = OperationsType_Modify;
    
    [m_ContactTF setText:model.name];
    [m_PhoneTF setText:model.tel];
    
    NSString *tmpStr = nil;
    
    if (!IsStrEmpty(model.pname)) {
        
        tmpStr = model.pname;
        
    }
    if (!IsStrEmpty(model.cname)) {
    
        tmpStr = [tmpStr stringByAppendingString:[NSString stringWithFormat:@" %@",model.cname]];
        
    }
    if (!IsStrEmpty(model.dname)){
    
        tmpStr = [tmpStr stringByAppendingString:[NSString stringWithFormat:@" %@",model.dname]];
        
    }
    
    [m_RegionTF setText:tmpStr];
    
    [m_AddressTF setText:model.address];
    [m_PostCodeTF setText:model.post_code];
    
    [m_ActionBtn setTitle:@"保存" forState:UIControlStateNormal];
    
}

- (void)updateSelectionArea:(NSDictionary *)dic{

    [m_RegionDic setDictionary:dic];
    
    RegionResult *provinceModel;
    OBJECTOFNSDICTIONARYBYKEY(provinceModel, dic, kDIC_Region_Province);
    
    RegionResult *cityModel;
    OBJECTOFNSDICTIONARYBYKEY(cityModel, dic, kDIC_Region_City);
    
    RegionResult *areaModel;
    OBJECTOFNSDICTIONARYBYKEY(areaModel, dic, kDIC_Region_Area);
    
    NSString *tmpStr;
    
    if (!IsStrEmpty(provinceModel.name)) {
        
        tmpStr = provinceModel.name;
        
    }
    if (!IsStrEmpty(cityModel.name)) {
        
        tmpStr = [tmpStr stringByAppendingString:[NSString stringWithFormat:@" %@",cityModel.name]];
        
    }
    if (!IsStrEmpty(areaModel.name)){
        
        tmpStr = [tmpStr stringByAppendingString:[NSString stringWithFormat:@" %@",areaModel.name]];
        
    }
    
    [m_RegionTF setText:tmpStr];
    
    if (!IsNilOrNull(m_AddressGoodsDM)) {
        
        [m_AddressGoodsDM setP_id:provinceModel.id];
        [m_AddressGoodsDM setCity_id:cityModel.id];
        [m_AddressGoodsDM setD_id:areaModel.id];
        
        m_AddressGoodsDM.pname = provinceModel.name;
        m_AddressGoodsDM.cname = cityModel.name;
        m_AddressGoodsDM.dname = areaModel.name;
    }
    
}

- (BOOL)addressDataValidation{

    BOOL isThrough = NO;
    NSString *promptStr = nil;
    
    if (IsStrEmpty(m_ContactTF.text)) {
        
        promptStr = m_ContactTF.placeholder;
        
    }else if (![RegularExTool validateMobile:m_PhoneTF.text]){
    
        promptStr = @"请输入一个有效的手机号码";
        
    }else if (IsStrEmpty(m_RegionTF.text)){
    
        promptStr = m_RegionTF.placeholder;
        
    }else if (IsStrEmpty(m_AddressTF.text)){
        
        promptStr = m_AddressTF.placeholder;
        
    }else{
        
        isThrough = YES;
        
    }
    
    if (!IsStrEmpty(promptStr)) [HUDProgressTool showOnlyText:[NSString stringWithFormat:@"%@!",promptStr]];
    
    return isThrough;
    
}

#pragma mark - Button Handlers
- (void)regionBtnClick:(id)sender{// 地区选取

    [self endEditing:YES];
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onSelectedRegion)]) {
        
        [m_Delegate onSelectedRegion];
        
    }
    
}

- (void)actionBtnClick:(id)sender{

    if ([self addressDataValidation]) {
    
        RegionResult *provinceModel;
        OBJECTOFNSDICTIONARYBYKEY(provinceModel, m_RegionDic, kDIC_Region_Province);
        
        RegionResult *cityModel;
        OBJECTOFNSDICTIONARYBYKEY(cityModel, m_RegionDic, kDIC_Region_City);
        
        RegionResult *areaModel;
        OBJECTOFNSDICTIONARYBYKEY(areaModel, m_RegionDic, kDIC_Region_Area);
        
        AddressParam *param = [[AddressParam alloc] init];
        
        [param setName:m_ContactTF.text];
        [param setTel:m_PhoneTF.text];
        [param setAddress:m_AddressTF.text];
        [param setPost_code:m_PostCodeTF.text];
        
        switch (g_OperationsType) {
            case OperationsType_New:{

                [param setP_id:provinceModel.id];
                [param setCity_id:cityModel.id];
                [param setD_id:areaModel.id];
                
                [self addConsigneeAddressWithParam:param];
                
                break;}
            case OperationsType_Modify:{
                
                if (!IsNilOrNull(m_AddressGoodsDM)) {
                    
                    [param setMaid:m_AddressGoodsDM.maid];
                    [param setP_id:m_AddressGoodsDM.p_id];
                    [param setCity_id:m_AddressGoodsDM.city_id];
                    [param setD_id:m_AddressGoodsDM.d_id];
                    
                    [self modifyConsigneeAddressWithParam:param];
                    
                }
                
                break;}
            default:
                break;
        }
        
    }
    
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark - NetworkRequest Manager
- (void)addConsigneeAddressWithParam:(AddressParam *)param{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [AddressRequest addConsigneeAddressWithParam:param success:^(AddressAddResp *response) {
        
        if (response.success) {

            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [HUDProgressTool showSuccessWithText:ReqSuccessful];
                
                if (m_Delegate && [m_Delegate respondsToSelector:@selector(onAddAddressSuccess:)]) {
                    
                    // 对象数据转换
                    NSDictionary *dictObj = [param yy_modelToJSONObject];
                    AddressGoodsDM *dmAddress = [AddressGoodsDM yy_modelWithJSON:dictObj];
                    dmAddress.maid = response.data.maid;
                    
                    RegionResult *provinceModel;
                    OBJECTOFNSDICTIONARYBYKEY(provinceModel, self.m_RegionDic, kDIC_Region_Province);
                    
                    RegionResult *cityModel;
                    OBJECTOFNSDICTIONARYBYKEY(cityModel, self.m_RegionDic, kDIC_Region_City);
                    
                    RegionResult *areaModel;
                    OBJECTOFNSDICTIONARYBYKEY(areaModel, self.m_RegionDic, kDIC_Region_Area);
                    
                    dmAddress.full_name = [NSString stringWithFormat:@"%@%@%@%@", provinceModel.name, cityModel.name, areaModel.name, param.address];
                    
                    [m_Delegate onAddAddressSuccess:dmAddress];
                    
                }
                
            });
            
        }else{
        
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

- (void)modifyConsigneeAddressWithParam:(AddressParam *)param{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [AddressRequest modifyConsigneeAddressWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {
            
            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [HUDProgressTool showSuccessWithText:ReqSuccessful];
                
                if (m_Delegate && [m_Delegate respondsToSelector:@selector(onModifyAddressSuccess:)]) {
                    
                    // 对象数据转换
                    NSDictionary *dictObj = [param yy_modelToJSONObject];
                    AddressGoodsDM *dmAddress = [AddressGoodsDM yy_modelWithJSON:dictObj];
                    
                    dmAddress.pname = m_AddressGoodsDM.pname;
                    dmAddress.cname = m_AddressGoodsDM.cname;
                    dmAddress.dname = m_AddressGoodsDM.dname;
                    
                    dmAddress.full_name = [NSString stringWithFormat:@"%@%@%@%@", m_AddressGoodsDM.pname, m_AddressGoodsDM.cname, m_AddressGoodsDM.dname, param.address];
                    
                    [m_Delegate onModifyAddressSuccess:dmAddress];
                    
                }
                
            });
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
