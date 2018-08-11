//
//  PersonalInfoViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonalInfoViewController.h"

#import "PublicHeader.h"
#import "TZImagePickerController.h"
#import "VerifyPwdViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PersonalInfoViewController ()<PersonalInfoViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) PersonalInfoView *m_PersonalInfoView;

@end

@implementation PersonalInfoViewController
@synthesize m_PersonalInfoView;

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setTitle:@"个人信息"];
        
        [self dataInitialization];
        [self addMainView];
        
    }
    
    return self;
    
}

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addNaviRightBtn];
    [self addPersonalInfoView];
    
}

- (void)addNaviRightBtn{
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithTitle:@"保存"
                                                 withColor:[UIColor blackColor]
                                                    target:self
                                                    action:@selector(onNavigationCustomRightBtnClick:)];
    
    [self.navigationItem setRightBarButtonItem:item];
    
}

- (void)addPersonalInfoView{
    
    PersonalInfoView *personalInfoView = [[PersonalInfoView alloc] init];
    
    [personalInfoView setM_Delegate:self];
    
    [self setM_PersonalInfoView:personalInfoView];
    [self.view addSubview:personalInfoView];
    
    [personalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)setPersonalInfo:(PersonalInfoDM *)model{

    [m_PersonalInfoView setPersonalInfo:model];
    
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

// 拍照
- (void)shootPiicturePrVideo{
    
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    
}

// 相册中选择
- (void)selectExistingPictureOrVideo{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1
                                                                                            delegate:self];
    
    // 默认为YES，如果设置为NO,用户将不能选择视频
    [imagePickerVc setAllowPickingVideo:NO];
    // 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
    [imagePickerVc setAllowPickingOriginalPhoto:NO];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePickerVc setSortAscendingByModificationDate:NO];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        
        if (!IsArrEmpty(photos)) {

            [m_PersonalInfoView returnsMedia:photos[0]];
            
        }
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

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

#pragma mark - Button Handlers
- (void)onNavigationCustomRightBtnClick:(id)sender{
    
    [m_PersonalInfoView modifyPersonalInfo];
    
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        switch (buttonIndex) {
            case 0:{// 拍照
                [self shootPiicturePrVideo];
                break;}
            case 1:{// 相册选取
                [self selectExistingPictureOrVideo];
                break;}
            default:{
                break;}
        }
        
    }else{
        
        switch (buttonIndex) {
            case 0:{// 拍照
                [self selectExistingPictureOrVideo];
                break;}
            default:{
                break;}
        }
        
    }
    
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // 获取媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断是静态图像还是视频
    if([mediaType isEqual:(NSString *)kUTTypeImage]){
        
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (!IsNilOrNull(chosenImage)) {
            
            [m_PersonalInfoView returnsMedia:chosenImage];
            
        }
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        
        [self showAlertController:@"系统只支持图片格式!"];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - PersonalInfoView Delegate Methods
- (void)onModifyPhone:(NSString *)phone{

    VerifyPwdViewController *verifyCodeVC = [[VerifyPwdViewController alloc] init];
    
    [self.navigationController pushViewController:verifyCodeVC animated:YES];
    
}

- (void)onSelMediaResource{

    UIActionSheet *actionSheet;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        
    }else{
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"从手机相册选择", nil];
        
    }
    
    [actionSheet showInView:self.view];
    
}

@end
