//
//  SubCommentViewController.m
//  HWTou
//
//  Created by Reyna on 2017/11/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SubCommentViewController.h"
#import "PublicHeader.h"
#import "SubCommentViewModel.h"
#import "AudioPlayerCommentCell.h"
#import "RadioRequest.h"
#import "AudioPlayerFooterView.h"
#import "CollectSessionReq.h"
#import "AccountManager.h"
#import "RadioSessionReq.h"
#import "PersonInfoCardView.h"
#import "ReplyInputView.h"
#import "ReplyVideoPlayerViewController.h"
#import "AudioPlayerView.h"
#import "PYPhotoBrowser.h"

@interface SubCommentViewController () <AudioPlayerCommentDelegate,AudioPlayerFooterViewDelegate, PersonInfoCardViewDelegate, UITableViewDelegate, UITableViewDataSource, ReplyInputViewDelegate>

@property (nonatomic, strong) PersonInfoCardView *cardView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SubCommentViewModel *subVM;
@property (nonatomic, strong) AudioPlayerFooterView * footerView;

@property (nonatomic, strong) UIView *replyBackView;//评论背景层
@property (nonatomic, strong) ReplyInputView *replyInputView;//评论输入视图

@end

@implementation SubCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = [NSString stringWithFormat:@"%d条回复",self.model.replyNum];
    [self dataRequest];
    
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.height.equalTo(50);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.footerView setIsCollected:_playerDetailViewModel.isCollected];
}

- (void)dealloc{
    
}

#pragma mark - KeyboardNotify
//当键盘改变了frame(位置和尺寸)的时候调用
- (void)keyboardWillChangeFrameNotify:(NSNotification*)notify {
    
    // 键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat finalY = keyboardFrame.origin.y;
    
    
    if (finalY == kMainScreenHeight) {
        [UIView animateWithDuration:duration animations:^{
            self.replyInputView.frame = CGRectMake(0, finalY - (kMainScreenHeight - self.view.bounds.size.height) - INPUT_DETAIL_HEIGHT, kMainScreenWidth, INPUT_DETAIL_HEIGHT);
        } completion:^(BOOL finished) {
        }];
    }
    else {
        [UIView animateWithDuration:duration animations:^{
            self.replyInputView.frame = CGRectMake(0, finalY - 204 - (kMainScreenHeight - self.view.bounds.size.height), kMainScreenWidth, INPUT_DETAIL_HEIGHT);
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Request

- (void)dataRequest {
    
    [RadioRequest getCommentReplyWithPage:1 pageSize:1000 parentCommentId:self.model.parentCommentId parentUid:self.model.parentUid success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            [self.subVM bindWithDic:response];
            [self.tableView reloadData];
        }else{
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)attentionRequestWithUserId:(int)userId {
    
    FocusSomeOneParam * param = [FocusSomeOneParam new];
    param.focusId = [NSString stringWithFormat:@"%d",userId];
    [PersonHomeRequest focusSomeOne:param Success:^(TopicWorkDetailResponse *response) {
        if (response.status == 200) {
            NSInteger state = [response.data[@"state"] integerValue];
            [HUDProgressTool showSuccessWithText:state == 0?@"取消关注成功":@"关注成功"];
            
            [_cardView refreshWithState:state];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}


#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subVM.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AudioPlayerCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[AudioPlayerCommentCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    SubCommentModel *m = [self.subVM.dataArr objectAtIndex:indexPath.row];
    [cell content:m historyModel:self.historyModel];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    SubCommentModel *m = [self.subVM.dataArr objectAtIndex:indexPath.row];
    return m.subCellHeight;
}

#pragma mark - Sup

- (void)showUserInfoCardWithUserId:(int)userId {
    
    UserInfoParam * homeParam = [[UserInfoParam alloc] init];
    BOOL isSelf = NO;
    if ([AccountManager shared].account.uid == userId) {
        homeParam.uid = 0;
        isSelf = YES;
    }
    else {
        homeParam.uid = userId;
        isSelf = NO;
    }
    
    [HUDProgressTool showIndicatorWithText:@""];
    //个人资料
    [PersonHomeRequest getUserInfo:homeParam Success:^(PersonHomeResponse *response) {
        
        [HUDProgressTool dismiss];
        
        _cardView = [[PersonInfoCardView alloc] initWithUserModel:response.data isSelf:isSelf userId:userId];
        _cardView.delegate = self;
        [_cardView show];
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - PersonInfoCardViewDelegate

- (void)mePageActionWithUserId:(int)userId isSelf:(BOOL)isSelf {
    [Navigation showPersonalHomePageViewController:self attendType:isSelf ? editDataButtonType : dynamicButtonType uid:userId];
}

- (void)attentionActionWithUserId:(int)userId isCancel:(BOOL)isCancel {
    
    if (isCancel) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消关注" message:@"确定要取消关注该用户？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self attentionRequestWithUserId:userId];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        [alert addAction:cancleAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else {
        [self attentionRequestWithUserId:userId];
    }
}

#pragma mark - AudioPlayerCommentDelegate

- (void)replyBtnActionWithToUid:(PlayerCommentModel *)model{
    
    [self.replyInputView setModel:model];
    self.replyBackView.hidden = NO;
    [self.replyInputView resignEditing:YES];
}

- (void)zanBtnActionWithCommentId:(int)commentId {
    [RadioRequest praiseCommentWithCommentId:commentId success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSString * state = [[[response objectForKey:@"data"] objectForKey:@"state"] stringValue];
            NSDictionary * dict = @{@"0":@"取消点赞成功",@"1":@"点赞成功"};
            [HUDProgressTool showSuccessWithText:dict[state]];
            [self dataRequest];
            
        }else{
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)deleteBtnActionWithCommentId:(int)commentId {
    
    if (self.historyModel.flag == 1) {
        [RadioRequest deleteChannelCommentWithChannelId:self.historyModel.rtcId commentId:commentId radioId:0 success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                NSString * state = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
                [HUDProgressTool showSuccessWithText:state];
                [self dataRequest];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
        [RadioRequest deleteTopicCommentWithTopicId:self.historyModel.rtcId commentId:commentId success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                NSString * state = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
                [HUDProgressTool showSuccessWithText:state];
                [self dataRequest];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){
        [RadioRequest delChatCommentWithChatId:self.historyModel.rtcId commentId:commentId success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                NSString * state = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
                [HUDProgressTool showSuccessWithText:state];
                [self dataRequest];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    
}

- (void)userInfoActionWithUserId:(int)userId {
    
    [self showUserInfoCardWithUserId:userId];
}

- (void)videoBtnAction:(NSString *)videoUrl {
    ReplyVideoPlayerViewController *vc = [[ReplyVideoPlayerViewController alloc] init];
    vc.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
    [self presentViewController:vc animated:YES completion:^{
        [vc.player play];
        [[AudioPlayerView sharedInstance] pauseForPlayVoiceReply];
    }];
}

- (void)imgBtnAction:(NSArray *)imgsArr index:(NSInteger)index {
    if (!IsArrEmpty(imgsArr)) {
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
        [photoBroseView setShowDuration:0.f];
        [photoBroseView setHiddenDuration:0.f];
        
        [photoBroseView setImagesURL:imgsArr];// 2.1 设置图片源URL(NSString)数组
        [photoBroseView setCurrentIndex:index];// 2.2 设置初始化图片下标（即当前点击第几张图片）
        [photoBroseView show];// 3.显示(浏览)
    }
}

#pragma mark - AudioPlayerFooterViewDelegate

- (void)topBtnAction:(PlayerCommentModel *)model{
    TopComParam * topComParam = [TopComParam new];
    topComParam.chatId = self.historyModel.rtcId;
    topComParam.comId = model.subModel.replyCommentId;
    topComParam.comUid = model.subModel.fromUid;
    
    [RadioRequest setTopCom:topComParam success:^(NSDictionary * response){
        if ([[response objectForKey:@"status"] intValue] == 200) {
//            [HUDProgressTool showSuccessWithText:state];
            [self dataRequest];
        }else{
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError * error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)userCollect {
    
    if (self.historyModel.flag == 1) {
        CollectChannelParam * param = [CollectChannelParam new];
        param.channelId = self.historyModel.rtcId;
        
        [CollectSessionReq getCollectChannel:param Success:^(CollectChannelResponse *response) {
            if (response.status == 200) {
                NSString * state = [response.data[@"state"] stringValue];
                NSDictionary * dict = @{@"0":@"取消收藏成功",@"1":@"收藏成功"};
                [HUDProgressTool showSuccessWithText:dict[state]];
                [self.footerView setIsCollected:[state intValue]];//成功之后刷新 收藏按钮
                _playerDetailViewModel.isCollected = [state intValue];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
        CollectTopicParam * param = [CollectTopicParam new];
        param.topicId = self.historyModel.rtcId;
        
        [CollectSessionReq collectTopic:param Success:^(CollectChannelResponse *response) {
            if (response.status == 200) {
                NSString * state = [response.data[@"state"] stringValue];
                NSDictionary * dict = @{@"0":@"取消收藏成功",@"1":@"收藏成功"};
                [HUDProgressTool showSuccessWithText:dict[state]];
                [self.footerView setIsCollected:[state intValue]];//成功之后刷新 收藏按钮
                _playerDetailViewModel.isCollected = [state intValue];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){
        CollectChatParam * param = [CollectChatParam new];
        param.chatId = self.historyModel.rtcId;
        
        [CollectSessionReq collectChat:param Success:^(CollectChannelResponse *response) {
            if (response.status == 200) {
                NSString * state = [response.data[@"state"] stringValue];
                NSDictionary * dict = @{@"0":@"取消收藏成功",@"1":@"收藏成功"};
                [HUDProgressTool showSuccessWithText:dict[state]];
                [self.footerView setIsCollected:[state intValue]];//成功之后刷新 收藏按钮
                _playerDetailViewModel.isCollected = [state intValue];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

- (void)showCommentText:(PlayerCommentModel *)playerCommentModel{
    if (playerCommentModel) {//回复
        [HUDProgressTool showSuccessWithText:@"回复成功"];
    }else{//评论
        [HUDProgressTool showSuccessWithText:@"评论成功"];
    }
}

- (void)userComment:(NSString *)conent playerCommentModel:(PlayerCommentModel *)playerCommentModel{
    int toUid;
    int preCommentId;
    int parentId;
    if (playerCommentModel != nil) {
        toUid = playerCommentModel.subModel.fromUid;
        preCommentId = playerCommentModel.subModel.replyCommentId;
        parentId = self.model.parentCommentId;
    }else{
        toUid = self.model.parentUid;
        parentId = self.model.parentCommentId;
        preCommentId = self.model.parentCommentId;
    }
    
    if (self.historyModel.flag == 1) {
        [RadioSessionReq commentChannelWithChannelId:self.historyModel.rtcId uid:self.historyModel.rtcId toUid:toUid commentText:conent commentUrl:@"" location:@"" parentId:parentId preCommentId:preCommentId commentFlag:0 success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self dataRequest];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
        
        [RadioSessionReq commentTopic:self.historyModel.rtcId uid:[self.playerDetailViewModel.createBy integerValue] toUid:toUid commentText:conent commentUrl:@"" location:@"" parentId:parentId preCommentId:preCommentId commentFlag:0 success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self dataRequest];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if(self.historyModel.flag == 3){

        [RadioSessionReq commentChat:self.historyModel.isWorkChat?1:0 chatId:self.historyModel.rtcId uid:[self.playerDetailViewModel.createBy integerValue] toUid:toUid commentText:conent commentUrl:@"" location:@"" parentId:parentId preCommentId:preCommentId commentFlag:0 success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self dataRequest];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

- (void)userCommentWithVoice:(NSString *)vidString playerCommentModel:(PlayerCommentModel *)playerCommentModel {
    
    if (self.historyModel.flag == 1) {
        [RadioSessionReq commentChannelWithChannelId:(int)self.historyModel.rtcId uid:self.historyModel.rtcId toUid:playerCommentModel.parentUid commentText:@"" commentUrl:vidString location:@"" parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:1 success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self dataRequest];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
        [RadioSessionReq commentTopic:(int)self.historyModel.rtcId uid:[self.playerDetailViewModel.createBy integerValue] toUid:playerCommentModel.parentUid commentText:@"" commentUrl:vidString location:@"" parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:1 success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self dataRequest];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){
        
        [RadioSessionReq commentChat:self.historyModel.isWorkChat?1:0 chatId:(int)self.historyModel.rtcId uid:[self.playerDetailViewModel.createBy integerValue] toUid:playerCommentModel.parentUid commentText:@"" commentUrl:vidString location:@"" parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:1 success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self dataRequest];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

- (void)userSwithCommentType {
    
    self.replyBackView.hidden = NO;
    [self.replyInputView resignEditing:YES];
}

#pragma mark - ReplyInputViewDelegate

- (void)cancelBtnAction {
    
    [UIView animateWithDuration:0.225 animations:^{
        self.replyInputView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, INPUT_DETAIL_HEIGHT);
    } completion:^(BOOL finished) {
        self.replyBackView.hidden = YES;
    }];
}

- (void)publishBtnAction:(NSString *)conent location:(NSString *)locationStr data:(NSString *)data replyFlag:(int)replyFlag commentModel:(PlayerCommentModel *)playerCommentModel {
    
    if (self.historyModel.flag == 1) {
        [RadioSessionReq commentChannelWithChannelId:(int)self.historyModel.rtcId uid:self.historyModel.rtcId toUid:playerCommentModel.parentUid commentText:conent commentUrl:data location:locationStr parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:replyFlag success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self dataRequest];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
        [RadioSessionReq commentTopic:(int)self.historyModel.rtcId uid:[self.playerDetailViewModel.createBy integerValue] toUid:playerCommentModel.parentUid commentText:conent commentUrl:data location:locationStr parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:replyFlag success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self dataRequest];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){
        
        [RadioSessionReq commentChat:self.historyModel.isWorkChat?1:0 chatId:(int)self.historyModel.rtcId uid:[self.playerDetailViewModel.createBy integerValue] toUid:playerCommentModel.parentUid commentText:conent commentUrl:data location:locationStr parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:replyFlag success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self dataRequest];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

- (void)swithCommentTypeAction {
    
    [UIView animateWithDuration:0.225 animations:^{
        self.replyInputView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, INPUT_DETAIL_HEIGHT);
    } completion:^(BOOL finished) {
        self.replyBackView.hidden = YES;
    }];
}

#pragma mark - Get

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight -64-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#ifdef __IPHONE_11_0
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"AudioPlayerCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[AudioPlayerCommentCell cellReuseIdentifierInfo]];
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf dataRequest];
        }];
    }
    return _tableView;
}

- (SubCommentViewModel *)subVM {
    if (!_subVM) {
        _subVM = [[SubCommentViewModel alloc] init];
    }
    return _subVM;
}

- (AudioPlayerFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[AudioPlayerFooterView alloc] init];
        [_footerView setModel:self.model];
        _footerView.footerViewDelegate = self;
    }
    return _footerView;
}

- (UIView *)replyBackView {
    if (!_replyBackView) {
        _replyBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
        _replyBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.view addSubview:_replyBackView];
    }
    return _replyBackView;
}

- (ReplyInputView *)replyInputView {
    if (!_replyInputView) {
        _replyInputView = [[ReplyInputView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, INPUT_DETAIL_HEIGHT)];
        [_replyInputView setDefaultModel:self.model];
        [_replyInputView setModel:self.model];
        _replyInputView.replyInputViewDelegate = self;
        [self.replyBackView addSubview:_replyInputView];
    }
    return _replyInputView;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
