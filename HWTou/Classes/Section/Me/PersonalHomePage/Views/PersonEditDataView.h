//
//  PersonEditDataView.h
//  HWTou
//  编辑资料
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonHomeDM.h"
#import "PersonTextView.h"
#import "PersonEditCell.h"

@class SaveUserDataParam;

//弹窗tag
typedef NS_ENUM(NSInteger,ActionSheetTag) {
    modifyImageTag,//修改相片  只能操作一个
    selectImageTag,//+号 可批量
    lookImageTag,//查看
    sexTag,//性别
};

@protocol PersonEditDataViewDelegate
- (void)shootPiicturePrVideo:(ActionSheetTag)tag;//拍摄
- (void)selectExistingPictureOrVideo:(NSInteger)maxNumMedia tag:(ActionSheetTag)tag;//选择照片
- (void)selectCity;//选择所在城市
- (void)saveData:(SaveUserDataParam *)saveUserDataParam;
@end

@interface PersonEditDataView : UIView

@property (nonatomic,weak) id<PersonEditDataViewDelegate> editDataViewDelegate;
@property (nonatomic,strong) PersonHomeDM * personHomeModel;

- (void)replaceImage:(NSString *)url;//替换
- (void)addImage:(NSArray *)urlArr;//添加
@end



