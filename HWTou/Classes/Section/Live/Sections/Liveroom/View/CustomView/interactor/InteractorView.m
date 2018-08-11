//
//  Interactor.m
//  HWTou
//
//  Created by robinson on 2018/3/21.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "InteractorView.h"
#import "UIView+NTES.h"
#import "InteractorTableViewCell.h"
#import "BasisUITool.h"
#import "NTESMicConnector.h"
#import "UIView+Toast.h"

@interface InteractorView()<UITableViewDataSource,UITableViewDelegate,InteractorTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (nonatomic,strong) NSArray<NTESMicConnector *> * queue;
@property (nonatomic,strong) NSArray * dataArray;
@end

@implementation InteractorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView registerNib:[UINib nibWithNibName:@"InteractorTableViewCell" bundle:nil]
     forCellReuseIdentifier:[InteractorTableViewCell cellReuseIdentifierInfo]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop -= self.ntesHeight;
    }];
    
    if (self.switchBtn.isOn) {
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop += self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    

}

#pragma mark - 
- (void)refreshWithQueue:(NSArray<NTESMicConnector *> *)queue isNotice:(BOOL)isNotice
{
    if (isNotice) {
        if (self.switchBtn.isOn) {
            [_interactorDelegate newInteractMsg];
        }
    }
    
    _queue = queue;
    [self.tableView reloadData];
}

#pragma mark - action

- (IBAction)openInteractorAction:(id)sender {
    [self.switchBtn setOn:YES animated:YES];
    self.tableView.hidden = NO;
    [_interactorDelegate openOrCloseInteractor:onType];
}

- (IBAction)closeAction:(id)sender {
    self.tableView.hidden = YES;
    [self dismiss];
}

- (IBAction)switchAction:(id)sender {
    UISwitch * switchBtn = sender;
    if (switchBtn.isOn) {
        self.tableView.hidden = NO;
        [_interactorDelegate openOrCloseInteractor:onType];
    }else{
        self.tableView.hidden = YES;
        [_interactorDelegate openOrCloseInteractor:offType];
    }
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _queue.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InteractorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[InteractorTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.cellDelegate = self;
    NTESMicConnector * micConnector = _queue[indexPath.row];
    cell.micConnector = micConnector;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - InteractorTableViewCellDelegate
- (void)muteAction:(NTESMicConnector *)micConnector flag:(NSInteger)flag{
    // flag 1 静音
    [[NIMAVChatSDK sharedSDK].netCallManager setAudioMute:flag==1 forUser:micConnector.uid];
}

- (void)connectAction:(NTESMicConnector *)micConnector flag:(NSInteger)flag{
    if (flag == 1) {//接通
        [self.interactorDelegate onSelectMicConnector:micConnector];
    }else{//挂断
        [self.interactorDelegate onCloseBypassing];
    }
}

@end
