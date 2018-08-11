//
//  AnchorMoreFooterView.m
//  HWTou
//
//  Created by robinson on 2018/3/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnchorMoreFooterView.h"
#import "UIView+NTES.h"
#import "AnchorMoreFooterCollectionViewCell.h"

@interface AnchorMoreFooterView()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    
}
@property (nonatomic, strong) UICollectionView  * collectionView;
@property (nonatomic,strong) NSArray * anchorDataArray;
@property (nonatomic,strong) NSArray * superDataArray;
@property (nonatomic,strong) NSArray * audienceDataArray;
@property (nonatomic,strong) NSArray * audienceNoDataArray;
@property (nonatomic,assign) LiveFooterMoreType liveFooterMoreType;
@end

@implementation AnchorMoreFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (void)show:(LiveFooterMoreType)moreType
{
    _liveFooterMoreType = moreType;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop -= self.ntesHeight;
    }];
    
    CGFloat collcetionHeight = ([[self getDataArr] count]/4+1)*128;
    self.collectionView.frame = CGRectMake(0, self.ntesHeight-collcetionHeight, self.ntesWidth,collcetionHeight);
    
    [self.collectionView reloadData];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop += self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - uicollectionview

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self getDataArr] count];
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 18, 5, 18);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnchorMoreFooterCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AnchorMoreFooterCollectionViewCell cellIdentity] forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setImageTitleDict:[self getDataArr][indexPath.row] isNormal:_isAllReliseMute];
    }else{
        [cell setImageTitleDict:[self getDataArr][indexPath.row] isNormal:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    NSDictionary * dict = [self getDataArr][indexPath.row];
    NSInteger clickType = [dict[tagKey] integerValue];
    
    if (clickType == wzType) {
        [_anchorMoreDelegate anchorMoreFooterViewAction:commentType];
    }else if (clickType == tpType){
        [_anchorMoreDelegate anchorMoreFooterViewAction:commentPhotoType];
    }

    if (_liveFooterMoreType == LiveFooterMoreTypeSuper) {
        
        if (clickType == allMuteType) {
            
            if (_isAllReliseMute) {
                [_anchorMoreDelegate anchorMoreFooterViewAction:allMuteType];
            }else{
                [_anchorMoreDelegate anchorMoreFooterViewAction:allRelieveMuteType];
            }
//            _isAllReliseMute = !_isAllReliseMute;
            [collectionView reloadData];
            
        }else{
            [_anchorMoreDelegate anchorMoreFooterViewAction:stopLiveType];
        }

    }else if(_liveFooterMoreType == LiveFooterMoreTypeAnchor) {
        switch (clickType) {
            case jsType:
            {
                [_anchorMoreDelegate anchorMoreFooterViewAction:closeType];
            }
                break;
            case hbType:{
                [_anchorMoreDelegate anchorMoreFooterViewAction:redType];
            }
                break;
            default:
                break;
        }
    }else if (_liveFooterMoreType == LiveFooterMoreTypeAudience || _liveFooterMoreType == LiveFooterMoreTypeAudienceNo){
        switch (clickType) {
            case interactorType:{
                [_anchorMoreDelegate anchorMoreFooterViewAction:SuperManagerMoreTypeinteractor];
            }
                break;
            default:
                break;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.ntesWidth/4, 128);
}

#pragma mark - getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 2.5;
        flowLayout.minimumInteritemSpacing = 2.5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColorFromRGB(0xE2E2E2);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"AnchorMoreFooterCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[AnchorMoreFooterCollectionViewCell cellIdentity]];
    }
    return _collectionView;
}

- (NSArray *)getDataArr{
    if (_liveFooterMoreType == LiveFooterMoreTypeSuper) {
        return self.superDataArray;
    }else if(_liveFooterMoreType == LiveFooterMoreTypeAnchor){
        return self.anchorDataArray;
    }else if (_liveFooterMoreType == LiveFooterMoreTypeAudience){
        return self.audienceDataArray;
    }else if (_liveFooterMoreType == LiveFooterMoreTypeAudienceNo){
        return self.audienceNoDataArray;
    }
    return nil;
}

- (NSArray *)audienceNoDataArray{
    if (!_audienceNoDataArray) {
        _audienceNoDataArray = @[@{imgKey:@"tc_btn_tp",titleKey:@"图片",tagKey:@(tpType)},];
    }
    return _audienceNoDataArray;
}

- (NSArray *)audienceDataArray{
    if (!_audienceDataArray) {
        _audienceDataArray = @[@{imgKey:@"tc_btn_yy",titleKey:@"文字",tagKey:@(wzType)},
                               @{imgKey:@"tc_btn_tp",titleKey:@"图片",tagKey:@(tpType)},
                               @{imgKey:@"zb_btn_gd",titleKey:@"连麦",tagKey:@(interactorType)},
                               ];
    }
    return _audienceDataArray;
}

- (NSArray *)anchorDataArray{
    if (!_anchorDataArray) {
        _anchorDataArray = @[@{imgKey:@"tc_btn_yy",titleKey:@"文字",tagKey:@(wzType)},
                       @{imgKey:@"tc_btn_tp",titleKey:@"图片",tagKey:@(tpType)},
//                       @{imgKey:@"tc_btn_sp",titleKey:@"视频",tagKey:@(spType)},
                       @{imgKey:@"tc_btn_hb",titleKey:@"红包",tagKey:@(hbType)},
//                       @{imgKey:@"tc_btn_ht",titleKey:@"话题",tagKey:@(htType)},
                       @{imgKey:@"tc_btn_js",titleKey:@"结束直播",tagKey:@(jsType)},];
    }
    return _anchorDataArray;
}

- (NSArray *)superDataArray{
    if (!_superDataArray) {
        _superDataArray = @[
                            @{imgKey:@"tc_btn_qyjy",titleKey:@"全员禁言",selectimgKey:@"tc_btn_qyjy2",
                              selecttitleKey:@"取消禁言",tagKey:@(allMuteType)},
                            @{imgKey:@"tc_btn_tzzb",titleKey:@"停止直播",tagKey:@(stopLiveType)},
                            @{imgKey:@"tc_btn_tp",titleKey:@"图片",tagKey:@(tpType)},];
    }
    return _superDataArray;
}

@end
