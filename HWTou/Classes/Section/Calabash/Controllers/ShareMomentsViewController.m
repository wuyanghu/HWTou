//
//  ShareMomentsViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ShareMomentsViewController.h"

#import "PublicHeader.h"
#import "PYPhotoBrowser.h"
#import "TZImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "ShareMomentsView.h"

@interface ShareMomentsViewController ()<ShareMomentsViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) ShareMomentsView *m_ShareMomentsView;

@end

@implementation ShareMomentsViewController
@synthesize m_ShareMomentsView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"圈子"];
    
    [self dataInitialization];
    [self addMainView];
    
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
    
    [self addNavRightBtn];
    [self addShareMomentsView];
    
}

- (void)addNavRightBtn{
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithTitle:@"发布"
                                                 withColor:UIColorFromHex(NAVIGATION_FONT_GRAY_COLOR)
                                                    target:self
                                                    action:@selector(onNavigationCustomRightBtnClick:)];
    
    [self.navigationItem setRightBarButtonItem:item];
    
}

- (void)addShareMomentsView{
    
    ShareMomentsView *shareMomentsView = [[ShareMomentsView alloc] init];
    
    [shareMomentsView setM_Delegate:self];
    
    [self setM_ShareMomentsView:shareMomentsView];
    [self.view addSubview:shareMomentsView];
    
    [shareMomentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
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
- (void)selectExistingPictureOrVideo:(NSInteger)maxNumMedia{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxNumMedia
                                                                                            delegate:self];
    
    // 默认为YES，如果设置为NO,用户将不能选择视频
    [imagePickerVc setAllowPickingVideo:NO];
    // 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
    [imagePickerVc setAllowPickingOriginalPhoto:NO];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePickerVc setSortAscendingByModificationDate:NO];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        
        if (!IsArrEmpty(photos)) {
            
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[photos count]];
            
            [photos enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL *stop) {
                
                MediaModel *model = [[MediaModel alloc] init];
                
                [model setM_MediaType:MediaType_LocalImg];
                
                [model setM_Image:obj];
                
                [tmpArray addObject:model];
                
            }];
            
            [m_ShareMomentsView returnsMediaFile:tmpArray];
            
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
    
    if (!IsNilOrNull(m_ShareMomentsView)) {
        
        [m_ShareMomentsView shareContentCheck];
        
    }
    
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSInteger maxNumMedia = [actionSheet tag];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        switch (buttonIndex) {
            case 0:{// 拍照
                [self shootPiicturePrVideo];
                break;}
            case 1:{// 相册选取
                [self selectExistingPictureOrVideo:maxNumMedia];
                break;}
            default:{
                break;}
        }
        
    }else{
        
        switch (buttonIndex) {
            case 0:{// 拍照
                [self selectExistingPictureOrVideo:maxNumMedia];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // 获取媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断是静态图像还是视频
    if([mediaType isEqual:(NSString *)kUTTypeImage]){
        
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (!IsNilOrNull(chosenImage)) {
            
            MediaModel *model = [[MediaModel alloc] init];
            
            [model setM_MediaType:MediaType_LocalImg];
            
            [model setM_Image:chosenImage];
            
            [m_ShareMomentsView returnsMediaFile:@[model]];
            
        }
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        
        [self showAlertController:@"系统只支持图片格式!"];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - ShareMomentsView Delegate Manager
- (void)onShareMomentsSuccess{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)onChooseMediaSource:(NSInteger)maxNumMedia{
    
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
    
    [actionSheet setTag:maxNumMedia];
    [actionSheet showInView:self.view];
    
}

- (void)onPhotoBrowse:(NSArray<UIImageView *> *)imgArray currentIndex:(NSInteger)index{
    
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    
    [photoBroseView setShowDuration:0.f];
    [photoBroseView setHiddenDuration:0.f];
    
    // 2.1 设置图片源(UIImageView)数组
    [photoBroseView setSourceImgageViews:imgArray];
    
    // 2.2 设置初始化图片下标（即当前点击第几张图片）
    [photoBroseView setCurrentIndex:index];
    // 3.显示(浏览)
    [photoBroseView show];
    
}

@end
