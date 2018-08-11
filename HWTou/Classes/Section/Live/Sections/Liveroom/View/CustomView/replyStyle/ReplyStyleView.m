//
//  ReplyStyleView.m
//  HWTou
//
//  Created by Reyna on 2018/1/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ReplyStyleView.h"
#import "SZTextView.h"
#import "PublicHeader.h"
#import "TZImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TZImageManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "InputLocationSelectViewController.h"
#import "ReplyRecordBtn.h"
#import "VoiceUpload.h"
#import "ComImageUpload.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ReplyStyleView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate, InputLocationSelectDelegate, ReplyRecordBtnDelegate, UITextViewDelegate>
{
    AMapLocationManager *_locationManager;
    
    double _lat;
    double _lng;
    
    int _replyFlag;
}
//UI组件
@property (nonatomic, strong) SZTextView *inputTextView;//文字输入textView
@property (nonatomic, strong) UIView *detailBGView;//底部展示区

@property (nonatomic, strong) UIView *imgDetailView;//图片控制View
@property (nonatomic, strong) UIView *videoDetailView;//视频控制View
@property (nonatomic, strong) UIView *voiceDetailView;//声音控制View
@property (nonatomic, strong) UIView *locationDetailView;//位置控制View
@property (nonatomic, strong) UIScrollView *imgsBGScrollView;//贴图滚动SV
@property (nonatomic, strong) UIView *videoBGView;//视频贴图V
@property (nonatomic, strong) UIButton *locationNameBtn;//位置名称按钮
@property (nonatomic, strong) ReplyRecordBtn *recordBtn;//录音按钮

//数据对象
@property (nonatomic, assign) NSInteger selectedIndex;//选中的索引
@property (nonatomic, strong) NSMutableArray *btnsItemArr;//选项按钮数组
@property (nonatomic, strong) NSMutableArray *selectImagesIVArr;//选中图片的IV数组
@property (nonatomic, strong) NSMutableArray *selectImagesArr;//选中的图片数组
@property (nonatomic, strong) NSString *selectVideoPath;//选中的视频路径
@property (nonatomic, strong) NSString *selectPOIName;//选中的地理位置名


@end

@implementation ReplyStyleView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _selectedIndex = -1;
    _replyFlag = 0;
    
    self.backgroundColor = [UIColor whiteColor];
    [self initHeaderSectionView];
    [self initInputView];
    [self initToolSectionView];
    [self getLocation];
}

- (void)initHeaderSectionView {
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    headerSectionView.backgroundColor = [UIColor whiteColor];
    headerSectionView.layer.borderWidth = 0.5f;
    headerSectionView.layer.borderColor = [UIColorFromHex(0xdbd6d6) CGColor];
    [self addSubview:headerSectionView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(10, 0, 80, 44);
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromHex(0x8e8f91) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerSectionView addSubview:cancelBtn];
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pushBtn.frame = CGRectMake(self.bounds.size.width - 90, 0, 80, 44);
    pushBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [pushBtn setTitle:@"发布" forState:UIControlStateNormal];
    [pushBtn setTitleColor:UIColorFromHex(0xff6767) forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(publishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerSectionView addSubview:pushBtn];
}

- (void)initToolSectionView {
    UIView *toolSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + 110, self.bounds.size.width, 50)];
    toolSectionView.backgroundColor = [UIColor whiteColor];
    toolSectionView.layer.borderWidth = 0.5f;
    toolSectionView.layer.borderColor = [UIColorFromHex(0xdbd6d6) CGColor];
    [self addSubview:toolSectionView];
    
    NSArray *imgArr = [NSArray arrayWithObjects:@"input_yy", @"input_camera", @"input_shot", @"input_location", nil];
    NSArray *downImgArr = [NSArray arrayWithObjects:@"input_yy_down", @"input_camera_down", @"input_shot_down", @"input_location_down", nil];
    [self.btnsItemArr removeAllObjects];
    for (int i=0; i<imgArr.count; i++) {
        UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnDis = (self.bounds.size.width - 50 * imgArr.count)/(imgArr.count + 1);
        toolBtn.frame = CGRectMake((btnDis + 50)*i + btnDis, 0, 50, 50);
        [toolBtn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [toolBtn setImage:[UIImage imageNamed:downImgArr[i]] forState:UIControlStateSelected];
        toolBtn.tag = 100 + i;
        [toolBtn addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolSectionView addSubview:toolBtn];
        
        [_btnsItemArr addObject:toolBtn];
    }
}

- (void)initInputView {
//    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, 148)];
//    inputView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:inputView];

    [self addSubview:self.inputTextView];
}

#pragma mark - Location

- (void)getLocation {
    
    _locationManager = [[AMapLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    _locationManager.locationTimeout = 2;
    _locationManager.reGeocodeTimeout = 2;
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        if (regeocode)
        {
            _lat = location.coordinate.latitude;
            _lng = location.coordinate.longitude;
            
//            NSString *POIName = [NSString stringWithFormat:@"%@",regeocode.POIName];
//            self.selectPOIName = POIName;
//            [self updatePOIName:POIName];
        }
    }];
}

#pragma mark - Api

- (void)resignEditing:(BOOL)isEditing {
    
    if (isEditing) {
        [self.inputTextView becomeFirstResponder];
    }
    else {
        [self.inputTextView resignFirstResponder];
    }
}

#pragma mark - Sup

- (void)returnImagesSelectedFile:(NSArray *)imagesArr {
    
    NSInteger startLocation = self.selectImagesArr.count;
    
    for (int i=0; i<imagesArr.count; i++) {
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake((startLocation + i) * 100 + 10, 0, 100, 100)];
        [self.imgsBGScrollView addSubview:bg];
        [self.selectImagesIVArr addObject:bg];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[imagesArr objectAtIndex:i]];
        iv.frame = CGRectMake(10, 10, 80, 80);
        [bg addSubview:iv];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(80, 0, 20, 20);
        [btn setImage:[UIImage imageNamed:@"sc_delete_btn"] forState:UIControlStateNormal];
        btn.tag = 1000 + startLocation + i;
        [btn addTarget:self action:@selector(imgDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btn];
    }
    
    self.imgsBGScrollView.contentSize = CGSizeMake(20 + 100*self.selectImagesIVArr.count, 100);
}

- (void)updatePOIName:(NSString *)poiName {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.locationNameBtn setTitle:poiName forState:UIControlStateNormal];
        CGRect rect = [poiName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                              context:nil];
        self.locationNameBtn.frame = CGRectMake(15, 15, rect.size.width + 20, 30);
    });
}

- (void)removeImagesData {
    
    for (int i=0; i<self.selectImagesIVArr.count; i++) {
        UIView *iv = [self.selectImagesIVArr objectAtIndex:i];
        [iv removeFromSuperview];
    }
    [self.selectImagesIVArr removeAllObjects];
    [self.selectImagesArr removeAllObjects];
}

- (void)removeVideoData {
    
    for (UIView *deleteIV in self.videoBGView.subviews) {
        [deleteIV removeFromSuperview];
    }
    self.selectVideoPath = @"";
}

- (void)resetInputView {
    
    [self getLocation];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.selectedIndex = -1;
        self.inputTextView.text = @"";
        [self removeImagesData];
        [self removeVideoData];
    });
}

#pragma mark - Action

- (void)cancelBtnAction {
    
    if (self.defaultModel) {
        self.model = self.defaultModel;
    }
    [self resignEditing:NO];
    if (self.replyStyleViewDelegate) {
        [self.replyStyleViewDelegate cancelBtnAction];
    }
}

- (void)publishBtnAction {
    [self resignEditing:NO];
    if (self.replyStyleViewDelegate) {
        
        if (_replyFlag == 1) {
            //语音路径
            
            [self.replyStyleViewDelegate publishBtnAction:@"" location:self.selectPOIName data:@"语音路径" replyFlag:1 commentModel:_model];
            [self resetInputView];
            [self cancelBtnAction];
        }
        else if (_replyFlag == 2) {
            if (self.replyStyleViewDelegate) {
                [self.replyStyleViewDelegate imageAction:self.selectImagesArr];
            }
            [self resetInputView];
            [self cancelBtnAction];
            //self.selectImagesArr
//            [HUDProgressTool showIndicatorWithText:@"上传中..."];
//            [ComImageUpload batchWithImages:self.selectImagesArr success:^(NSArray<NSString *> *url) {
//
//                NSString *bmgs = @"";
//                for (int i=0; i<url.count; i++) {
//                    if (i == 0) {
//                        NSString *us = url[i];
//                        bmgs = [bmgs stringByAppendingString:us];
//                    }
//                    else {
//                        NSString *us = [NSString stringWithFormat:@",%@",url[i]];
//                        bmgs = [bmgs stringByAppendingString:us];
//                    }
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [HUDProgressTool dismiss];
//                    [self.replyStyleViewDelegate publishBtnAction:self.inputTextView.text location:self.selectPOIName data:bmgs replyFlag:2 commentModel:_model];
//                    [self resetInputView];
//                    [self cancelBtnAction];
//                });
//            } failure:^(NSString *errMsg) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [HUDProgressTool showOnlyText:errMsg];
//                });
//            }];
            
        }
        else if (_replyFlag == 3) {
            
            NSData *data = [NSData dataWithContentsOfFile:self.selectVideoPath];
            [VoiceUpload uploadVideoWithVideoPath:self.selectVideoPath title:@"评论视频" tags:@"mp4" videoSize:data.length lat:0 lng:0 successHandle:^(NSString *vidString) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.replyStyleViewDelegate publishBtnAction:self.inputTextView.text location:self.selectPOIName data:vidString replyFlag:3 commentModel:_model];
                    [self resetInputView];
                    [self cancelBtnAction];
                });
            } progress:^(long uploadedSize, long totalSize) {
            } failHandle:^(NSString *failMsg) {
            }];
        }
        else {
            //flag == 0
            [self.replyStyleViewDelegate publishBtnAction:self.inputTextView.text location:self.selectPOIName data:@"" replyFlag:0 commentModel:_model];
            [self resetInputView];
            [self cancelBtnAction];
        }
    }
}

- (void)toolBtnAction:(UIButton *)btn {
    
    [self resignEditing:NO];
    self.selectedIndex = btn.tag - 100;
    if (btn.tag == 100) {
        self.inputTextView.text = @"";
    }
//    else if (btn.tag == 102) {
//        [self presentVideoSelectVC];
//    }
}

- (void)cameraBtnAction {
    
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [mediatypes count] > 0 ) {
        
        //创建图像选取控制器
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        //设置图像选取控制器的来源模式为相机模式
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        //设置摄像图像品质
        [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
        //设置最长摄像时间
        [imagePickerController setVideoMaximumDuration:60];
        //允许用户进行编辑
        [imagePickerController setAllowsEditing:YES];
        //设置委托对象
        [imagePickerController setDelegate:self];
        
        //以模式视图控制器的形式显示
        [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
    }else{
         NSLog(@"当前设备不支持拍摄功能!");
    }
}

- (void)photoBtnAction {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - self.selectImagesArr.count delegate:self];
    // 默认为YES，如果设置为NO,用户将不能选择视频
    [imagePickerVc setAllowPickingVideo:NO];
    // 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
    [imagePickerVc setAllowPickingOriginalPhoto:NO];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePickerVc setSortAscendingByModificationDate:NO];
    //不允许拍照
    imagePickerVc.allowTakePicture = NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        
        if (!IsArrEmpty(photos)) {
            
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[photos count]];
            
            [photos enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL *stop) {
                
                [tmpArray addObject:obj];
            }];
            [self returnImagesSelectedFile:tmpArray];
            [self.selectImagesArr addObjectsFromArray:tmpArray];
            
            [self removeVideoData];
            _replyFlag = 2;
        }
        
    }];
    
    [self.superview.viewController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)takeVideoBtnAction {
    
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [mediatypes count] > 0 ) {
        
        //创建图像选取控制器
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        [imagePickerController setVideoMaximumDuration:30];
        [imagePickerController setAllowsEditing:YES];
        [imagePickerController setDelegate:self];
        
        [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        NSLog(@"当前设备不支持拍摄功能!");
    }
}

- (void)videoLibBtnAction {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    //用户将不能选择照片
    imagePickerVc.allowPickingImage = NO;
    // 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
    [imagePickerVc setAllowPickingOriginalPhoto:NO];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePickerVc setSortAscendingByModificationDate:NO];
    //不允许拍照
    imagePickerVc.allowTakePicture = NO;
    
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        
        if (!IsNilOrNull(asset)) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDProgressTool showIndicatorWithText:@"视频处理中..."];
            });
            [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
                NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
                self.selectVideoPath = outputPath;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [HUDProgressTool dismiss];
                    for (UIView *view in self.videoBGView.subviews) {
                        [view removeFromSuperview];
                    }
                    UIImageView *iv = [[UIImageView alloc] initWithImage:coverImage];
                    iv.frame = CGRectMake(15, 15, 140, 140);
                    [self.videoBGView addSubview:iv];
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(140, 0, 30, 30);
                    [btn setImage:[UIImage imageNamed:@"sc_delete_btn"] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(videoDeleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
                    [self.videoBGView addSubview:btn];
                    
                    [self removeImagesData];
                    _replyFlag = 3;
                });
                
            }failure:^(NSString *errorMessage, NSError *error) {
//                NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUDProgressTool showErrorWithText:@"视频处理出错"];
                });
            }];
        }
    }];
    
    [self.superview.viewController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imgDeleteBtnAction:(UIButton *)btn {
    
    UIView *deleteIV = [self.selectImagesIVArr objectAtIndex:btn.tag - 1000];
    [deleteIV removeFromSuperview];
    
    for (NSInteger i=btn.tag-999; i<self.selectImagesArr.count; i++) {
        UIView *deleteIV = [self.selectImagesIVArr objectAtIndex:i];
        CGPoint oldOri = deleteIV.frame.origin;
        deleteIV.frame = CGRectMake(oldOri.x - 100, 0, 100, 100);
        
        for (UIButton *currentBtn in deleteIV.subviews) {
            currentBtn.tag = currentBtn.tag - 1;
        }
    }
    
    [self.selectImagesArr removeObjectAtIndex:btn.tag - 1000];
    [self.selectImagesIVArr removeObjectAtIndex:btn.tag - 1000];
    
    if (self.selectImagesArr.count == 0) {
        _replyFlag = 0;
    }
    self.imgsBGScrollView.contentSize = CGSizeMake(20 + 100*self.selectImagesIVArr.count, 100);
}

- (void)videoDeleteBtnAction {
    
    [self removeVideoData];
    _replyFlag = 0;
}

- (void)locationBtnAction:(UIButton *)btn {
    
    InputLocationSelectViewController *selectVC = [InputLocationSelectViewController createWithLat:_lat lng:_lng delegate:self];
    [self.viewController presentViewController:selectVC animated:YES completion:nil];
}

#pragma mark - InputLocationSelectDelegate

- (void)didNotDisplayLocation {
    self.selectPOIName = @"";
    [self updatePOIName:@"不显示位置"];
}

- (void)didSelectLocation:(NSString *)locationName {
    self.selectPOIName = locationName;
    [self updatePOIName:locationName];
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 获取媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断是静态图像还是视频
    if([mediaType isEqual:(NSString *)kUTTypeImage]){
        
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (!IsNilOrNull(chosenImage)) {
            
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
            [tmpArray addObject:chosenImage];
            [self returnImagesSelectedFile:tmpArray];
            [self.selectImagesArr addObjectsFromArray:tmpArray];
            
            [self removeVideoData];
            _replyFlag = 2;
        }
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUDProgressTool showIndicatorWithText:@"视频处理中..."];
        });
        
        NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        
        //获取首帧图片
        AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetGen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        
        //如果是拍摄的视频, 则把视频保存在系统多媒体库中
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeVideoAtPathToSavedPhotosAlbum:info[UIImagePickerControllerMediaURL] completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
                NSLog(@"视频保存成功");
            } else {
                NSLog(@"视频保存失败");
            }
        }];

        [self startExportVideoWithVideoAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
            NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
            self.selectVideoPath = outputPath;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [HUDProgressTool dismiss];
                for (UIView *view in self.videoBGView.subviews) {
                    [view removeFromSuperview];
                }
                UIImageView *iv = [[UIImageView alloc] initWithImage:videoImage];
                iv.frame = CGRectMake(15, 15, 140, 140);
                [self.videoBGView addSubview:iv];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(140, 0, 30, 30);
                [btn setImage:[UIImage imageNamed:@"sc_delete_btn"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(videoDeleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
                [self.videoBGView addSubview:btn];
                
                [self removeImagesData];
                _replyFlag = 3;
            });
        } failure:^(NSString *errorMessage, NSError *error) {
//            NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDProgressTool showErrorWithText:@"视频处理出错"];
            });
        }];
    }
    else {
        [HUDProgressTool showOnlyText:@"系统只支持图片或视频格式!"];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ReplyRecordBtnDelegate

- (void)buttonAudioRecorder:(ReplyRecordBtn *)audioRecorder didFinishRcordWithAudioInfo:(NSDictionary *)audioInfo sendFlag:(BOOL)flag{
    
    if (flag) {
        NSLog(@"\n文件名称:%@\n音频时长:%@\n文件路径:%@",audioInfo[AudioRecorderName],audioInfo[AudioRecorderDuration],audioInfo[AudioRecorderPath]);
        NSString *fileName = [audioInfo objectForKey:AudioRecorderName];
        NSString *voicePath = [audioInfo objectForKey:AudioRecorderPath];
        
        NSData *data = [NSData dataWithContentsOfFile:voicePath];
        [VoiceUpload uploadVoiceWithVoicepath:voicePath title:fileName tags:@"aac" voiceSize:data.length lat:0 lng:0 successHandle:^(NSString *vidString) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.replyStyleViewDelegate) {
                    [self.replyStyleViewDelegate publishBtnAction:@"" location:self.selectPOIName data:vidString replyFlag:1 commentModel:_model];
                }
                [self resetInputView];
                [self cancelBtnAction];
            });
        } progress:^(long uploadedSize, long totalSize) {
            
        } failHandle:^(NSString *failMsg) {
            
        }];
        
    }else{
        NSLog(@"取消录音");
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (_selectedIndex == 0) {
        self.selectedIndex = -1;
    }
}

#pragma mark - Set

- (void)setSelectedIndex:(NSInteger)selectedIndex {

    if (_selectedIndex != selectedIndex) {
        
        if (_selectedIndex > -1) {
            UIButton *toolBtn = [self.btnsItemArr objectAtIndex:_selectedIndex];
            toolBtn.selected = NO;
        }
        if (selectedIndex > -1) {
            UIButton *toolBtn = [self.btnsItemArr objectAtIndex:selectedIndex];
            toolBtn.selected = YES;
        }
        
        _selectedIndex = selectedIndex;
        if (selectedIndex == 0) {
            //语音
            self.voiceDetailView.hidden = NO;
            self.imgDetailView.hidden = YES;
            self.videoDetailView.hidden = YES;
            self.locationDetailView.hidden = YES;
        }
        else if (selectedIndex == 1) {
            //图片
            self.voiceDetailView.hidden = YES;
            self.imgDetailView.hidden = NO;
            self.videoDetailView.hidden = YES;
            self.locationDetailView.hidden = YES;
        }
        else if (selectedIndex == 2) {
            //视频
            self.voiceDetailView.hidden = YES;
            self.imgDetailView.hidden = YES;
            self.videoDetailView.hidden = NO;
            self.locationDetailView.hidden = YES;
        }
        else if (selectedIndex == 3) {
            //定位
            self.voiceDetailView.hidden = YES;
            self.imgDetailView.hidden = YES;
            self.videoDetailView.hidden = YES;
            self.locationDetailView.hidden = NO;
        }
        else {
            self.imgDetailView.hidden = YES;
            self.videoDetailView.hidden = YES;
            self.voiceDetailView.hidden = YES;
            self.locationDetailView.hidden = YES;
        }
    }
}

#pragma mark - Getter

- (NSMutableArray *)btnsItemArr {
    if (!_btnsItemArr) {
        _btnsItemArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _btnsItemArr;
}

- (SZTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[SZTextView alloc] initWithFrame:CGRectMake(10, 44, self.bounds.size.width - 20, 110)];
        _inputTextView.placeholder = @"聊点什么吧";
        _inputTextView.inputAccessoryView = [[UIView alloc] init];
        _inputTextView.delegate = self;
        _inputTextView.font = SYSTEM_FONT(14);
    }
    return _inputTextView;
}

- (UIView *)imgDetailView {
    if (!_imgDetailView) {
        _imgDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + 110 + 50, self.bounds.size.width, 258)];
        _imgDetailView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_imgDetailView];
        
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cameraBtn.frame = CGRectMake(10, 10, (self.bounds.size.width - 30)/2.0, 44);
        [cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
        cameraBtn.layer.masksToBounds = YES;
        cameraBtn.layer.cornerRadius = 4.f;
        cameraBtn.layer.borderWidth = 1.f;
        cameraBtn.layer.borderColor = [UIColorFromHex(0x8e8f91) CGColor];
        [cameraBtn setTitleColor:UIColorFromHex(0x8e8f91) forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(cameraBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_imgDetailView addSubview:cameraBtn];
        
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        photoBtn.frame = CGRectMake(20 + (self.bounds.size.width - 30)/2.0, 10, (self.bounds.size.width - 30)/2.0, 44);
        [photoBtn setTitle:@"相册" forState:UIControlStateNormal];
        photoBtn.layer.masksToBounds = YES;
        photoBtn.layer.cornerRadius = 4.f;
        photoBtn.layer.borderWidth = 1.f;
        photoBtn.layer.borderColor = [UIColorFromHex(0x8e8f91) CGColor];
        [photoBtn setTitleColor:UIColorFromHex(0x8e8f91) forState:UIControlStateNormal];
        [photoBtn addTarget:self action:@selector(photoBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_imgDetailView addSubview:photoBtn];
        
        [_imgDetailView addSubview:self.imgsBGScrollView];
    }
    return _imgDetailView;
}

- (UIView *)videoDetailView {
    if (!_videoDetailView) {
        _videoDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + 110 + 50, self.bounds.size.width, 258)];
        _videoDetailView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_videoDetailView];
        
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cameraBtn.frame = CGRectMake(10, 10, (self.bounds.size.width - 30)/2.0, 44);
        [cameraBtn setTitle:@"拍摄" forState:UIControlStateNormal];
        cameraBtn.layer.masksToBounds = YES;
        cameraBtn.layer.cornerRadius = 4.f;
        cameraBtn.layer.borderWidth = 1.f;
        cameraBtn.layer.borderColor = [UIColorFromHex(0x8e8f91) CGColor];
        [cameraBtn setTitleColor:UIColorFromHex(0x8e8f91) forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(takeVideoBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_videoDetailView addSubview:cameraBtn];
        
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        photoBtn.frame = CGRectMake(20 + (self.bounds.size.width - 30)/2.0, 10, (self.bounds.size.width - 30)/2.0, 44);
        [photoBtn setTitle:@"相册" forState:UIControlStateNormal];
        photoBtn.layer.masksToBounds = YES;
        photoBtn.layer.cornerRadius = 4.f;
        photoBtn.layer.borderWidth = 1.f;
        photoBtn.layer.borderColor = [UIColorFromHex(0x8e8f91) CGColor];
        [photoBtn setTitleColor:UIColorFromHex(0x8e8f91) forState:UIControlStateNormal];
        [photoBtn addTarget:self action:@selector(videoLibBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_videoDetailView addSubview:photoBtn];
        
        [_videoDetailView addSubview:self.videoBGView];
    }
    return _videoDetailView;
}

- (UIView *)voiceDetailView {
    if (!_voiceDetailView) {
        _voiceDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + 110 + 50, self.bounds.size.width, 258)];
        _voiceDetailView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_voiceDetailView];
        
        [_voiceDetailView addSubview:self.recordBtn];
    }
    return _voiceDetailView;
}

- (UIView *)locationDetailView {
    if (!_locationDetailView) {
        _locationDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + 110 + 50, self.bounds.size.width, 258)];
        _locationDetailView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_locationDetailView];
        
        [_locationDetailView addSubview:self.locationNameBtn];
    }
    return _locationDetailView;
}

- (NSMutableArray *)selectImagesArr {
    if (!_selectImagesArr) {
        _selectImagesArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectImagesArr;
}

- (NSMutableArray *)selectImagesIVArr {
    if (!_selectImagesIVArr) {
        _selectImagesIVArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectImagesIVArr;
}

- (UIScrollView *)imgsBGScrollView {
    if (!_imgsBGScrollView) {
        _imgsBGScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 106, self.bounds.size.width - 20, 100)];
    }
    return _imgsBGScrollView;
}

- (UIView *)videoBGView {
    if (!_videoBGView) {
        _videoBGView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 170)/2.0, 54 + (204 - 170)/2.0, 170, 170)];
    }
    return _videoBGView;
}

- (UIButton *)locationNameBtn {
    if (!_locationNameBtn) {
        _locationNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationNameBtn.frame = CGRectMake(15, 15, 100, 30);
        [_locationNameBtn setTitle:@"不显示位置" forState:UIControlStateNormal];
        _locationNameBtn.titleLabel.font = SYSTEM_FONT(14);
        [_locationNameBtn setTitleColor:UIColorFromHex(0x8e8f91) forState:UIControlStateNormal];
        _locationNameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_locationNameBtn addTarget:self action:@selector(locationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _locationNameBtn.layer.borderWidth = 1.f;
        _locationNameBtn.layer.borderColor = [UIColorFromHex(0x8e8f91) CGColor];
        _locationNameBtn.layer.cornerRadius = 5.f;
        _locationNameBtn.clipsToBounds = YES;
    }
    return _locationNameBtn;
}

- (ReplyRecordBtn *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [[ReplyRecordBtn alloc] init];
        _recordBtn.frame = CGRectMake((self.bounds.size.width - 160)/2.0, (258 - 160)/2.0, 160, 160);
        [_recordBtn setImage:[UIImage imageNamed:@"record_yy_normal"] forState:UIControlStateNormal];
        [_recordBtn setChangeImage:[UIImage imageNamed:@"record_yy_highlight"]];
        [_recordBtn setUpChangeImage:[UIImage imageNamed:@"record_yy_highlight"]];
        _recordBtn.layer.cornerRadius = 80.f;
        _recordBtn.layer.masksToBounds = YES;
        _recordBtn.delegate = self;
    }
    return _recordBtn;
}

- (NSString *)selectPOIName {
    if (!_selectPOIName) {
        _selectPOIName = @"";
    }
    return _selectPOIName;
}

#pragma mark - Tool

- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if ([presets containsObject:presetName]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:presetName];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss-SSS"];
        NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        // NSLog(@"video outputPath = %@",outputPath);
        session.outputURL = [NSURL fileURLWithPath:outputPath];
        
        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            if (failure) {
                failure(@"该视频类型暂不支持导出", nil);
            }
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        AVMutableVideoComposition *videoComposition = [self fixedCompositionWithAsset:videoAsset];
        if (videoComposition.renderSize.width) {
            // 修正视频转向
            session.videoComposition = videoComposition;
        }
        
        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (session.status) {
                    case AVAssetExportSessionStatusUnknown: {
                        NSLog(@"AVAssetExportSessionStatusUnknown");
                    }  break;
                    case AVAssetExportSessionStatusWaiting: {
                        NSLog(@"AVAssetExportSessionStatusWaiting");
                    }  break;
                    case AVAssetExportSessionStatusExporting: {
                        NSLog(@"AVAssetExportSessionStatusExporting");
                    }  break;
                    case AVAssetExportSessionStatusCompleted: {
                        NSLog(@"AVAssetExportSessionStatusCompleted");
                        if (success) {
                            success(outputPath);
                        }
                    }  break;
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"AVAssetExportSessionStatusFailed");
                        if (failure) {
                            failure(@"视频导出失败", session.error);
                        }
                    }  break;
                    case AVAssetExportSessionStatusCancelled: {
                        NSLog(@"AVAssetExportSessionStatusCancelled");
                        if (failure) {
                            failure(@"导出任务已被取消", nil);
                        }
                    }  break;
                    default: break;
                }
            });
        }];
    } else {
        if (failure) {
            NSString *errorMessage = [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName];
            failure(errorMessage, nil);
        }
    }
}

/// 获取优化后的视频转向信息
- (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self degressFromVideoFileWithAsset:videoAsset];
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        videoComposition.frameDuration = CMTimeMake(1, 30);
        
        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // 加入视频方向信息
        videoComposition.instructions = @[roateInstruction];
    }
    return videoComposition;
}

/// 获取视频角度
- (int)degressFromVideoFileWithAsset:(AVAsset *)asset {
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

@end
