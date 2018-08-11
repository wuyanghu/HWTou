//
//  ProductDetailView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "UITableView+FDTemplateLayoutCell.h"
#import "ProductAttributeNewView.h"
#import "ProductDetailToolView.h"
#import "ProductCommentListVC.h"
#import "ProductAttributeDM.h"
#import "ProductDetailView.h"
#import "ProductDetailCell.h"
#import "CommentListCell.h"
#import "ComCarouselView.h"
#import "ProductDetailDM.h"
#import "InterfaceDefine.h"
#import "PublicHeader.h"

typedef NS_ENUM(NSInteger, ProductCellType) {
    ProductCellBasisInfo,       // 基础信息
    ProductCellAttribute,       // 规格数量
    ProductCellCommentAll,      // 全部评论
    ProductCellComContent,      // 评论内容
    ProductCellTypeInvalid,     // 无效cell
};

@interface ProductDetailView () <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, ComCarouselViewDelegate>
{
    ProductDetailToolView   *_vBottomTool;  // 底部工具
    ComCarouselImageView    *_vPhotos;      // 商品图片
    ProductAttributeNewView *_vAttribute;   // 规格数量
    UIView                  *_vAttributeMask;
    UILabel     *_labPageNum; // 图片页数
    UIWebView   *_webView;    // 商品详情
    CGFloat      _webHeight;  // Web高度
    CGFloat      _attrHeight; // 属性选择高度
}

@property (nonatomic, strong) UIView *vHeader;
@property (nonatomic, strong) UIView *vFooter;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView  *vIndicator;

@end

@implementation ProductDetailView

static  NSString * const kCellIdBasisInfo   = @"kCellIdBasisInfo";
static  NSString * const kCellIdAttribute   = @"kCellIdAttribute";
static  NSString * const kCellIdCommentAll  = @"kCellIdCommentAll";
static  NSString * const kCellIdComContent  = @"kCellIdComContent";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self setupHeaderView];
        [self setupFooterView];
    }
    return self;
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ProductBasisInfoCell class] forCellReuseIdentifier:kCellIdBasisInfo];
    [self.tableView registerClass:[ProductDetailAttCell class] forCellReuseIdentifier:kCellIdAttribute];
    [self.tableView registerClass:[ProductCommentAllCell class] forCellReuseIdentifier:kCellIdCommentAll];
    [self.tableView registerClass:[CommentListCell class] forCellReuseIdentifier:kCellIdComContent];
    
    _vBottomTool = [[ProductDetailToolView alloc] init];
    
    [self addSubview:self.tableView];
    [self addSubview:_vBottomTool];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.bottom.equalTo(_vBottomTool.top);
    }];
    
    [_vBottomTool makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@49);
    }];
}

- (void)setupHeaderView
{
    self.vHeader = [[UIView alloc] init];
    self.vHeader.backgroundColor = UIColorFromHex(0xfafafa);
    
    _vPhotos = [[ComCarouselImageView alloc] init];
    _vPhotos.delegate = self;
    _vPhotos.autoScroll = NO;
    _vPhotos.infiniteLoop = NO;
    _vPhotos.showPageControl = NO;
    _vPhotos.contentMode = UIViewContentModeScaleToFill;
    
    _labPageNum = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x7f7f7f) size:11.0f];
    _labPageNum.textAlignment = NSTextAlignmentCenter;
    _labPageNum.backgroundColor = UIColorFromHex(0xfafafa);
    _labPageNum.layer.borderColor = UIColorFromHex(0xc4c4c4).CGColor;
    _labPageNum.layer.borderWidth = Single_Line_Width;
    [_labPageNum setRoundWithCorner:2.0f];
    
    [self.vHeader addSubview:_vPhotos];
    [self.vHeader addSubview:_labPageNum];
    
    [_vPhotos makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.vHeader);
    }];
    
    [_labPageNum makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(-10);
        make.bottom.equalTo(_vPhotos).offset(-15);
        make.size.equalTo(CGSizeMake(30, 16));
    }];
}

- (void)setupFooterView
{
    self.vFooter = [[UIView alloc] init];
    
    _webView = [[UIWebView alloc] init];
    _webView.opaque = NO; // 不设置这个值 页面背景始终是白色
    _webView.backgroundColor = UIColorFromHex(0xf4f4f4);
//    _webView.scalesPageToFit = YES; // 写了后无法正常获取高度
    _webView.scrollView.bounces = NO;
    _webView.scrollView.scrollEnabled = NO;
    _webView.delegate = self;
    
    [self.vFooter addSubview:_webView];
    
    UIView *vTopBG = [[UIView alloc] init];
    UIView *vLine1 = [[UIView alloc] init];
    UIView *vLine2 = [[UIView alloc] init];
    vLine1.backgroundColor = UIColorFromHex(0x7f7f7f);
    vLine2.backgroundColor = UIColorFromHex(0x7f7f7f);
    
    UILabel *labTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x7f7f7f) size:12.0f];
    labTitle.text = @"详情";
    
    [self.vFooter addSubview:vTopBG];
    [self.vFooter addSubview:labTitle];
    [self.vFooter addSubview:vLine1];
    [self.vFooter addSubview:vLine2];
    
    [vTopBG makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.vFooter);
        make.height.equalTo(@42);
    }];
    
    [labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(vTopBG);
    }];
    
    [vLine1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vTopBG);
        make.width.equalTo(@26);
        make.height.equalTo(Single_Line_Width);
        make.trailing.equalTo(labTitle.leading).offset(-10);
    }];
    
    [vLine2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vTopBG);
        make.width.equalTo(@26);
        make.height.equalTo(Single_Line_Width);
        make.leading.equalTo(labTitle.trailing).offset(10);
    }];
    
    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.vFooter);
        make.top.equalTo(vTopBG.bottom);
        make.height.greaterThanOrEqualTo(@1);
    }];
}

- (void)setDmProduct:(ProductDetailDM *)dmProduct
{
    _dmProduct = dmProduct;
    
    _vPhotos.imageURLStringsGroup = dmProduct.img_urls;
    if (self.dmProduct.img_urls.count > 0) {
        _labPageNum.text = [NSString stringWithFormat:@"1/%d", (int)self.dmProduct.img_urls.count];
    } else {
        _labPageNum.text = @"0/0";
    }
    
    _vBottomTool.collect = dmProduct.collected_flag;
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@?item_id=%ld", kHomeServerHost, kApiProductDetail, (long)dmProduct.item_id];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [_webView loadRequest:request];
    
    [self.tableView reloadData];
}

- (void)setDmComment:(ProductCommentDM *)dmComment
{
    _dmComment = dmComment;
    [self.tableView reloadData];
}

- (void)setCollect:(BOOL)collect
{
    _collect = collect;
    _vBottomTool.collect = collect;
}

- (void)setCartNumber:(NSInteger)cartNumber
{
    _cartNumber = cartNumber;
    _vBottomTool.cartNumber = cartNumber;
}

- (void)setDelegate:(id<ProductDetailDelegate>)delegate
{
    _vBottomTool.delegate = delegate;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dmComment == nil) { // 没有评论数据
        return ProductCellTypeInvalid - 1;
    }
    return ProductCellTypeInvalid;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == ProductCellBasisInfo) {
        return self.vHeader;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == tableView.numberOfSections - 1) {
        return self.vFooter;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case ProductCellBasisInfo:{
            ProductBasisInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdBasisInfo];
            [cell setDmProduct:self.dmProduct];
            return cell;
            break;}
        case ProductCellAttribute:{
            ProductDetailAttCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdAttribute];
            [cell setNumber:self.productNum];
            [cell setTitle:self.dmStock.value_names];
            return cell;
            break;}
        case ProductCellCommentAll:{
            ProductCommentAllCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdCommentAll];
            return cell;
            break;}
        case ProductCellComContent:{
            CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdComContent];
            [cell setDmComment:self.dmComment];
            return cell;
            break;}
    }
    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat height = 44;
//    switch (indexPath.section) {
//        case ProductCellBasisInfo:{
//            height = [tableView fd_heightForCellWithIdentifier:kCellIdBasisInfo cacheByIndexPath:indexPath configuration:^(ProductBasisInfoCell *cell) {
//                [cell setDmProduct:self.dmProduct];
//            }];
//            break;}
//        case ProductCellComContent:
//            if (self.dmComment) {
//                height = [tableView fd_heightForCellWithIdentifier:kCellIdComContent cacheByIndexPath:indexPath configuration:^(CommentListCell *cell) {
//                    [cell setDmComment:self.dmComment];
//                }];
//            } else {
//                height = 0;
//            }
//            break;
//    }
//    return height;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = CGFLOAT_MIN;
    switch (section) {
        case ProductCellBasisInfo:
            height = kMainScreenWidth * 0.8;
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = CGFLOAT_MIN;
    switch (section) {
        case ProductCellBasisInfo:
            height = Single_Line_Width;
            break;
        case ProductCellAttribute:
            height = 5;
            break;
    }
    if (section == tableView.numberOfSections - 1) {
        height = _webHeight + 42;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case ProductCellAttribute:
            [self handleProductAttribute];
            break;
        case ProductCellCommentAll:
            [self handleComment];
            break;
    }
}

- (void)handleComment
{
    ProductCommentListVC *commentVC = [[ProductCommentListVC alloc] init];
    commentVC.dmProduct = self.dmProduct;
    [self.viewController.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - ComCarouselViewDelegate
- (void)carouselView:(ComCarouselView *)view didScrollToIndex:(NSInteger)index
{
    _labPageNum.text = [NSString stringWithFormat:@"%d/%d", (int)index + 1, (int)self.dmProduct.img_urls.count];
}

- (UIActivityIndicatorView *)vIndicator
{
    if (_vIndicator == nil)
    {
        _vIndicator = [[UIActivityIndicatorView alloc] init];
        [_vIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [_webView addSubview:_vIndicator];
        
        [_vIndicator makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_webView);
        }];
    }
    
    return _vIndicator;
}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.vIndicator startAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.vIndicator stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.vIndicator stopAnimating];
    // 获取到webview的高度
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"] floatValue];
    if (_webHeight != height) {
        _webHeight = height + 5; // 留点空隙
        [self.tableView reloadData];
        
        [_webView updateConstraints:^(MASConstraintMaker *make) {
            make.height.greaterThanOrEqualTo(_webHeight);
        }];
    }
}

- (void)showProductAttribute
{
    if (self.isShowAttribute) {
        return;
    }
    self.isShowAttribute = YES;
    _vAttributeMask = [[UIView alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapMask)];
    [_vAttributeMask addGestureRecognizer:tap];
    
    _vAttribute = [[ProductAttributeNewView alloc] init];
    _vAttribute.listAttribute = self.listAttribute;
    _vAttribute.listStock = self.listStock;
    _vAttribute.startNum  = self.productNum;
    [_vAttribute setDmProduct:self.dmProduct];
    
    WeakObj(self);
    _vAttribute.blockNubmer = ^(NSInteger number) {
        selfWeak.productNum = number;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:ProductCellAttribute];
        [selfWeak.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    _vAttribute.blockAttribute = ^(ProductAttStockDM *stock, NSArray<ProductAttributeDM *> *selAtt) {
        selfWeak.dmStock = stock;
        selfWeak.selAtt = selAtt;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:ProductCellAttribute];
        [selfWeak.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [self addSubview:_vAttributeMask];
    [self addSubview:_vAttribute];
    [self bringSubviewToFront:_vBottomTool];
    
    _attrHeight = self.listAttribute.count * 80 + 230;
    
    CGFloat maxHeight = kMainScreenHeight * 0.6;
    if (_attrHeight > maxHeight) {
        _attrHeight = maxHeight;
    }
    
    [_vAttribute makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(_vBottomTool.top);
        make.height.equalTo(_attrHeight);
    }];
    
    [_vAttributeMask makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.bottom.equalTo(_vBottomTool.top);
    }];
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        _vAttributeMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        CGRect frame = _vAttribute.frame;
        frame.origin.y -= _attrHeight;
        _vAttribute.frame = frame;
    } completion:nil];
}

- (void)handleProductAttribute
{
    [self showProductAttribute];
}

- (void)actionTapMask
{
    [UIView animateWithDuration:0.25 animations:^{
        _vAttributeMask.backgroundColor = [UIColor clearColor];
        CGRect frame = _vAttribute.frame;
        frame.origin.y += _attrHeight;
        _vAttribute.frame = frame;
        
    } completion:^(BOOL finished) {
        self.isShowAttribute = NO;
        [_vAttributeMask removeFromSuperview];
        [_vAttribute removeFromSuperview];
    }];
}

@end

