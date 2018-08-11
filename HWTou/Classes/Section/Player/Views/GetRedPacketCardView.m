//
//  GetRedPacketCardView.m
//  HWTou
//
//  Created by Reyna on 2018/3/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "GetRedPacketCardView.h"
#import "PublicHeader.h"
#import "UIControl+Event.h"
#import "GetRedPacketViewModel.h"
#import "RedPacketRequest.h"
#import "RedPacketInfoListCell.h"

@interface GetRedPacketCardView () <UITableViewDataSource, UITableViewDelegate> {
    
    CGFloat VIEW_WIDTH;
    CGFloat VIEW_HEIGHT;
    CGFloat VIEW_HEIGHT_S;
    
    CGFloat LIST_WIDTH;
    CGFloat LIST_HEIGHT;
    
    UIButton *segTwo;
}

@property (nonatomic, strong) UIControl *backImageView;
@property (nonatomic, strong) GetRedPacketViewModel *redPacketVM;
@property (nonatomic, strong) PlayerCommentModel *model;
@property (nonatomic, assign) int rtcId;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *listView;

@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UILabel *infoLab;

@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel *flhbLab;

@property (nonatomic, strong) UILabel *gxnLab;
@property (nonatomic, strong) UILabel *hdLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *frzhLab;

@end

@implementation GetRedPacketCardView

- (instancetype)initWithModel:(PlayerCommentModel *)model rtcId:(int)rtcId {
    if (self = [super init]) {
        
        _model = model;
        _rtcId = rtcId;
        
        VIEW_WIDTH = kMainScreenWidth;
        VIEW_HEIGHT = VIEW_WIDTH * (924/811.0);
        VIEW_HEIGHT_S = VIEW_WIDTH * (897/791.0);
        
        LIST_WIDTH = kMainScreenWidth - 20;
        LIST_HEIGHT = LIST_WIDTH * (449/356.0);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    [self addSubview:_backgroundView];
    
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    _bgView.userInteractionEnabled = YES;
    [_backgroundView addSubview:_bgView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(55, 30, 40, 40);
    [cancelBtn setImage:[UIImage imageNamed:@"wallet_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(exitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:cancelBtn];
    
    
    CGFloat g_t = 58/449.0 * VIEW_HEIGHT_S;
    _gxnLab = [[UILabel alloc]initWithFrame:CGRectMake(30, g_t, VIEW_WIDTH - 60, 24)];
    _gxnLab.text = @"恭喜您";
    _gxnLab.textAlignment = NSTextAlignmentCenter;
    _gxnLab.font = SYSTEM_FONT(24);
    _gxnLab.textColor = UIColorFromHex(0xFFFAF1);
    [_bgView addSubview:_gxnLab];
    
    CGFloat hd_t = 86/449.0 * VIEW_HEIGHT_S;
    _hdLab = [[UILabel alloc]initWithFrame:CGRectMake(30, hd_t, VIEW_WIDTH - 60, 18)];
    _hdLab.text = @"获得";
    _hdLab.textAlignment = NSTextAlignmentCenter;
    _hdLab.font = SYSTEM_FONT(18);
    _hdLab.textColor = UIColorFromHex(0xFFCB70);
    [_bgView addSubview:_hdLab];
    
    CGFloat head_t = 50/462.0 * VIEW_HEIGHT;
    CGFloat head_w = VIEW_WIDTH/406.0 * 72;
    CGFloat head_l = (VIEW_WIDTH - head_w)*322/666.0;
    _headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(head_l, head_t, head_w, head_w)];
    [_headerIV sd_setImageWithURL:[NSURL URLWithString:self.model.avater]];
    _headerIV.layer.cornerRadius = head_w/2.0;
    _headerIV.layer.masksToBounds = YES;
    [_bgView addSubview:_headerIV];
    
    CGFloat n_t = 132/462.0 * VIEW_HEIGHT;
    _nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(head_l - 50, n_t, head_w + 100, 14)];
    _nickNameLab.text = self.model.nickName;
    _nickNameLab.textAlignment = NSTextAlignmentCenter;
    _nickNameLab.font = SYSTEM_FONT(14);
    _nickNameLab.textColor = UIColorFromHex(0xffcb70);
    [_bgView addSubview:_nickNameLab];
    
    CGFloat r_t = 152/462.0 * VIEW_HEIGHT;
    _flhbLab = [[UILabel alloc]initWithFrame:CGRectMake(head_l - 50, r_t, head_w + 100, 9)];
    _flhbLab.text = @"发了一个红包";
    _flhbLab.textAlignment = NSTextAlignmentCenter;
    _flhbLab.font = SYSTEM_FONT(9);
    _flhbLab.textColor = UIColorFromHex(0xffcb70);
    [_bgView addSubview:_flhbLab];
    
    CGFloat i_t = 189/462.0 * VIEW_HEIGHT;
    _infoLab = [[UILabel alloc]initWithFrame:CGRectMake(30, i_t, VIEW_WIDTH - 60, 24)];
    _infoLab.text = @"手慢了，红包派完了～";
    _infoLab.textAlignment = NSTextAlignmentCenter;
    _infoLab.font = SYSTEM_FONT(24);
    _infoLab.textColor = UIColorFromHex(0xffcb70);
    [_bgView addSubview:_infoLab];
    
    CGFloat o_t = 388/924.0 * VIEW_HEIGHT;
    CGFloat o_w = VIEW_WIDTH/406.0 * 108;
    CGFloat o_l = (VIEW_WIDTH - o_w)*288/594.0;
    _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _openBtn.frame = CGRectMake(o_l, o_t, o_w, o_w);
    _openBtn.backgroundColor = UIColorFromHex(0xFFCB70);
    [_openBtn setTitle:@"開" forState:UIControlStateNormal];
    [_openBtn.titleLabel setFont:SYSTEM_FONT(60)];
    [_openBtn setTitleColor:UIColorFromHex(0xE84D4A) forState:UIControlStateNormal];
    _openBtn.layer.cornerRadius = o_w/2.0;
    _openBtn.layer.masksToBounds = YES;
    [_openBtn addTarget:self action:@selector(openBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_openBtn];
    
    CGFloat p_t = 177/449.0 * VIEW_HEIGHT_S;
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(30, p_t, VIEW_WIDTH - 60, 70)];
    _priceLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_priceLab];
    
    CGFloat fr_t = 171/449.0 * VIEW_HEIGHT_S;
    _frzhLab = [[UILabel alloc]initWithFrame:CGRectMake(30, VIEW_HEIGHT_S - fr_t, VIEW_WIDTH - 60, 15)];
    _frzhLab.text = @"已放入您的个人账户";
    _frzhLab.textAlignment = NSTextAlignmentCenter;
    _frzhLab.font = SYSTEM_FONT(15);
    _frzhLab.textColor = UIColorFromHex(0xFFCB70);
    [_bgView addSubview:_frzhLab];
    
    CGFloat d_h = 145/462.0 * VIEW_HEIGHT;
    UIButton *segOne = [UIButton buttonWithType:UIButtonTypeCustom];
    segOne.frame = CGRectMake((VIEW_WIDTH - 166)/2.0, VIEW_HEIGHT - d_h, 166, 40);
    [segOne setTitle:@"看看大家的手气" forState:UIControlStateNormal];
    segOne.backgroundColor = UIColorFromHex(0xffc61d);
    segOne.layer.cornerRadius = 20.f;
    [segOne addTarget:self action:@selector(lookOtherAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:segOne];

    
    if (self.model.redState == 0) {
        //未领取
        _bgView.image = [UIImage imageNamed:@"big wallet"];
        _openBtn.hidden = NO;
        _infoLab.hidden = YES;
        [self hiddenFLHB:NO];
        [self hiddenPrice:YES];
    }
    else if (self.model.redState == 1) {
        //已领完
        _bgView.image = [UIImage imageNamed:@"bigwallet3"];
        _openBtn.hidden = YES;
        _infoLab.hidden = NO;
        [self hiddenFLHB:NO];
        [self hiddenPrice:YES];
    }
    else if (self.model.redState == 2) {
        //已领取
        _bgView.image = [UIImage imageNamed:@"bigwallet2"];
        _bgView.frame = CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT_S);
        _openBtn.hidden = YES;
        _infoLab.hidden = YES;
        [self hiddenFLHB:YES];
        [self hiddenPrice:NO];

        [self redPacketRequest];
    }
    else {
        //已过期
        _bgView.image = [UIImage imageNamed:@"bigwallet3"];
        _openBtn.hidden = YES;
        _infoLab.hidden = NO;
        [self hiddenFLHB:NO];
        [self hiddenPrice:YES];
    }
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
}

#pragma mark - Request

- (void)redPacketRequest {
    
    [RedPacketRequest consumeRedEnvelopesWithRedRId:self.model.commentText rtcId:self.rtcId success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            if (self.refreshBlock) {
                self.refreshBlock();
            }
            [self.redPacketVM bindWithDic:[response objectForKey:@"data"]];
            [self refreshUIWithVMData];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - BtnClickBlock

- (void)exitBtnAction:(UIButton *)btn {
    [self dismiss];
}

- (void)lookOtherAction:(UIButton *)btn {
    
    if (!_redPacketVM) {
        [RedPacketRequest consumeRedEnvelopesWithRedRId:self.model.commentText rtcId:self.rtcId success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                
                [self.redPacketVM bindWithDic:[response objectForKey:@"data"]];
                [self refreshUIToInfoLists];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else {
        [self refreshUIToInfoLists];
    }
    
}

- (void)openBtnAction:(UIButton *)btn {
    
    [self redPacketRequest];
}

- (void)refreshUIToInfoLists {
    
    _bgView.hidden = YES;
    
    if (_listView) {
        for (UIView *vi in _listView.subviews) {
            [vi removeFromSuperview];
        }
    }else {
        _listView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, LIST_WIDTH, LIST_HEIGHT)];
        _listView.image = [UIImage imageNamed:@"bigwallet4"];
        _listView.userInteractionEnabled = YES;
        [_backgroundView addSubview:_listView];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(40, 24, 40, 40);
    [cancelBtn setImage:[UIImage imageNamed:@"wallet_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(exitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_listView addSubview:cancelBtn];
    
    CGFloat head_t = 160/898.0 * LIST_HEIGHT;
    CGFloat head_w = LIST_WIDTH/356.0 * 72;
    CGFloat head_l = (LIST_WIDTH - head_w)/2.0;
    UIImageView *headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(head_l, head_t, head_w, head_w)];
    [headerIV sd_setImageWithURL:[NSURL URLWithString:self.model.avater]];
    headerIV.layer.cornerRadius = head_w/2.0;
    headerIV.layer.masksToBounds = YES;
    [_listView addSubview:headerIV];
    
    CGFloat i_h = 155/449.0 * LIST_HEIGHT;
    UILabel *nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(30, i_h, LIST_WIDTH - 60, 14)];
    nickNameLab.text = self.redPacketVM.nickName;
    nickNameLab.textAlignment = NSTextAlignmentCenter;
    nickNameLab.font = SYSTEM_FONT(14);
    nickNameLab.textColor = UIColorFromHex(0xffcb70);
    [_listView addSubview:nickNameLab];
    
    CGFloat i_h2 = 176/449.0 * LIST_HEIGHT;
    UILabel *redLab = [[UILabel alloc]initWithFrame:CGRectMake(30, i_h2, LIST_WIDTH - 60, 9)];
    redLab.text = @"看看大家的手气";
    redLab.textAlignment = NSTextAlignmentCenter;
    redLab.font = SYSTEM_FONT(9);
    redLab.textColor = UIColorFromHex(0xffcb70);
    [_listView addSubview:redLab];
    
    CGFloat t_x = 30/356.0 * LIST_WIDTH;
    CGFloat t_yt = 210/449.0 * LIST_HEIGHT;
    CGFloat t_yb = 60/449.0 * LIST_HEIGHT;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(t_x, t_yt, LIST_WIDTH - 2*t_x, LIST_HEIGHT - t_yt - t_yb) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:@"RedPacketInfoListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[RedPacketInfoListCell cellReuseIdentifierInfo]];
    [_listView addSubview:tableView];
}

- (void)refreshUIWithVMData {
    
    if (self.model.redState == self.redPacketVM.redState) {
        
        if (self.redPacketVM.redState == 2) {
            //已领取
            _bgView.image = [UIImage imageNamed:@"bigwallet2"];
            _infoLab.hidden = YES;
            _priceLab.hidden = NO;
            NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",self.redPacketVM.getRedMoney]];
            [s addAttribute:NSFontAttributeName value:SYSTEM_FONT(70) range:NSMakeRange(0, self.redPacketVM.getRedMoney.length)];
            [s addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xffebc8) range:NSMakeRange(0, self.redPacketVM.getRedMoney.length + 1)];
            [_priceLab setAttributedText:s];
        }
    }
    else {
        
        if (self.redPacketVM.redState == 1) {
            //抢完了
            _bgView.image = [UIImage imageNamed:@"bigwallet3"];
            _openBtn.hidden = YES;
            _infoLab.hidden = NO;
            [self hiddenFLHB:NO];
            [self hiddenPrice:YES];
        }
        else if (self.redPacketVM.redState == 2) {
            //已领取
            _bgView.image = [UIImage imageNamed:@"bigwallet2"];
            _bgView.frame = CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT_S);
            _openBtn.hidden = YES;
            _infoLab.hidden = YES;
            [self hiddenFLHB:YES];
            [self hiddenPrice:NO];
            
            NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",self.redPacketVM.getRedMoney]];
            [s addAttribute:NSFontAttributeName value:SYSTEM_FONT(70) range:NSMakeRange(0, self.redPacketVM.getRedMoney.length)];
            [s addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xffebc8) range:NSMakeRange(0, self.redPacketVM.getRedMoney.length + 1)];
            [_priceLab setAttributedText:s];
        }
        else {
            //已过期
            _bgView.image = [UIImage imageNamed:@"bigwallet3"];
            _openBtn.hidden = YES;
            _infoLab.hidden = NO;
            [self hiddenFLHB:NO];
            [self hiddenPrice:YES];
        }
    }
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _redPacketVM.redLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RedPacketInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:[RedPacketInfoListCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    GetRedPacketDetailModel *m = [self.redPacketVM.redLists objectAtIndex:indexPath.row];
    [cell bind:m];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

#pragma mark - GET

- (GetRedPacketViewModel *)redPacketVM {
    if (!_redPacketVM) {
        _redPacketVM = [[GetRedPacketViewModel alloc] init];
    }
    return _redPacketVM;
}

#pragma mark - Custom

- (void)hiddenPrice:(BOOL)isHidden {
    
    _gxnLab.hidden = isHidden;
    _hdLab.hidden = isHidden;
    _priceLab.hidden = isHidden;
    _frzhLab.hidden = isHidden;
}

- (void)hiddenFLHB:(BOOL)isHidden {
    
    _headerIV.hidden = isHidden;
    _nickNameLab.hidden = isHidden;
    _flhbLab.hidden = isHidden;
}

- (void)show {
    
    UIViewController *topVC = [self appRootViewController];
    
    topVC.view.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT) * 0.5 + kMainScreenHeight, VIEW_WIDTH, VIEW_HEIGHT);
    
    [topVC.view addSubview:self];
}

- (void)dismiss {
    
    [self removeFromSuperview];
}

- (UIViewController *)appRootViewController {
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)removeFromSuperview {
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, kMainScreenHeight + (kMainScreenHeight - VIEW_HEIGHT) * 0.5, VIEW_WIDTH, VIEW_HEIGHT);
    
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        
        [self.backImageView removeFromSuperview];
        self.backImageView = nil;
    }];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIControl alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        __weak typeof(self) weakSelf = self;
        [self.backImageView addEvent:UIControlEventTouchDown callback:^{
            [weakSelf dismiss];
        }];
    }
    [topVC.view addSubview:self.backImageView];
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT) * 0.5, VIEW_WIDTH, VIEW_HEIGHT);
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
    
    
    [super willMoveToSuperview:newSuperview];
}

@end
