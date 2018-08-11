//
//  AddSetMusicView.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AddSetMusicView.h"
#import "UIView+NTES.h"
#import "RotRequest.h"
#import "BasisUITool.h"
#import "MyMusicTableViewCell.h"
#import "NTESLiveUtil.h"
#import "HSDownloadManager.h"

@interface AddSetMusicView()<UITableViewDataSource,UITableViewDelegate,MyMusicTableViewCellDelegate,NIMNetCallManagerDelegate>
@property (nonatomic,strong) NSArray * dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *rightAddMusicBtn;
@property (weak, nonatomic) IBOutlet UIButton *palyOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *loopPlayBtn;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (nonatomic,assign) NSInteger currentPlay;
@end

@implementation AddSetMusicView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.palyOrPauseBtn setImage:[UIImage imageNamed:@"zb_btn_tczt"] forState:UIControlStateSelected];
    [self.loopPlayBtn setImage:[UIImage imageNamed:@"zb_btn_sjbf"] forState:UIControlStateSelected];
    
    [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyMusicTableViewCell" bundle:nil]
     forCellReuseIdentifier:[MyMusicTableViewCell cellReuseIdentifierInfo]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"hd"] forState:UIControlStateNormal];
}

- (void)dealloc
{
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}

#pragma mark - NIMNetCallManagerDelegate

- (void)onAudioMixTaskCompleted{
    NSLog(@"完成");
    if (self.loopPlayBtn.selected) {
        
    }else{
        _currentPlay = (_currentPlay+1)%self.dataArray.count;
    }
    [self callbackSelectMixAudio];
}

#pragma mark - action
- (IBAction)addSetMusicAction:(id)sender {
    if (_addDelegate) {
        [_addDelegate addSetMusicAction];
    }
}

- (IBAction)removeSelfViewAction:(id)sender {
    [self dismiss];
}

- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (IBAction)changeVolumeAction:(id)sender {
    [self callbackUpdateMixAudio];
}


- (IBAction)playOrPasueAction:(id)sender {
    self.palyOrPauseBtn.selected = !self.palyOrPauseBtn.selected;
    if (self.palyOrPauseBtn.selected) {
        NSLog(@"播放");
        [self callbackResumeMixAudio];
    }else{
        NSLog(@"暂停");
        [self callbackPauseMixAudio];
    }
    
}

- (IBAction)loopPlayBtn:(id)sender {
    self.loopPlayBtn.selected = !self.loopPlayBtn.selected;
    if(self.loopPlayBtn.selected){
        NSLog(@"单曲循环");
    }else{
        NSLog(@"全部循环");
    }
}

- (void)show
{
    if (self.ntesTop == self.ntesHeight) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.ntesTop -= self.ntesHeight;
        }];
        
        if (self.dataArray.count > 0) {
            self.rightAddMusicBtn.hidden = NO;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else{
            self.rightAddMusicBtn.hidden = YES;
            self.tableView.hidden = YES;
        }
    }
}

- (void)dismiss
{
    if (self.ntesTop == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.ntesTop += self.ntesHeight;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - AddSetMusicViewDelegate

- (void)callbackSelectMixAudio
{
    NSDictionary * item = self.dataArray[_currentPlay];
    NSString * bmgUrl = [[HSDownloadManager sharedInstance] getFilePath:item[@"bmgUrl"]];
    
    if ([self.addDelegate respondsToSelector:@selector(didSelectMixAuido:sendVolume:playbackVolume:)]) {
        NSURL * url = [NSURL URLWithString:bmgUrl];
        CGFloat volume = self.volumeSlider.value;
        [self.addDelegate didSelectMixAuido:url sendVolume:volume playbackVolume:volume];
    }
}

- (void)callbackPauseMixAudio
{
    if ([self.addDelegate respondsToSelector:@selector(didPauseMixAudio)]) {
        [self.addDelegate didPauseMixAudio];
    }
}

- (void)callbackResumeMixAudio
{
    if ([self.addDelegate respondsToSelector:@selector(didResumeMixAudio)]) {
        [self.addDelegate didResumeMixAudio];
    }
}

- (void)callbackUpdateMixAudio
{
    if ([self.addDelegate respondsToSelector:@selector(didUpdateMixAuido:playbackVolume:)]) {
        CGFloat volume = self.volumeSlider.value;
        [self.addDelegate didUpdateMixAuido:volume playbackVolume:volume];
    }
}

#pragma mark - MyMusicTableViewCellDelegate

- (void)delMusicAction{
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMusicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[MyMusicTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.cellDelegate = self;
    NSDictionary * item = self.dataArray[indexPath.row];
    cell.itemDict = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.palyOrPauseBtn.selected = YES;
    _currentPlay = indexPath.row;
    [self callbackSelectMixAudio];
}

- (NSArray *)dataArray{
    _dataArray = [NTESLiveUtil getAllLiveMusic].allValues;
    return _dataArray;
}

@end
