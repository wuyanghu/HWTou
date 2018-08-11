//
//  PersonEditDataViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonEditDataViewController.h"
#import "PersonEditDataView.h"
#import "PublicHeader.h"
#import "PYPhotoBrowser.h"
#import "TZImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ComImageUpload.h"
#import "SelectCityViewController.h"
#import "PersonHomeReq.h"
#import "YYModel.h"
#import "MOFSPickerManager.h"

@interface PersonEditDataViewController ()<PersonEditDataViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
{
    ActionSheetTag actionSheetTag;
}
@property (nonatomic,strong) PersonEditDataView * editDataView;
@end

@implementation PersonEditDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"编辑资料"];
    
    [self.view addSubview:self.editDataView];
    [self.editDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//选择城市
- (void)selectCity{
//    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
//        NSLog(@"11");
//    } cancelBlock:^{
//
//    }];
}

- (void)saveData:(SaveUserDataParam *)saveUserDataParam{
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    if ([self.editDataView.personHomeModel.nickname isEqualToString:saveUserDataParam.nickname]) {
        //修改的昵称和返回的昵称相同就不用判断是否重复
        [self saveRequest:saveUserDataParam];
    }else{
        [PersonHomeRequest checkNickname:saveUserDataParam.nickname Success:^(BaseResponse *response) {
            [HUDProgressTool dismiss];
            if (response.status == 200) {
                [self saveRequest:saveUserDataParam];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

- (void)saveRequest:(SaveUserDataParam *)saveUserDataParam{
    [PersonHomeRequest saveUserData:saveUserDataParam Success:^(PersonHomeResponse *response) {
        [HUDProgressTool showIndicatorWithText:@"保存成功"];
        [HUDProgressTool dismiss];
        if (response.status == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool dismiss];
    }];
}

// 相册中选择
- (void)selectExistingPictureOrVideo:(NSInteger)maxNumMedia tag:(ActionSheetTag)tag{
    actionSheetTag = tag;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxNumMedia delegate:self];
    // 默认为YES，如果设置为NO,用户将不能选择视频
    [imagePickerVc setAllowPickingVideo:NO];
    // 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
    [imagePickerVc setAllowPickingOriginalPhoto:NO];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePickerVc setSortAscendingByModificationDate:NO];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        if (!IsArrEmpty(photos)) {
            if (photos.count == 1) {
                [self singleImgUploadWithParam:photos[0]];
            }else if (photos.count>1){
                [self batchImgUploadWithParam:photos];
            }
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)shootPiicturePrVideo:(ActionSheetTag)tag{
    actionSheetTag = tag;
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

//拍照
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediatypes count] > 0 ){
        //创建图像选取控制器
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        //设置图像选取控制器的来源模式为相机模式
        [imagePickerController setSourceType:sourceType];
        //设置摄像图像品质
        [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
        //设置最长摄像时间
        [imagePickerController setVideoMaximumDuration:30];
        //允许用户进行编辑
        [imagePickerController setAllowsEditing:YES];
        //设置委托对象
        [imagePickerController setDelegate:self];
        //以模式视图控制器的形式显示
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        [self showAlertController:@"当前设备不支持拍摄功能!"];
    }
}

- (void)showAlertController:(NSString *)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 获取媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断是静态图像还是视频
    if([mediaType isEqual:(NSString *)kUTTypeImage]){
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!IsNilOrNull(chosenImage)) {
            [self singleImgUploadWithParam:chosenImage];
        }
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        [self showAlertController:@"系统只支持图片格式!"];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


// 单个图片上传
- (void)singleImgUploadWithParam:(UIImage *)image{
    
//    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];

    [ComImageUpload singleWithImage:image success:^(NSString *url) {
        [HUDProgressTool dismiss];
        if (actionSheetTag == modifyImageTag) {//修改头像直接替换第一个
            [self.editDataView replaceImage:url];
        }else if (actionSheetTag == selectImageTag){
            [self.editDataView addImage:@[url]];
        }
    } failure:^(NSString *errMsg) {
        [HUDProgressTool showErrorWithText:errMsg];
    }];
}

// 图片批量上传
- (void)batchImgUploadWithParam:(NSArray<UIImage *> *)images{
//    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    [ComImageUpload batchWithImages:images success:^(NSArray<NSString *> *url) {
        [HUDProgressTool dismiss];
        [self.editDataView addImage:url];
    } failure:^(NSString *errMsg) {
        [HUDProgressTool showErrorWithText:errMsg];
    }];
}


#pragma mark - getter

- (void)setPersonHomeModel:(PersonHomeDM *)personHomeModel{
    _personHomeModel = personHomeModel;
    [self.editDataView setPersonHomeModel:personHomeModel];
}

- (PersonEditDataView *)editDataView{
    if (!_editDataView) {
        _editDataView = [[PersonEditDataView alloc] init];
        _editDataView.editDataViewDelegate = self;
    }
    return _editDataView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
