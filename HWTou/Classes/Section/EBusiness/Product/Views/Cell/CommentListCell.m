//
//  CommentListCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCommentDM.h"
#import "CommentListCell.h"
#import "PublicHeader.h"

#define kImageNumMax            6
#define kNumberRows             4

#define kItemWidth              kMainScreenWidth * 0.2
#define kItemHeight             kItemWidth
#define kItemSpacingWidth       kMainScreenWidth * 0.04
#define kItemSpacingHeight      5
#define kItemEdegSpacingH       10

static  NSString * const kCellIdentifier = @"CellIdentifier";

@interface CommentListColCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imgUrl;

@end

@interface CommentListCell () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
@protected
    UIImageView     *_imgvHeader;
    UILabel         *_labName;
    UILabel         *_labTime;
    UILabel         *_labContent;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation CommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        [self setupCollectionView];
    }
    return self;
}

- (void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _imgvHeader = [[UIImageView alloc] init];
    _labName = [self createLabel];
    _labTime = [self createLabel];
    _labContent = [self createLabel];
    _labContent.numberOfLines = 0;
    _labContent.font = FontPFRegular(14.0f);
    _labTime.textColor = UIColorFromHex(0x7f7f7f);
    
    [self.contentView addSubview:_imgvHeader];
    [self.contentView addSubview:_labName];
    [self.contentView addSubview:_labTime];
    [self.contentView addSubview:_labContent];
    
    [_imgvHeader makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.trailing).multipliedBy(0.04);
        make.top.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(CoordXSizeScale(36), CoordXSizeScale(36)));
        [_imgvHeader setRoundWithCorner:CoordXSizeScale(18)];
    }];
    
    [_labName makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvHeader.trailing).offset(15);
        make.centerY.equalTo(_imgvHeader);
    }];
    
    [_labTime makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgvHeader);
        make.trailing.equalTo(self.contentView).offset(-CoordXSizeScale(16));
    }];
    
    [_labContent makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvHeader);
        make.trailing.lessThanOrEqualTo(_labTime);
        make.top.equalTo(_imgvHeader.bottom).offset(CoordXSizeScale(15));
    }];
}

- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    // autoLayout提前计算需要设置最大宽度，不然会有约束冲突
    label.preferredMaxLayoutWidth = kMainScreenWidth;
    label.textColor = UIColorFromHex(0x333333);
    label.font = FontPFRegular(12);
    return label;
}

- (void)setDmComment:(ProductCommentDM *)dmComment
{
    _dmComment = dmComment;
    _labName.text = dmComment.nickname;
    _labTime.text = dmComment.create_time;
    _labContent.text = dmComment.content;
    [_imgvHeader sd_setImageWithURL:[NSURL URLWithString:dmComment.head_url]];
    
    [self.collectionView updateConstraints:^(MASConstraintMaker *make) {
        
        NSInteger count = self.dmComment.imgs.count;
        NSInteger row = count/kNumberRows;
        if (count % kNumberRows) {
            row++;
        }
        CGFloat height = kItemHeight * row + kItemEdegSpacingH * 2 + kItemSpacingHeight * (row - 1);
        make.height.equalTo(height);
    }];
    [self.collectionView reloadData];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setMinimumLineSpacing:kItemSpacingHeight];
    [layout setMinimumInteritemSpacing:kItemSpacingWidth];
    [layout setItemSize:CGSizeMake(kItemWidth, kItemHeight)];
    [layout setSectionInset:UIEdgeInsetsMake(kItemEdegSpacingH, kItemSpacingWidth, kItemEdegSpacingH, kItemSpacingWidth)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                   collectionViewLayout:layout];
    [colView setScrollEnabled:NO];
    [colView setDelegate:self];
    [colView setDataSource:self];
    [colView setBackgroundColor:[UIColor clearColor]];
    
    [colView registerClass:[CommentListColCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.contentView addSubview:colView];
    
    self.collectionView = colView;
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labContent.bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.greaterThanOrEqualTo(@0.1);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dmComment.imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommentListColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                       forIndexPath:indexPath];
    CommentImageDM *dmImage = self.dmComment.imgs[indexPath.row];
    [cell setImgUrl:dmImage.img_url];
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end

@interface CommentListColCell ()
{
    UIImageView     *_imgvIcon;
}
@end

@implementation CommentListColCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _imgvIcon = [[UIImageView alloc] init];
    [self addSubview:_imgvIcon];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

@end
