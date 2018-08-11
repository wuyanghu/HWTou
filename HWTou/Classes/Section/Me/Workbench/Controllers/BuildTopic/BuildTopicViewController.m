//
//  BuildTopicViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BuildTopicViewController.h"
#import "BuildTopicView.h"
#import "PublicHeader.h"
#import "BuildTopicCarouselCell.h"
#import "EditCoverViewController.h"
#import "TopicSignSelectView.h"
#import "CollectSessionReq.h"
#import "TopicWorkDetailModel.h"
#import "TopicUpload.h"
#import "TopicAudioSelectView.h"
#import "iPodReaderUtil.h"
#import "FayeFileManager.h"
#import "AudioRecordViewController.h"

@interface BuildTopicViewController ()<BuildTopicViewDelegate, TopicButtonSelectedDelegate, EditCoverViewControllerDelegate, AudioRecordViewControllerDelegate>
{
    EditCoverViewController * editVC;
}
@property (nonatomic, strong) BuildTopicView * topicView;
@property (nonatomic, strong) NSMutableArray *labelListDataArr;

@property (nonatomic, copy) NSString *labelIds;
@property (nonatomic, strong) NSMutableArray<UIImage *> *imgs;

@property (nonatomic, copy) NSString *audioPathString;
@property (nonatomic, copy) NSString *audioTypeString;
@property (nonatomic, assign) NSInteger totalSize;

@end

@implementation BuildTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBarView];
    
    [self.view addSubview:self.topicView];
    
    [self.topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kMainScreenWidth, kMainScreenHeight-64));
    }];
    
    [self dataRequest];
}

- (void)dataRequest {
    
    [CollectSessionReq topicLabelList:[BaseParam new] Success:^(MyTopicListResponse *response) {
        if (response.status == 200) {
            
            [self.labelListDataArr removeAllObjects];
            
            for (NSDictionary * dataDict in response.data) {
                TopicLabelListModel * topicLabelListModel = [TopicLabelListModel new];
                [topicLabelListModel setValuesForKeysWithDictionary:dataDict];
                
                [self.labelListDataArr addObject:topicLabelListModel];
            }
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)addNavBarView{

    UIView * navbarview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    [self.view addSubview:navbarview];
    
    UIButton *msgBtn = [BasisUITool getBtnWithTarget:self
                                              action:@selector(buttonSelected:)];
    [msgBtn setTitle:@"取消" forState:UIControlStateNormal];
    [msgBtn setTitleColor:UIColorFromHex(0x8E8F91) forState:UIControlStateNormal];
    [msgBtn.titleLabel setFont:FontPFRegular(17)];
    msgBtn.tag = cancelBtnType;
    [navbarview addSubview:msgBtn];
    
    UILabel *labNavTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333)
                                                         size:NAVIGATION_FONT_TITLE_SIZE];
    labNavTitle.textAlignment = NSTextAlignmentCenter;
    [labNavTitle setText:@"发布话题"];
    [navbarview addSubview:labNavTitle];
    
    UIButton * workBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
    [workBtn setTitle:@"发布" forState:UIControlStateNormal];
    [workBtn setTitleColor:UIColorFromHex(0xAD0021) forState:UIControlStateNormal];
    [workBtn.titleLabel setFont:FontPFRegular(17)];
    workBtn.tag = issueBtnType;
    [navbarview addSubview:workBtn];

    [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(40, 34));
        make.bottom.equalTo(navbarview).offset(-5);
        make.left.equalTo(navbarview).offset(10);
    }];
    
    [labNavTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(150,34));
        make.left.equalTo((kMainScreenWidth-150)/2);
        make.bottom.equalTo(msgBtn);
    }];
    
    [workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(40, 34));
        make.bottom.equalTo(labNavTitle);
        make.right.equalTo(navbarview).offset(-10);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableDictionary *dictAttribute = [NSMutableDictionary dictionaryWithCapacity:2];
    [dictAttribute setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [dictAttribute setObject:FontPFRegular(18.0f) forKey:NSFontAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dictAttribute];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.98 alpha:1]] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - AudioRecordViewControllerDelegate

- (void)didSelectRecordAudio {
    
    NSData *wavData = [NSData dataWithContentsOfFile:[FayeFileManager filePath]];
    
    self.audioPathString = [FayeFileManager filePath];
    self.audioTypeString = @"wav";
    self.totalSize = wavData.length;
}

#pragma mark - Sup

- (void)showAudioRecordController {
//    [Navigation showAudioRecordViewController:self];
    AudioRecordViewController *recordVC = [[AudioRecordViewController alloc] init];
    recordVC.delegate = self;
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)showAudioFileSelectView {
    TopicAudioSelectView *audioSelectView = [[TopicAudioSelectView alloc] init];
    audioSelectView.selectBlock = ^(MPMediaItem *item) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUDProgressTool showIndicatorWithText:@"正在转码中..."];
        });
        
        NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"TestLib"];
        [iPodReaderUtil exportAudioWithMPItem:item exportPath:dirPath success:^(NSString *type,NSInteger size) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [HUDProgressTool showSuccessWithText:@"导出音频文件成功"];
                
                self.audioPathString = [dirPath stringByAppendingPathComponent:@"exported.caf"];
                self.audioTypeString = type;
                self.totalSize = size;
            });
            
            
        } progress:^(NSInteger currentSize, NSInteger totalSize) {
            
            //                NSLog(@"___%ld___",currentSize);
            
            //                dispatch_async(dispatch_get_main_queue(), ^{
            
            //                    [HUDProgressTool showOnlyText:[NSString stringWithFormat:@"正在转码中...已完成:%ld",currentSize]];
            //                    [HUDProgressTool showIndicatorWithText:@"正在转码中..."];
            //                });
            
        } failure:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [HUDProgressTool showErrorWithText:@"导出音频文件失败"];
            });
        }];
        
    };
    audioSelectView.dismissBlock = ^{
        
    };
    [audioSelectView show];
}

#pragma mark - Action

- (void)buttonSelected:(UIButton *)button{
    if (button.tag == enterBtnType) {//录入语音
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actRecord = [UIAlertAction actionWithTitle:@"录制话题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showAudioRecordController];
        }];
        [actionSheet addAction:actRecord];
        UIAlertAction *actWrite = [UIAlertAction actionWithTitle:@"上传话题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showAudioFileSelectView];
        }];
        [actionSheet addAction:actWrite];
        UIAlertAction *actCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheet addAction:actCancel];
        [self presentViewController:actionSheet animated:YES completion:nil];
        
    }else if (button.tag == editBtnType){//编辑封面
        if (!editVC) {
            editVC = [[EditCoverViewController alloc] init];
            editVC.editDelegate = self;
        }
        [self.navigationController pushViewController:editVC animated:YES];
    }else if (button.tag == cancelBtnType){//取消
        [self.navigationController popViewControllerAnimated:YES];
    }else if(button.tag == issueBtnType){//发布
        
        //封面、标签、标题不能为空<音频和内容2选1>
        
        if ([[self.topicView getTitle] isEqualToString:@""]) {
            [HUDProgressTool showErrorWithText:@"请输入标题"];
            return;
        }
        if ([self.labelIds isEqualToString:@""]) {
            [HUDProgressTool showErrorWithText:@"请选择话题标签"];
            return;
        }
        if (!self.imgs.count) {
            [HUDProgressTool showErrorWithText:@"请编辑话题封面图片"];
            return;
        }
        
        
        if ([self.audioPathString isEqualToString:@""] && [[self.topicView shareContent] isEqualToString:@""]) {
            [HUDProgressTool showErrorWithText:@"请选择音频文件或输入您的话题内容"];
            return;
        }
        
//        NSString *rrr = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
        [HUDProgressTool showIndicatorWithText:@"发布话题中..."];
        [TopicUpload uploadVideoWithAudiopath:self.audioPathString tags:self.audioTypeString audioSize:self.totalSize labelIds:self.labelIds frameImage:self.imgs title:[self.topicView getTitle] content:[self.topicView shareContent] lat:0 lng:0 successHandle:^{
            
            [HUDProgressTool showSuccessWithText:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } progress:^(long total, long current) {
            
        } failHandle:^(NSString *msg) {
            [HUDProgressTool showErrorWithText:msg];
        }];
    }
}

- (void)selectImgArr:(NSArray<UIImage *> *)imgArr{
    [self.topicView setVCarouselImgArr:imgArr];
    
    [self.imgs removeAllObjects];
    for (int i = 0; i<imgArr.count; i++) {
        [self.imgs addObject:imgArr[i]];
    }
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2) {
        //选择您的话题标题
        
        TopicSignSelectView *selectView = [[TopicSignSelectView alloc] initWithLabelListArray:self.labelListDataArr];
        selectView.selectBlock = ^(TopicLabelListModel *listModel) {
            self.labelIds = [NSString stringWithFormat:@"%ld",listModel.labelId];
            self.topicView.labelTitle = listModel.labelName;
        };
        selectView.dismissBlock = ^{
            
        };
        [selectView show];
    }
}


#pragma mark - Get

- (BuildTopicView *)topicView{
    if (!_topicView) {
        _topicView = [[BuildTopicView alloc] init];
        _topicView.btnDelegate = self;
        _topicView.topicDelegate = self;
    }
    return _topicView;
}

- (NSMutableArray *)labelListDataArr {
    if (!_labelListDataArr) {
        _labelListDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _labelListDataArr;
}

- (NSMutableArray<UIImage *> *)imgs {
    if (!_imgs) {
        _imgs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _imgs;
}

- (NSString *)audioPathString {
    if (!_audioPathString) {
        _audioPathString = @"";
    }
    return _audioPathString;
}

- (NSString *)audioTypeString {
    if (!_audioTypeString) {
        _audioTypeString = @"";
    }
    return _audioTypeString;
}

- (NSString *)labelIds {
    if (!_labelIds) {
        _labelIds = @"";
    }
    return _labelIds;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
