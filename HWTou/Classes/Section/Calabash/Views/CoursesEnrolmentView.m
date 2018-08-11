//
//  CoursesEnrolmentView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CoursesEnrolmentView.h"

#import "PublicHeader.h"

#import "CalabashRequest.h"
#import "CourseColViewCell.h"
#import "CourseAddressColViewCell.h"

#define kColHeaderTag   98
#define kColFooterTag   99

@interface CoursesEnrolmentView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *m_ColView;
@property (nonatomic, strong) UITextField *m_StudentIdTF;
@property (nonatomic, strong) UIButton *m_ConfirmBtn;

@property (nonatomic, strong) CourseModel *m_CourseModel;
@property (nonatomic, strong) CoursesAddressModel *m_CoursesAddressModel;   // 缓存选中的报名地址

@end

@implementation CoursesEnrolmentView
@synthesize m_Delegate;
@synthesize m_ColView;
@synthesize m_StudentIdTF;
@synthesize m_ConfirmBtn;

@synthesize m_CourseModel,m_CoursesAddressModel;

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
    
    [self addColView];
    [self addconfirmBtn];
    
}

- (void)addColView{
 
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:10];
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:layout];
    
    [colView setDelegate:self];
    [colView setDataSource:self];
    [colView setBackgroundColor:[UIColor clearColor]];
    
    [self setM_ColView:colView];
    [self addSubview:colView];
    
    // UICollectionViewCell 注册 否则会报错
    [colView registerClass:[CourseColViewCell class]
forCellWithReuseIdentifier:kCourseColViewCellId];
    
    [colView registerClass:[CourseAddressColViewCell class]
forCellWithReuseIdentifier:kCourseAddressColViewCellId];
    
    [colView registerClass:[UICollectionViewCell class]
forCellWithReuseIdentifier:@"ColCellId"];
    
    // 头部与脚部
    [colView registerClass:[UICollectionReusableView class]
forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
       withReuseIdentifier:@"CollectionReusableView"];
    
    [colView registerClass:[UICollectionReusableView class]
forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
       withReuseIdentifier:@"CollectionReusableView"];
    
}

- (void)addconfirmBtn{

    UIButton *confirmBtn = [BasisUITool getBtnWithTarget:self action:@selector(confirmBtnBtnClick:)];
    
    [confirmBtn.layer setCornerRadius:0];
    [confirmBtn.layer setMasksToBounds:NO];
    
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                          forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                          forState:UIControlStateDisabled];
    
    [self setM_ConfirmBtn:confirmBtn];
    [self addSubview:confirmBtn];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{

    NSInteger count = 0;
    
    if (!IsNilOrNull(m_CourseModel)) {
        
        if (section == 0) {
            
            count = 1;
            
        }else{
            
            count = [m_CourseModel.addresses count];
            
        }
        
    }
    
    return count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    UICollectionViewCell *rCell;
    
    if (section == 0) {

        CourseColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseColViewCellId
                                                                            forIndexPath:indexPath];
        
        [cell setCourseColCellUpDataSource:m_CourseModel cellForRowAtIndexPath:indexPath];
        
        rCell = cell;
        
    }else if (section == 1){
        
        CourseAddressColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseAddressColViewCellId
                                                                                   forIndexPath:indexPath];
        
        CoursesAddressModel *model;
        OBJECTOFARRAYATINDEX(model, m_CourseModel.addresses, row);
        
        BOOL isEnd = row + 1 == [m_CourseModel.addresses count] ? YES : NO;
        
        [cell setCourseAddressColViewCellUpDataSource:model
                                cellForRowAtIndexPath:indexPath
                                            withIsEnd:isEnd];

        if (row == 0) {

            [cell.m_SelectView setHidden:NO];
            [self setM_CoursesAddressModel:model];
            
            [collectionView selectItemAtIndexPath:indexPath
                                         animated:NO
                                   scrollPosition:UICollectionViewScrollPositionNone];
            
        }
        
        rCell = cell;
        
    }
    
    if (IsNilOrNull(rCell)) {
        
        static  NSString * colCellId = @"ColCellId";
        
        rCell = [collectionView dequeueReusableCellWithReuseIdentifier:colCellId
                                                          forIndexPath:indexPath];
        
        [rCell setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    return rCell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath section] == 1) {
        
        UICollectionReusableView *colReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionReusableView" forIndexPath:indexPath];
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            UIView *bgView = [colReusableView viewWithTag:kColHeaderTag];
            
            if (IsNilOrNull(bgView)) {
                
                bgView = [[UIView alloc] init];
                
                [bgView setTag:kColHeaderTag];
                [bgView setBackgroundColor:[UIColor whiteColor]];
                
                UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                                      size:CLIENT_COMMON_FONT_CONTENT_SIZE];
                
                [titleLbl setText:@"选择课程地址"];
                [bgView addSubview:titleLbl];
                
                UIView *lineView = [[UIView alloc] init];
                
                [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
                
                [bgView addSubview:lineView];
                
                [colReusableView addSubview:bgView];
                
                [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.edges.equalTo(colReusableView);
                    
                }];
                
                [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.left.equalTo(15);
                    make.right.equalTo(bgView).offset(-15);
                    make.centerY.equalTo(bgView.mas_centerY);
                    
                }];
                
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.and.right.equalTo(bgView);
                    make.bottom.equalTo(bgView);
                    make.height.equalTo(0.5);
                    
                }];
                
            }
            
        }else{
            
            UIView *bgView = [colReusableView viewWithTag:kColFooterTag];
            
            if (IsNilOrNull(bgView)){
            
                bgView = [[UIView alloc] init];
                
                [bgView setTag:kColFooterTag];
                [bgView setBackgroundColor:[UIColor whiteColor]];
                
                UILabel *titleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                                      size:CLIENT_COMMON_FONT_CONTENT_SIZE];
                
                [titleLbl setText:@"填写学员学号"];
                [bgView addSubview:titleLbl];
                
                UITextField *studentIdTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                                             withSize:CLIENT_COMMON_FONT_CONTENT_SIZE
                                                                      withPlaceholder:@"请输入您的学号"
                                                                         withDelegate:self];
                
                [studentIdTF setKeyboardType:UIKeyboardTypeNumberPad];
                
                [self setM_StudentIdTF:studentIdTF];
                [bgView addSubview:studentIdTF];
                
                [colReusableView addSubview:bgView];
                
                [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.edges.equalTo(colReusableView);
                    
                }];
                
                [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(15);
                    make.width.equalTo(100);
                    make.centerY.equalTo(bgView.mas_centerY);
                    
                }];
                
                [studentIdTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(titleLbl.mas_right).offset(15);
                    make.right.equalTo(bgView).offset(-15);
                    make.centerY.equalTo(bgView.mas_centerY);
                    
                }];
                
            }
            
        }
        
        return colReusableView;
        
    }

    return nil;
    
}

// 头部视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (section == 1) {
        
        width = collectionView.frame.size.width;
        height = 40;
        
    }

    return CGSizeMake(width, height);
    
}

// 脚部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (section == 1) {
        
        width = collectionView.frame.size.width;
        height = 40;
        
    }
    
    return CGSizeMake(width, height);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = [indexPath section] == 0 ? 100 : 40;
    
    return CGSizeMake(collectionView.frame.size.width, height);
    
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath section] == 1) {
        
        CourseAddressColViewCell *cell = (CourseAddressColViewCell *)[collectionView
                                                                      cellForItemAtIndexPath:indexPath];
        
        [cell.m_SelectView setHidden:NO];
        [self setM_CoursesAddressModel:cell.m_Model];
        
    }

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath section] == 1) {
        
        CourseAddressColViewCell *cell = (CourseAddressColViewCell *)[collectionView
                                                                cellForItemAtIndexPath:indexPath];
        
        [cell.m_SelectView setHidden:YES];
        
    }
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (void)layoutUI{
    
    [m_ColView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(m_ConfirmBtn.mas_top);
        
    }];
    
    [m_ConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_ColView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(40);
        make.bottom.equalTo(self);
        
    }];
    
}

- (void)setCoursesEnrolmentViewDataSource:(CourseModel *)model{

    if (!IsNilOrNull(model)) {
        
        [self setM_CourseModel:model];
        
        [m_ColView reloadData];
        
    }
    
}

#pragma mark - Button Handlers
- (void)confirmBtnBtnClick:(id)sender{
    
    if (IsStrEmpty(m_StudentIdTF.text)) {
        
        [HUDProgressTool showOnlyText:m_StudentIdTF.placeholder];
        
    }else{
        
        CoursesEnrolmentParam *param = [[CoursesEnrolmentParam alloc] init];
        
        [param setC_id:m_CourseModel.id];
        [param setStu_id:[m_StudentIdTF.text integerValue]];
        [param setAddress_id:m_CoursesAddressModel.id];
        
        [self coursesEnrolmentWithParam:param];
        
    }
    
}

#pragma mark - NetworkRequest Manager
- (void)coursesEnrolmentWithParam:(CoursesEnrolmentParam *)param{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [CalabashRequest coursesEnrolmentWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {
        
            [HUDProgressTool dismiss];
            
            if (m_Delegate && [m_Delegate respondsToSelector:
                               @selector(onEnrolmentSuccess:withAddressInfo:)]) {
                
                [m_Delegate onEnrolmentSuccess:m_CourseModel withAddressInfo:m_CoursesAddressModel];
                
            }
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
