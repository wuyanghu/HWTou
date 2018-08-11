//
//  ProductCommentView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TZPhotoPreviewController.h"
#import "TZImagePickerController.h"
#import "ProductCommentView.h"
#import "ProductCommentCell.h"
#import "ProductCommentReq.h"
#import "ComImageUpload.h"
#import "OrderDetailDM.h"
#import "PublicHeader.h"

@interface ProductCommentView () <UITableViewDataSource, UITableViewDelegate, ProductCommentDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton    *btnComment;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *imgAsset;   // PHAsset数据
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *imgSelect;  // 已选择的图片
@property (nonatomic, strong) NSMutableArray<NSString *>       *contents;   // 评论内容

@end

@implementation ProductCommentView

static  NSString * const kCellIdentifier = @"CellIdentifier";

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
    self.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ProductCommentCell class] forCellReuseIdentifier:kCellIdentifier];
    
    self.btnComment = [[UIButton alloc] init];
    self.btnComment.titleLabel.font = FontPFRegular(16.0f);
    [self.btnComment setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xb4292d)] forState:UIControlStateNormal];
    [self.btnComment setTitle:@"评价" forState:UIControlStateNormal];
    [self.btnComment addTarget:self action:@selector(actionComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.tableView];
    [self addSubview:self.btnComment];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.bottom.equalTo(self.btnComment.top);
    }];
    
    [self.btnComment makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@44);
    }];
}

- (void)setListData:(NSArray *)listData
{
    _listData = listData;
    
    self.imgSelect = [NSMutableArray arrayWithCapacity:listData.count];
    self.imgAsset  = [NSMutableArray arrayWithCapacity:listData.count];
    self.contents  = [NSMutableArray arrayWithCapacity:listData.count];
    // 填充默认数据
    for (NSInteger index = 0; index < listData.count; index++) {
        NSMutableArray *images = [NSMutableArray array];
        NSMutableArray *asset = [NSMutableArray array];
        [self.imgSelect addObject:images];
        [self.imgAsset addObject:asset];
        [self.contents addObject:@""];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setDelegate:self];
    
    NSMutableArray *images;
    OBJECTOFARRAYATINDEX(images, self.imgSelect, indexPath.row);
    
    NSString *content;
    OBJECTOFARRAYATINDEX(content, self.contents, indexPath.row);
    
    [cell setImages:images];
    [cell setContent:content];
    [cell setDmProduct:self.listData[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *images;
    OBJECTOFARRAYATINDEX(images, self.imgSelect, indexPath.row);
    ProductCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    CGFloat height = [cell heightForCellWithImgCount:images.count];
    return height;
}

#pragma mark - ProductCommentDelegate
- (void)cellCommentActionUpload:(ProductCommentCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableArray *images;
    OBJECTOFARRAYATINDEX(images, self.imgSelect, indexPath.row);
    [self pickerImageWithTabIndex:indexPath maxNum:kImageNumMax - images.count];
}

- (void)cellComment:(ProductCommentCell *)cell didSelectIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self previewPhotoWithTabIndex:indexPath imgIndex:index];
}

- (void)cellComment:(ProductCommentCell *)cell contentChange:(NSString *)content
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (content) {
        REPLACEOBJECTATINDEX(content, self.contents, indexPath.row);
    }
}

#pragma mark - 图片选择处理
- (void)previewPhotoWithTabIndex:(NSIndexPath *)indexPath imgIndex:(NSInteger)index
{
    NSMutableArray *images;
    OBJECTOFARRAYATINDEX(images, self.imgSelect, indexPath.row);
    
    NSMutableArray *imgAsset;
    OBJECTOFARRAYATINDEX(imgAsset, self.imgAsset, indexPath.row);
    TZImagePickerController *imageVC = [[TZImagePickerController alloc] initWithSelectedAssets:imgAsset selectedPhotos:images index:index];
    imageVC.maxImagesCount = kImageNumMax;
    
    WeakObj(self);
    [imageVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        [images removeAllObjects];
        [imgAsset removeAllObjects];
        [selfWeak handleSelectWithTabIndex:indexPath photos:photos assets:assets];
    }];
    [self.viewController presentViewController:imageVC animated:YES completion:nil];
}

// 相册中选择
- (void)pickerImageWithTabIndex:(NSIndexPath *)indexPath maxNum:(NSInteger)maxNum
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxNum delegate:nil];
    // 默认为YES，如果设置为NO,用户将不能选择视频
    [imagePickerVc setAllowPickingVideo:NO];
    // 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
    [imagePickerVc setAllowPickingOriginalPhoto:NO];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePickerVc setSortAscendingByModificationDate:NO];
    
    WeakObj(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        [selfWeak handleSelectWithTabIndex:indexPath photos:photos assets:assets];
    }];
    
    [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)handleSelectWithTabIndex:(NSIndexPath *)indexPath photos:(NSArray *)photos assets:(NSArray *)assets
{
    NSMutableArray *images;
    OBJECTOFARRAYATINDEX(images, self.imgSelect, indexPath.row);
    
    NSMutableArray *imgAsset;
    OBJECTOFARRAYATINDEX(imgAsset, self.imgAsset, indexPath.row);
    
    [images addObjectsFromArray:photos];
    [imgAsset addObjectsFromArray:assets];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)actionComment
{
    __block BOOL isVaild = YES;
    [self.contents enumerateObjectsUsingBlock:^(NSString *content, NSUInteger idx, BOOL *stop) {
        if (IsStrEmpty(content)) {
            [HUDProgressTool showOnlyText:@"写点评价内容吧"];
            isVaild = NO;
            *stop = YES;
        } else if (content.length > 140) {
            [HUDProgressTool showOnlyText:@"评价内容超过140字"];
            isVaild = NO;
            *stop = YES;
        }
    }];
    
    if (isVaild) {
        NSMutableArray *totalImages = [NSMutableArray arrayWithCapacity:self.imgSelect.count];
        [self.imgSelect enumerateObjectsUsingBlock:^(NSMutableArray *obj, NSUInteger idx, BOOL *stop) {
            [totalImages addObjectsFromArray:obj];
        }];
        if (totalImages.count > 0) {
            // 先上传图片
            [HUDProgressTool showIndicatorWithText:nil];
            [ComImageUpload batchWithImages:totalImages success:^(NSArray<NSString *> *url) {
                [self submitComment:url];
            } failure:^(NSString *errMsg) {
                [HUDProgressTool showOnlyText:errMsg];
            }];
        } else {
            [self submitComment:nil];
        }
    }
}

- (void)submitComment:(NSArray<NSString *>*)urls
{
    [HUDProgressTool showIndicatorWithText:nil];
    CommentBatchParam *param = [[CommentBatchParam alloc] init];
    
    // 取图片数组索引偏移
    __block NSUInteger idxOffset = 0;
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:self.contents.count];
    [self.contents enumerateObjectsUsingBlock:^(NSString *content, NSUInteger idx, BOOL *stop) {
        
        OrderProductDM *dmProduct;
        OBJECTOFARRAYATINDEX(dmProduct, self.listData, idx);
        
        NSMutableArray *images;
        OBJECTOFARRAYATINDEX(images, self.imgSelect, idx);
        
        NSArray *img_urls;
        if (urls.count >= (idxOffset + images.count)) {
            img_urls = [urls subarrayWithRange:NSMakeRange(idxOffset, images.count)];
            idxOffset += images.count;
        }
        
        CommentSubmitParam *param = [CommentSubmitParam new];
        param.content = content;
        param.img_urls = img_urls;
        param.order_id = dmProduct.order_id;
        
        [comments addObject:param];
    }];
    
    param.mpid = self.mpid;
    param.commets = comments;
    
    [ProductCommentReq batchWithParam:param success:^(BaseResponse *response) {
        if (response.success) {
            [HUDProgressTool showOnlyText:@"评价成功"];
            [self.viewController.navigationController popViewControllerAnimated:YES];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}
@end
