//
//  MomentColViewCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MomentColViewCell.h"

#import "Math.h"
#import "PublicHeader.h"
#import "PYPhotoBrowser.h"
//#import "UICollectionView+ARDynamicCacheHeightLayoutCell.h"

#import "MediaColViewCell.h"

#define kNumberRows                 4
#define kItemWidth                  (kMainScreenWidth - kItemSpacingWidth * (kNumberRows - 1) - 30) / kNumberRows
#define kItemHeight                 kItemWidth
#define kItemSpacingWidth           5
#define kItemSpacingHeight          5

@interface MomentColViewCell ()<MediaColViewCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *m_AvatarImgView;
@property (nonatomic, strong) UILabel *m_NicknameLbl;
@property (nonatomic, strong) UITextView *m_RemarkTV;

@property (nonatomic, strong) UICollectionView *m_ColView;

@property (nonatomic, strong) MomentModel *m_Model;
@property (nonatomic, strong) NSIndexPath *m_IndexPath;
@property (nonatomic, strong) NSMutableArray<MediaModel *> *m_MediaColArray;

@end

@implementation MomentColViewCell
@synthesize m_AvatarImgView;
@synthesize m_NicknameLbl;
@synthesize m_RemarkTV;

@synthesize m_ColView;

@synthesize m_Model;
@synthesize m_IndexPath;
@synthesize m_MediaColArray;

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
    
    [self addShareContentView];
    [self addShareMediaView];
    
}

- (void)addShareContentView{
    
    UIImageView *avatarImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR
                                              withIsUserInteraction:NO];
    
    [avatarImgView setContentMode:UIViewContentModeScaleToFill];
    
    [self setM_AvatarImgView:avatarImgView];
    [self.contentView addSubview:avatarImgView];
    
    UILabel *nicknameLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                             size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [self setM_NicknameLbl:nicknameLbl];
    [self.contentView addSubview:nicknameLbl];
    
    UITextView *remarkTV = [[UITextView alloc] init];
    
    [remarkTV setEditable:NO];
    [remarkTV setScrollEnabled:NO];
    [remarkTV setTextColor:[UIColor blackColor]];
    [remarkTV setBackgroundColor:[UIColor clearColor]];
    [remarkTV setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [remarkTV setFont:FontPFRegular(CLIENT_COMMON_FONT_CONTENT_SIZE)];
    
    [self setM_RemarkTV:remarkTV];
    [self.contentView addSubview:remarkTV];
    
}

- (void)addShareMediaView{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    [layout setMinimumLineSpacing:kItemSpacingWidth];
    [layout setMinimumInteritemSpacing:kItemSpacingHeight];
    [layout setItemSize:CGSizeMake(kItemWidth, kItemHeight)];
    [layout setSectionInset:UIEdgeInsetsMake(0, 15, 10, 15)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:layout];
    
    [colView setDelegate:self];
    [colView setDataSource:self];
    [colView setBackgroundColor:[UIColor clearColor]];
    
    // UICollectionViewCell 注册 否则会报错
    [colView registerClass:[MediaColViewCell class] forCellWithReuseIdentifier:kMediaColViewCellId];
    
    [self setM_ColView:colView];
    [self.contentView addSubview:colView];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return [m_MediaColArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = [indexPath row];
    
    MediaColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMediaColViewCellId
                                                                       forIndexPath:indexPath];
    
    [cell setM_Delegate:self];
    
    MediaModel *model;
    OBJECTOFARRAYATINDEX(model, m_MediaColArray, row);
    
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

    if (IsNilOrNull(m_MediaColArray)) {
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        
        [self setM_MediaColArray:tmpArray];
        
    }
    
}

- (void)layoutUI{

    [m_AvatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).offset(15);
        make.leading.equalTo(self.contentView).offset(15);
        make.size.equalTo(CGSizeMake(46, 46));
        
    }];
   
    [m_NicknameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(m_AvatarImgView.mas_centerY);
        make.leading.equalTo(m_AvatarImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        
    }];
    
    [m_RemarkTV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(m_AvatarImgView.mas_bottom).offset(5);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.height.greaterThanOrEqualTo(@0.1);
        
    }];
   
    [m_ColView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(m_RemarkTV.mas_bottom);
        make.leading.and.trailing.equalTo(self.contentView);

    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.leading.trailing.equalTo(self);
        make.bottom.equalTo(m_ColView.mas_bottom);
        
    }];
    
}

- (void)setMomentColViewCellUpDataSource:(MomentModel *)model
                   cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!IsArrEmpty(m_MediaColArray)) [m_MediaColArray removeAllObjects];
    
    [self setM_Model:model];
    [self setM_IndexPath:indexPath];
    
    // 头像
    NSString *urlStr = model.userData.head_url;
    
    NSURL *url = [NSURL URLWithString:
                  [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [m_AvatarImgView sd_setImageWithURL:url placeholderImage:ImageNamed(PUBLIC_IMG_SYSTEM_AVATAR) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        // 圆处理
        CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:MIN(46, 46)];
        
        [m_AvatarImgView.layer setMask:shape];
  
    }];
    
    // 昵称
    [m_NicknameLbl setText:model.userData.nickname];
    
    // 分享内容
    if (!IsStrEmpty(model.remark)) {

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:5]; // 字体的行间距
        
        NSDictionary *attributes = @{NSFontAttributeName:m_RemarkTV.font,
                                     NSForegroundColorAttributeName:[UIColor grayColor],
                                     NSParagraphStyleAttributeName:paragraphStyle};
        
        [m_RemarkTV setAttributedText:[[NSAttributedString alloc] initWithString:model.remark
                                                                      attributes:attributes]];
        
    }
    
    // 分享的媒体文件
    [m_MediaColArray addObjectsFromArray:model.imgs];
    [m_ColView reloadData];
    
    // layoutUI
    [m_ColView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        double totalRow = (double)[m_MediaColArray count] / (double)kNumberRows;
        
        CGFloat height = kItemHeight * ceil(totalRow) + kItemSpacingHeight * floor(totalRow) + 10;
        
        make.height.equalTo(height);
        
    }];
    
}

#pragma mark - MediaColViewCell Delegate Methods
- (void)onDidSelectItem:(MediaModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (model.m_MediaType == MediaType_NetworkImg) {
        
        NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:[m_MediaColArray count]];
        
        [m_MediaColArray enumerateObjectsUsingBlock:^(MediaModel *obj, NSUInteger idx, BOOL *stop) {
            
            if (obj.m_MediaType == MediaType_NetworkImg) {
                
                UIImageView *imgView = [[UIImageView alloc] init];
                
                [imgView sd_setImageWithURL:[NSURL URLWithString:obj.img_url]
                           placeholderImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
                
                [imgArray addObject:imgView];
                
            }
            
        }];
        
        if (!IsArrEmpty(imgArray)) {
            
            // 1. 创建photoBroseView对象
            PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
            
            [photoBroseView setShowDuration:0.f];
            [photoBroseView setHiddenDuration:0.f];
            
            // 2.1 设置图片源(UIImageView)数组
            [photoBroseView setSourceImgageViews:imgArray];
            
            // 2.2 设置初始化图片下标（即当前点击第几张图片）
            [photoBroseView setCurrentIndex:[indexPath row]];
            // 3.显示(浏览)
            [photoBroseView show];
            
        }
        
    }
    
}

- (void)onDeleteItem:(MediaModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

@end


