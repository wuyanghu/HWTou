//
//  ProductCommentCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/18.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCommentCell.h"
#import "ProductEnjoyCell.h"
#import "OrderDetailDM.h"
#import "PublicHeader.h"
#import "SZTextView.h"

#define kItemWidth              kMainScreenWidth * 0.24
#define kItemHeight             kItemWidth
#define kEdgeInsets             UIEdgeInsetsMake(10, 18, 10, 18)
#define kItemSpacingWidth       (kMainScreenWidth - kItemWidth * 3 - kEdgeInsets.left - kEdgeInsets.right) / 2
#define kItemSpacingHeight      10

#define kProductHeight          90
#define kTextViewHeight         90

@interface ProductCommentColCell : UICollectionViewCell
{
    UIImageView     *_imgvIcon;
}
@property (nonatomic, strong) UIImage *image;

@end

@implementation ProductCommentColCell

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

- (void)setImage:(UIImage *)image
{
    _imgvIcon.image = image;
}

@end

@interface ProductCommentCell () <UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate>
{
    ProductEnjoyCell    *_vProductCell;
    SZTextView          *_tvContent;
    UIButton            *_btnUpload;
    UICollectionView    *_vCollection;
}

@property (nonatomic, assign) CGFloat heightCollection;

@end

@implementation ProductCommentCell

static  NSString * const kCellIdentifier = @"CellIdentifier";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _vProductCell = [[ProductCollectCell alloc] init];
    _vProductCell.hideSeparator = YES;
    
    _tvContent = [[SZTextView alloc] init];
    _tvContent.textColor = UIColorFromHex(0x333333);
    _tvContent.font = FontPFRegular(14.0f);
    _tvContent.placeholder = @"请填写1~140字之间的评价";
    _tvContent.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumLineSpacing:kItemSpacingHeight];
    [layout setMinimumInteritemSpacing:kItemSpacingWidth];
    [layout setItemSize:CGSizeMake(kItemWidth, kItemHeight)];
    [layout setSectionInset:kEdgeInsets];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _vCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_vCollection setDelegate:self];
    [_vCollection setDataSource:self];
    [_vCollection setBackgroundColor:[UIColor clearColor]];
    [_vCollection registerClass:[ProductCommentColCell class] forCellWithReuseIdentifier:kCellIdentifier];

    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorFromHex(0xc4c4c4);
    
    [self.contentView addSubview:_vProductCell];
    [self.contentView addSubview:_tvContent];

    [self.contentView addSubview:vLine];
    [self.contentView addSubview:_vCollection];
    
    [_vProductCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(kProductHeight);
    }];
    
    [_tvContent makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(12);
        make.trailing.equalTo(-15);
        make.top.equalTo(_vProductCell.bottom);
        make.height.equalTo(kTextViewHeight);
    }];

    [_vCollection makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tvContent.bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo([self heightForCellWithImgCount:0]);
    }];
    
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15.0f);
        make.trailing.equalTo(self.contentView);
        make.top.equalTo(_vCollection.bottom);
        make.height.equalTo(Single_Line_Width);
    }];
}

- (void)setDmProduct:(OrderProductDM *)dmProduct
{
    _dmProduct = dmProduct;
    _vProductCell.orderProduct = dmProduct;
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    [_vCollection reloadData];
    
    CGFloat height = [self calculateColViewHeight:images.count];
    if (self.heightCollection != height) {
        self.heightCollection = height;
        // 重新调整高度
        [_vCollection mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
}

- (void)setContent:(NSString *)content
{
    _content = content;
    _tvContent.text = content;
}

- (CGFloat)calculateColViewHeight:(NSInteger)imgCount
{
    NSInteger count = imgCount;
    if (count == 0 || count < kImageNumMax) {
        count++;
    }
    NSInteger rowTotal = count/kNumberRows;
    if (count % kNumberRows) {
        rowTotal += 1;
    }
    CGFloat height = kItemHeight * rowTotal + kItemSpacingHeight * rowTotal + kEdgeInsets.top + kEdgeInsets.bottom;
    return height;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (self.images.count < kImageNumMax) {
        return self.images.count + 1;
    }
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCommentColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if ([self isUploadRow:indexPath]) {
        [cell setImage:[UIImage imageNamed:CALABASH_UPLOAD_PICTURES_BTN_NOR]];
    } else {
        [cell setImage:self.images[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isUploadRow:indexPath]) {
        // 点击的是上传按钮
        if ([self.delegate respondsToSelector:@selector(cellCommentActionUpload:)]) {
            [self.delegate cellCommentActionUpload:self];
        }
    } else {
        // 点击其他图片
        if ([self.delegate respondsToSelector:@selector(cellComment:didSelectIndex:)]) {
            [self.delegate cellComment:self didSelectIndex:indexPath.row];
        }
    }
}

- (BOOL)isUploadRow:(NSIndexPath *)indexPath
{
    NSInteger count = self.images.count;
    if (count == 0) {
        return YES;
    }
    if (count < kImageNumMax && indexPath.row == count) {
        return YES;
    }
    return NO;
}

- (CGFloat)heightForCellWithImgCount:(NSInteger)imgCount
{
    // 内部计算高度
    CGFloat height = kProductHeight + kTextViewHeight + [self calculateColViewHeight:imgCount] + Single_Line_Width;
    return height;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(cellComment:contentChange:)]) {
        [self.delegate cellComment:self contentChange:textView.text];
    }
}
@end
