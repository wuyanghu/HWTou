//
//  ShareMomentsView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ShareMomentsView.h"

#import "PublicHeader.h"
#import "UITextView+MaxLength.h"

#import "ComImageUpload.h"
#import "CalabashRequest.h"
#import "MediaColViewCell.h"

#define kMaxNumMedia            9

#define kNumberRows             4
#define kItemWidth              (kMainScreenWidth - kItemSpacingWidth * (kNumberRows - 1) - 30) / kNumberRows
#define kItemHeight             kItemWidth
#define kItemSpacingWidth       5
#define kItemSpacingHeight      5

@interface ShareMomentsView()<MediaColViewCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIView *m_MediaBgView;
@property (nonatomic, strong) UITextView *m_ShareTV;
@property (nonatomic, strong) UILabel *m_PromptLbl;
@property (nonatomic, strong) UICollectionView *m_ColView;                  // 媒体文件的展示

@property (nonatomic, strong) MediaModel *m_MediaModel;                     // 用于缓存一个添加按钮
@property (nonatomic, strong) NSMutableArray<MediaModel *> *m_MediaArray;   // 缓存用户添加的媒体文件

@end

@implementation ShareMomentsView
@synthesize m_Delegate;
@synthesize m_MediaBgView;
@synthesize m_ShareTV;
@synthesize m_PromptLbl;
@synthesize m_ColView;

@synthesize m_MediaModel;
@synthesize m_MediaArray;

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
    
    UIView *bgView = [[UIView alloc] init];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *shareTV = [[UITextView alloc] init];
    
    [shareTV setDelegate:self];
    [shareTV setMaxLength:140];// 限制输入字符 - 最大输入140字符
    [shareTV setShowsVerticalScrollIndicator:NO];
    [shareTV setBackgroundColor:[UIColor clearColor]];
    [shareTV setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [shareTV setFont:FontPFRegular(CLIENT_COMMON_FONT_CONTENT_SIZE)];
    
    [self setM_ShareTV:shareTV];
    
    UILabel *promptLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                           size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [promptLbl setText:@"分享点什么..."];
    
    [self setM_PromptLbl:promptLbl];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setMinimumLineSpacing:kItemSpacingWidth];
    [layout setMinimumInteritemSpacing:kItemSpacingHeight];
    [layout setItemSize:CGSizeMake(kItemWidth, kItemHeight)];
    [layout setSectionInset:UIEdgeInsetsMake(5, 15, 5, 15)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:layout];
    
    [colView setDelegate:self];
    [colView setDataSource:self];
    [colView setBackgroundColor:[UIColor clearColor]];
    
    [self setM_ColView:colView];
    
    // UICollectionViewCell 注册 否则会报错
    [colView registerClass:[MediaColViewCell class] forCellWithReuseIdentifier:kMediaColViewCellId];
    
    [shareTV addSubview:promptLbl];
    [bgView addSubview:shareTV];
    [bgView addSubview:colView];
    
    [self setM_MediaBgView:bgView];
    [self addSubview:bgView];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return [m_MediaArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = [indexPath row];
    
    MediaColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMediaColViewCellId
                                                                       forIndexPath:indexPath];
    
    [cell setM_Delegate:self];
    
    MediaModel *model;
    OBJECTOFARRAYATINDEX(model, m_MediaArray, row);
    
    [cell setMediaColViewCellUpDataSource:model cellForRowAtIndexPath:indexPath];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    if (IsNilOrNull(m_MediaArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        if (IsNilOrNull(m_MediaModel)) {
            
            MediaModel *model = [[MediaModel alloc] init];
            
            [model setM_MediaType:MediaType_Button];
            
            [self setM_MediaModel:model];
            
        }
        
        [tmpArray addObject:m_MediaModel];
        
        [self setM_MediaArray:tmpArray];
        
    }
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (void)layoutUI{
    
    [m_MediaBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(m_ColView.mas_bottom).offset(5);
        
    }];
    
    [m_ShareTV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.equalTo(m_MediaBgView).equalTo(15);
        make.right.equalTo(m_MediaBgView).offset(-15);
        make.height.equalTo(70);
        
    }];
    
    [m_PromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_ShareTV).offset(7);
        make.left.equalTo(m_ShareTV).offset(7);
        make.right.equalTo(m_ShareTV);
        
    }];
    
    [m_ColView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_ShareTV.mas_bottom).offset(5);
        make.left.and.right.equalTo(m_MediaBgView);
        make.height.equalTo([self calculateColViewHeight]);
        
    }];
    
}

- (void)shareContentCheck{
    
    NSString *content = m_ShareTV.text;
    NSInteger count = [m_MediaArray count] - 1; // 扣除添加按钮
    
    if (!IsStrEmpty(content) || count > 0) {
        
        if (count == 0) {// 无媒体分享
            
            [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
            
            MomentParam *param = [[MomentParam alloc] init];
            
            [param setRemark:m_ShareTV.text];
            
            [self shareMomentsWithParam:param];
            
        }else if (count == 1){// 单个文件上传
            
            MediaModel *model;
            OBJECTOFARRAYATINDEX(model, m_MediaArray, 0);
            
            if (!IsNilOrNull(model)) {
                
                [self singleImgUploadWithParam:model.m_Image];
                
            }
            
        }else{// 批量上传
            
            NSMutableArray *tmpMediaArray = [NSMutableArray arrayWithCapacity:0];
            
            [m_MediaArray enumerateObjectsUsingBlock:^(MediaModel *obj, NSUInteger idx, BOOL *stop) {
                
                if (obj.m_MediaType == MediaType_LocalImg) {// 处理图片
                    
                    [tmpMediaArray addObject:obj.m_Image];
                    
                }
                
            }];
            
            [self batchImgUploadWithParam:tmpMediaArray];
            
        }
        
    }else{
        
        [HUDProgressTool showOnlyText:@"分享点什么..."];
        
    }
    
}

- (void)returnsMediaFile:(NSArray<MediaModel *> *)imgArray{
    
    if (!IsArrEmpty(imgArray)) {
        
        [m_MediaArray enumerateObjectsUsingBlock:^(MediaModel *obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj isEqual:m_MediaModel]) {
                
                REMOVEOBJECTOFARRAYATINDEX(m_MediaArray, idx);
                
            }
            
        }];
        
        [m_MediaArray addObjectsFromArray:imgArray];
        
        if ([m_MediaArray count] < kMaxNumMedia) {// 上传媒体文件数量限制
            
            [m_MediaArray addObject:m_MediaModel];// 添加按钮
            
        }
        
        [m_ColView reloadData];
        
        // layoutUI
        [m_ColView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo([self calculateColViewHeight]);
            
        }];
        
    }
    
}

- (CGFloat)calculateColViewHeight{
    
    double totalRow = (double)[m_MediaArray count] / (double)kNumberRows;
    
    CGFloat height = kItemHeight * ceil(totalRow) + kItemSpacingHeight * floor(totalRow) + 10;
    
    return height;
    
}

#pragma mark - Button Handlers

#pragma mark - MediaColViewCell Delegate Methods
- (void)onDidSelectItem:(MediaModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (model.m_MediaType == MediaType_Button) {// 添加图片
        
        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onChooseMediaSource:)]) {
            
            [m_Delegate onChooseMediaSource:kMaxNumMedia - ([m_MediaArray count] - 1)];// -1 是因为数组中存有添加按钮
            
        }
        
    }else if (model.m_MediaType == MediaType_LocalImg){// 本地图片浏览
        
        NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:[m_MediaArray count]];
        
        [m_MediaArray enumerateObjectsUsingBlock:^(MediaModel *obj, NSUInteger idx, BOOL *stop) {
            
            if (obj.m_MediaType == MediaType_LocalImg) {
                
                [imgArray addObject:[[UIImageView alloc] initWithImage:obj.m_Image]];
                
            }
            
        }];
        
        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onPhotoBrowse:currentIndex:)]) {
            
            NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:[m_MediaArray count]];
            
            [m_MediaArray enumerateObjectsUsingBlock:^(MediaModel *obj, NSUInteger idx, BOOL *stop) {
                
                if (obj.m_MediaType == MediaType_LocalImg) {
                    
                    [imgArray addObject:[[UIImageView alloc] initWithImage:obj.m_Image]];
                    
                }
                
            }];
            
            [m_Delegate onPhotoBrowse:imgArray currentIndex:[indexPath row]];
            
        }
        
    }
    
}

- (void)onDeleteItem:(MediaModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    REMOVEOBJECTOFARRAYATINDEX(m_MediaArray, [indexPath row]);
    
    BOOL isAdd = YES;
    
    for (MediaModel *obj in m_MediaArray) {
        
        if (obj.m_MediaType == MediaType_Button) {
            
            isAdd = NO;
            
            break;
            
        }
        
    }
    
    if (isAdd) {
        
        [m_MediaArray addObject:m_MediaModel];
        
    }
    
    [m_ColView reloadData];
    
    // layoutUI
    [m_ColView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo([self calculateColViewHeight]);
        
    }];
    
}

#pragma mark - UITextView Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [m_PromptLbl setHidden:IsStrEmpty(m_ShareTV.text) ? NO : YES];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    [m_PromptLbl setHidden:IsStrEmpty(m_ShareTV.text) ? NO : YES];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [m_PromptLbl setHidden:IsStrEmpty(m_ShareTV.text) ? NO : YES];
    
}

#pragma mark - NetworkRequest Manager
- (void)shareMomentsWithParam:(MomentParam *)param{
    
    [CalabashRequest shareMomentsWithParam:param success:^(BaseResponse *response) {
        
        if (response.success){
            
            [HUDProgressTool showSuccessWithText:ReqSuccessful];
            
            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (m_Delegate && [m_Delegate respondsToSelector:@selector(onShareMomentsSuccess)]){
                    
                    [m_Delegate onShareMomentsSuccess];
                    
                }
                
            });
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

// 单个图片上传
- (void)singleImgUploadWithParam:(UIImage *)image{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ComImageUpload singleWithImage:image success:^(NSString *url) {
        
        MomentParam *param = [[MomentParam alloc] init];
        
        [param setRemark:m_ShareTV.text];
        [param setImgs:@[url]];
        
        [self shareMomentsWithParam:param];
        
    } failure:^(NSString *errMsg) {
        
        [HUDProgressTool showErrorWithText:errMsg];
        
    }];
    
}

// 图片批量上传
- (void)batchImgUploadWithParam:(NSArray<UIImage *> *)images{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ComImageUpload batchWithImages:images success:^(NSArray<NSString *> *url) {
        
        MomentParam *param = [[MomentParam alloc] init];
        
        [param setRemark:m_ShareTV.text];
        [param setImgs:url];
        
        [self shareMomentsWithParam:param];
        
    } failure:^(NSString *errMsg) {
        
        [HUDProgressTool showErrorWithText:errMsg];
        
    }];
    
}

@end
