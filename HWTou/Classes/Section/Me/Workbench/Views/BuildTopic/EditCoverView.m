//
//  EditCoverView.m
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "EditCoverView.h"
#import "PublicHeader.h"
#import "PYPhotoBrowser.h"
#import "PersonHomeReq.h"
#import "MOFSPickerManager.h"

static NSString * identify = nil;

#define kCellIdentify0 @"CellIdentify0"
#define kCellIdentify0_1 @"CellIdentify0_1"
#define kCellIdentify1 @"CellIdentify1"
#define kCellIdentify2 @"CellIdentify2"
#define kCellIdentify2_4 @"CellIdentify2_4"
#define kCellIdentify2_0 @"CellIdentify2_0"

#define kHeaderViewIdentify @"kHeaderViewIdentify"
#define kFooterViewIdentify @"kFooterViewIdentify"


@interface EditCoverView()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>
@property (nonatomic, strong) SaveUserDataParam * saveUserDataParam;
@property (nonatomic, strong) UICollectionView  * collectionView;

@property (nonatomic,strong) NSIndexPath * indexPath;//记录点击的
@end

@implementation EditCoverView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.collectionView];

    UIButton * saveBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:UIColorFromHex(0xff4d49)];
    [self addSubview:saveBtn];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-60);
    }];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self);
        make.top.equalTo(self.collectionView.mas_bottom).offset(20);
        make.height.equalTo(40);
    }];
}

- (void)buttonSelected:(UIButton *)button{

    if (self.dataArr.count>6) {
        [HUDProgressTool showOnlyText:@"背景图不能超过6张"];
    }else{
        [_editDataViewDelegate saveData:self.saveUserDataParam];
    }
    
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count+1;
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        return CGSizeMake(kMainScreenWidth, 20);
    }
    return CGSizeZero;
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify forIndexPath:indexPath];
    }
    if (kind == UICollectionElementKindSectionFooter){
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify forIndexPath:indexPath];
    }
    return reusableView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(5, 18, 5, 18);
    }else{
        return UIEdgeInsetsZero;
    }
} 

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    identify = [NSString stringWithFormat:@"%ld,%ld",indexPath.section,indexPath.row];
    UICollectionViewCell * collectionViewCell;
    if (indexPath.section == 0) {
        if (indexPath.row == self.dataArr.count) {
            //最后一个
            PersonEditDataAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify0_1 forIndexPath:indexPath];
            collectionViewCell = cell;
        }else{
            PersonEditImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify0 forIndexPath:indexPath];
            cell.headerImageView.hidden = YES;
            [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
            [cell.imageView.layer setMasksToBounds:YES];
            cell.imageView.image = self.dataArr[indexPath.row];
            collectionViewCell = cell;
        }
    }
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (indexPath.section == 0) {
        if(indexPath.row == self.dataArr.count){
            [self popSelectImageActionSheet:selectImageTag];
        }else{
            [self popSelectImageActionSheet:lookImageTag];
        }
    }
}

#pragma mark - 图片处理逻辑，放大，删除，替换

//弹出选择框
- (void)popSelectImageActionSheet:(ActionSheetTag)tag{
    UIActionSheet * actionSheet;
    if (tag == selectImageTag || tag == modifyImageTag) {
        //是否支持拍摄
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            
        }else{
            
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"从手机相册选择", nil];
            
        }
    }else if(tag == lookImageTag){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"查看大图",@"替换图片",@"删除图片", nil];
    }else if(tag == sexTag){
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"男生",@"女生", nil];
    }
    actionSheet.tag = tag;
    [actionSheet showInView:self];
}

- (void)lookBigPict:(NSArray *)imgArray index:(NSInteger)index{
    if (!IsArrEmpty(imgArray)) {
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
        [photoBroseView setShowDuration:0.f];
        [photoBroseView setHiddenDuration:0.f];
        
        [photoBroseView setSourceImgageViews:imgArray];// 2.1 设置图片源(UIImageView)数组
        [photoBroseView setCurrentIndex:index];// 2.2 设置初始化图片下标（即当前点击第几张图片）
        [photoBroseView show];// 3.显示(浏览)
        
    }
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag) {
        case lookImageTag:
        {
            if (buttonIndex == 0) {
                BaseCollectViewCell * cell = (BaseCollectViewCell *)[self.collectionView cellForItemAtIndexPath:_indexPath];
                [self lookBigPict:@[cell.imageView] index:0];
            }else if (buttonIndex == 1){
                [self popSelectImageActionSheet:modifyImageTag];
            }else if (buttonIndex == 2){
                [self removeImage];
            }
            
        }
            break;
        case selectImageTag:
        case modifyImageTag:
        {
            NSInteger selectImageIndex;
            if (actionSheet.tag == modifyImageTag) {
                selectImageIndex = 1;//替换只能一张
            }else{
                selectImageIndex = 6-(self.dataArr.count-1);//总共只能选六张
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                if (buttonIndex == 0) {
                    [_editDataViewDelegate shootPiicturePrVideo:actionSheet.tag];// 拍照
                }else if (buttonIndex == 1){
                    [_editDataViewDelegate selectExistingPictureOrVideo:selectImageIndex tag:actionSheet.tag];// 相册选取
                }
            }else{
                if (buttonIndex == 0) {
                    [_editDataViewDelegate selectExistingPictureOrVideo:selectImageIndex tag:actionSheet.tag];// 拍照
                }
            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(100, 100);
    }
    return CGSizeZero;
    
}

#pragma mark - 图片增删改查逻辑

//删除
- (void)removeImage{
    [self.dataArr removeObjectAtIndex:_indexPath.row];
    [self.collectionView reloadData];
}

//替换
- (void)replaceImage:(UIImage *)image{
    if (_indexPath.row<self.dataArr.count) {
        self.dataArr[_indexPath.row] = image;
    }
    [self.collectionView reloadData];
}
//添加
- (void)addImage:(NSArray *)urlArr{
    [self.dataArr addObjectsFromArray:urlArr];
    [self.collectionView reloadData];
}

#pragma mark - getter

- (SaveUserDataParam *)saveUserDataParam{
    if (!_saveUserDataParam) {
        _saveUserDataParam = [SaveUserDataParam new];
        _saveUserDataParam.token = [[AccountManager shared] account].token;
        _saveUserDataParam.sex = _personHomeModel.sex;
        _saveUserDataParam.city = _personHomeModel.city;
    }
    return _saveUserDataParam;
}

- (void)setPersonHomeModel:(PersonHomeDM *)personHomeModel{
    if (personHomeModel) {
        _personHomeModel = personHomeModel;
        [self.dataArr removeAllObjects];
        
        [self.dataArr addObject:personHomeModel.headUrl];//添加头像
        if (![personHomeModel.bmgs isEqualToString:@""]) {
            NSArray * array = [personHomeModel.bmgs componentsSeparatedByString:@","];
            [self.dataArr addObjectsFromArray:array];
        }
        [self.collectionView reloadData];
    }
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeMake(kMainScreenWidth, 20);
        flowLayout.footerReferenceSize = CGSizeMake(kMainScreenWidth, 0);
        flowLayout.minimumLineSpacing = 2.5;
        flowLayout.minimumInteritemSpacing = 2.5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PersonEditImgCell class] forCellWithReuseIdentifier:kCellIdentify0];
        [_collectionView registerClass:[PersonEditDataAddCell class] forCellWithReuseIdentifier:kCellIdentify0_1];
        [_collectionView registerClass:[PersonEditIntroduceCell class] forCellWithReuseIdentifier:kCellIdentify1];
        [_collectionView registerClass:[PersonEditSexCityCell class] forCellWithReuseIdentifier:kCellIdentify2];
        [_collectionView registerClass:[PersonEditSignCell class] forCellWithReuseIdentifier:kCellIdentify2_4];
        [_collectionView registerClass:[PersonEditNicknameCell class] forCellWithReuseIdentifier:kCellIdentify2_0];
        [_collectionView registerClass:[PersonCollectViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentify];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify];
    }
    return _collectionView;
}

@end

