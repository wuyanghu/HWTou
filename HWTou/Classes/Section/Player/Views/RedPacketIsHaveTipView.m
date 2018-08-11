//
//  RedPacketIsHaveTipView.m
//  HWTou
//
//  Created by Reyna on 2018/3/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "RedPacketIsHaveTipView.h"
#import "RedPacketRequest.h"
#import "PublicHeader.h"

@interface RedPacketIsHaveTipView () {
    
    NSString *_redRId;
    NSString *_nickName;
    NSString *_avater;
}

@property (nonatomic, strong) UIButton *tipBtn;
@property (nonatomic, strong) UILabel *qiangLab;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation RedPacketIsHaveTipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tipBtn.frame = CGRectMake(0, 0, 156, 159);
    [_tipBtn setBackgroundImage:[UIImage imageNamed:@"list_tip_isHaveRed"] forState:UIControlStateNormal];
    [_tipBtn addTarget:self action:@selector(tipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tipBtn];
    
    _qiangLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 90, 80, 15)];
    _qiangLab.text = @"抢红包";
    _qiangLab.textColor = [UIColor whiteColor];
    _qiangLab.textAlignment = NSTextAlignmentCenter;
    _qiangLab.font = SYSTEM_FONT(14);
    [self addSubview:_qiangLab];
    
    self.hidden = YES;
}

#pragma mark - Api

- (void)startLookingForRedPacket {
    
    [self stopLookingForRedPacket];
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(lookingForRedPacket) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)fireLookingForRedPacket {
    
    if (_timer) {
        [_timer fire];
    }
    else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(lookingForRedPacket) userInfo:nil repeats:YES];
        [_timer fire];
    }
}

- (void)stopLookingForRedPacket {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Action

- (void)tipBtnAction:(UIButton *)btn {
    
    if (_delegate) {
        [_delegate tipBtnActionWithRedRId:_redRId nickName:_nickName avater:_avater];
    }
}

#pragma mark - RedPacketRequest

- (void)lookingForRedPacket {
    
    [RedPacketRequest getIsGetRedWithRtcId:self.rtcId success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            NSString *redRId = [[response objectForKey:@"data"] objectForKey:@"redRId"];
            
            _redRId = [[response objectForKey:@"data"] objectForKey:@"redRId"];
            _nickName = [[response objectForKey:@"data"] objectForKey:@"nickName"];
            _avater = [[response objectForKey:@"data"] objectForKey:@"avater"];
            
            if ([redRId isEqualToString:@""]) {
                
                self.hidden = YES;
            }
            else {
                
                int state = [[[response objectForKey:@"data"] objectForKey:@"state"] intValue];
                if (state == 0) {
                    self.hidden = NO;
                }
                else {
                    self.hidden = YES;
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
