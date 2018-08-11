//
//  PersonEditDataView.m
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonEditDataView.h"
#import "PublicHeader.h"
#import "PYPhotoBrowser.h"
#import "PersonHomeReq.h"
#import "MOFSPickerManager.h"
#import "RegularExTool.h"

static NSString * identify = nil;

#define kCellIdentify0 @"CellIdentify0"
#define kCellIdentify0_1 @"CellIdentify0_1"
#define kCellIdentify1 @"CellIdentify1"
#define kCellIdentify2 @"CellIdentify2"
#define kCellIdentify2_4 @"CellIdentify2_4"
#define kCellIdentify2_0 @"CellIdentify2_0"

#define kHeaderViewIdentify @"kHeaderViewIdentify"
#define kFooterViewIdentify @"kFooterViewIdentify"


@interface PersonEditDataView()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>
@property (nonatomic, strong) SaveUserDataParam * saveUserDataParam;
@property (nonatomic, strong) UICollectionView  * collectionView;

@property (nonatomic,strong) NSMutableArray * dataArr;//collectionView数据源
@property (nonatomic,strong) NSIndexPath * indexPath;//记录点击的
@end

@implementation PersonEditDataView

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
    if (self.dataArr.count>0) {
        self.saveUserDataParam.headUrl = self.dataArr[0];
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    PersonEditNicknameCell * nicknameCell = (PersonEditNicknameCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    self.saveUserDataParam.nickname = nicknameCell.textField.text;
    
    if (![RegularExTool validateNickName:self.saveUserDataParam.nickname]) {
        NSLog(@"不合法");
        [HUDProgressTool showErrorWithText:HINTNickName];
        return;
    }
    
    NSString * bmgs = @"";
    for (int index = 0;index<self.dataArr.count;index++) {
        if (index!=0) {
            if ([bmgs isEqualToString:@""]) {
                bmgs = self.dataArr[index];
            }else{
                bmgs = [NSString stringWithFormat:@"%@,%@",bmgs,self.dataArr[index]];
            }
        }
    }
    self.saveUserDataParam.bmgs = bmgs;
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    PersonEditIntroduceCell * introduceCell = (PersonEditIntroduceCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    self.saveUserDataParam.introduce = introduceCell.textField.text;
    
    indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
    PersonEditSignCell * signCell = (PersonEditSignCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    if (![RegularExTool validateSign:signCell.textView.text]) {
//        //不合法
//        [HUDProgressTool showErrorWithText:HINTSign];
//        return;
//    }
    self.saveUserDataParam.sign = signCell.textView.text;
    
    [_editDataViewDelegate saveData:self.saveUserDataParam];
    
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArr.count+1;//1个头像+多个背景
    }else if(section == 1){
        return 0;//介绍
    }else{
        return 4;//
    }
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
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.row]]];
            if (indexPath.row == 0) {
                cell.headerImageView.hidden = NO;
            }else{
                cell.headerImageView.hidden = YES;
            }
            collectionViewCell = cell;
        }
    }else if(indexPath.section == 1){
        PersonEditIntroduceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify1 forIndexPath:indexPath];
        if (![_personHomeModel.introduce isEqualToString:@""] || _personHomeModel.introduce!=nil) {
            cell.textField.text = _personHomeModel.introduce;
        }
        collectionViewCell = cell;
    }else{
        if (indexPath.row == 0) {
            PersonEditNicknameCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify2_0 forIndexPath:indexPath];
            [cell setCellRow:indexPath.row personHomeModel:_personHomeModel];
            collectionViewCell = cell;
        }else if (indexPath.row == 1 || indexPath.row == 2) {
            PersonEditSexCityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify2 forIndexPath:indexPath];
            [cell setCellRow:indexPath.row personHomeModel:_personHomeModel];
            collectionViewCell = cell;
        }else{
            PersonEditSignCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify2_4 forIndexPath:indexPath];
            [cell setCellRow:indexPath.row personHomeModel:_personHomeModel];
            collectionViewCell = cell;
        }
        
    }
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self popSelectImageActionSheet:modifyImageTag];
        }else if(indexPath.row == self.dataArr.count){
            [self popSelectImageActionSheet:selectImageTag];
        }else{
            [self popSelectImageActionSheet:lookImageTag];
        }
    }else if (indexPath.section == 1){
        
    }else{
        if (indexPath.row == 1) {//性别
            [self popSelectImageActionSheet:sexTag];
        }else if (indexPath.row == 2){//选择城市
            [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
                
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
                PersonEditSexCityCell * introduceCell = (PersonEditSexCityCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                introduceCell.subTitleLabel.text = address;
                self.saveUserDataParam.city = address;
            } cancelBlock:^{
                
            }];
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
        case sexTag:{
            PersonEditSexCityCell * cell = (PersonEditSexCityCell *)[self.collectionView cellForItemAtIndexPath:_indexPath];
            if (buttonIndex == 0) {
                cell.subTitleLabel.text = @"男生";
                self.saveUserDataParam.sex = 1;
            }else if(buttonIndex == 1){
                cell.subTitleLabel.text = @"女生";
                self.saveUserDataParam.sex = 2;
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
    }else if(indexPath.section == 1){
        return CGSizeMake(kMainScreenWidth, 44);
    }else{
        if (indexPath.row == 3) {
            return CGSizeMake(kMainScreenWidth, 100);
        }
        return CGSizeMake(kMainScreenWidth, 44);
    }
    
}

#pragma mark - 图片增删改查逻辑

//删除
- (void)removeImage{
    [self.dataArr removeObjectAtIndex:_indexPath.row];
    [self reloadSection0];
}

//替换
- (void)replaceImage:(NSString *)url{
    if (_indexPath.row<self.dataArr.count) {
        self.dataArr[_indexPath.row] = url;
    }
    [self reloadSection0];
}
//添加
- (void)addImage:(NSArray *)urlArr{
    if (self.dataArr.count>6) {
        [HUDProgressTool showOnlyText:@"背景图不能大于6张"];
        return;
    }
    [self.dataArr addObjectsFromArray:urlArr];
    [self reloadSection0];
}

- (void)reloadSection0{
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//    PersonEditIntroduceCell * introduceCell = (PersonEditIntroduceCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    _personHomeModel.introduce = introduceCell.textField.text;
//    
//    indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
//    PersonEditNicknameCell * cell = (PersonEditNicknameCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    _personHomeModel.nickname = cell.textField.text;
//    
//    indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
//    PersonEditSexCityCell * sexCell = (PersonEditSexCityCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    _personHomeModel.sex = [_personHomeModel setSexInt:sexCell.subTitleLabel.text] ;
//    
//    indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
//    PersonEditSexCityCell * cityCell = (PersonEditSexCityCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    _personHomeModel.city = cityCell.subTitleLabel.text;
//    
//    indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
//    PersonEditSignCell * signCell = (PersonEditSignCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//    _personHomeModel.sign = signCell.textView.text;
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
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

