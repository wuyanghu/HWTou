//
//  SpecalMusicView.m
//  HWTou
//
//  Created by robinson on 2018/3/21.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SpecalMusicView.h"
#import "UIView+NTES.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "HSDownloadManager.h"

@interface SpecalMusicView()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SpecalMusicView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop += self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)closeAction:(id)sender {
    [self dismiss];
}

- (void)buttonAction:(UIButton *)button{
    NSDictionary * dict =  _dataArr[button.tag];
    NSString * bmgurl = dict[@"bmgUrl"];
    
    HSDownloadManager * downloadManager = [HSDownloadManager sharedInstance];
    [downloadManager download:bmgurl progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        
    } state:^(DownloadState state) {
        [self callbackSelectMixAudio:[downloadManager getFilePath:bmgurl]];
    }];
    
}

- (void)callbackSelectMixAudio:(NSString *)bmgurl
{
    if ([self.specalDelegate respondsToSelector:@selector(didSelectMixAuido:sendVolume:playbackVolume:)]) {
        NSURL * url = [NSURL URLWithString:bmgurl];
        CGFloat volume = 1;
        [self.specalDelegate didSelectMixAuido:url sendVolume:volume playbackVolume:volume];
    }
}


- (void)setDataArr:(NSArray *)dataArr{
    if (_dataArr == nil) {
        self.scrollView.contentSize = CGSizeMake(85+dataArr.count*65, self.scrollView.ntesHeight);
        
        for (int i = 0;i<dataArr.count;i++) {
            NSDictionary * dict = dataArr[i];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(85+i*(64), 17, 44, 44);
            [button sd_setImageWithURL:dict[@"iconUrl"] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(button.ntesLeft, button.ntesBottom+11, 44, 14)];
            label.textColor = UIColorFromRGB(0x737373);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = dict[@"mName"];
            label.font = [UIFont systemFontOfSize:14];
            [self.scrollView addSubview:label];
        }
    }
    _dataArr = dataArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
