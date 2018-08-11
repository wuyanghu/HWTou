//
//  AudioPlayerInfoCell.m
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioPlayerInfoCell.h"
#import "PublicHeader.h"
#import "CopyLabel.h"
#import "DemoTextMenuConfig.h"
#import "LikeProgressView.h"

@interface AudioPlayerInfoCell ()<PlayerDetailViewModelDelegate>
{
    NSDate *nowDate;
}
@property (nonatomic, assign) int userId;

@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet CopyLabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *contentImgBGView;

@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *shangLab;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLab;

@property (weak, nonatomic) IBOutlet UILabel *zanLab;
@property (weak, nonatomic) IBOutlet UIImageView *zanIV;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;

@property (weak, nonatomic) IBOutlet LikeProgressView *energyBarView;
@property (weak, nonatomic) IBOutlet UIImageView *zanWarnImageView;

@property (nonatomic, strong) NSArray *imgsArr;//图片数组

@end

@implementation AudioPlayerInfoCell

+ (NSString *)cellReuseIdentifierInfo {
    return @"AudioPlayerInfoCell";
}

- (void)bind:(PlayerDetailViewModel *)viewModel isTopic:(BOOL)isTopic {
    _viewModel = viewModel;
    _viewModel.detailViewModelDelegate = self;
    self.imgsArr = viewModel.contentImgsArray;
    
    self.userId = [viewModel.createBy intValue];
    
    if (isTopic) {
        self.imgBtn.userInteractionEnabled = YES;
    }
    else {
        self.imgBtn.userInteractionEnabled = NO;
    }
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:viewModel.avater]];
    self.titleLab.text = viewModel.name;
    self.nameLab.text = viewModel.title;
    self.contentLab.attributedText = viewModel.htmlContent;
    
    self.contentImgBGView.frame = CGRectMake(10, viewModel.infoCellHeight - 40 - viewModel.imgsHeight, kMainScreenWidth - 20, viewModel.imgsHeight);
    for (UIView *vi in self.contentImgBGView.subviews) {
        [vi removeFromSuperview];
    }
    if (viewModel.contentImgsArray.count > 0) {
        self.contentImgBGView.hidden = NO;
        CGFloat imgHeight = (kMainScreenWidth - 50)/3.0;
        for (int i=0; i<viewModel.contentImgsArray.count; i++) {
            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.frame = CGRectMake((i%3)*(imgHeight+15), i/3*(imgHeight+15), imgHeight, imgHeight);
            imgBtn.tag = 1000 + i;
            [imgBtn addTarget:self action:@selector(contentImgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn sd_setImageWithURL:[NSURL URLWithString:[viewModel.contentImgsArray objectAtIndex:i]] forState:UIControlStateNormal];
            [self.contentImgBGView addSubview:imgBtn];
        }
    }
    else {
        self.contentImgBGView.hidden = YES;
    }
    
    self.detailLab.text = [NSString stringWithFormat:@"%@",viewModel.createTime];
    self.numLab.text = [NSString stringWithFormat:@"%d",viewModel.lookNum];
    self.shangLab.text = [NSString stringWithFormat:@"%d人赞赏",viewModel.giftNum];
    self.commentNumLab.text = [NSString stringWithFormat:@"%d条回复",viewModel.commentNum];
    self.zanLab.text = [NSString stringWithFormat:@"  %d     ",viewModel.praiseNum];
}
//刷新点赞数
- (void)refreshZanLab{
    self.zanLab.text = [NSString stringWithFormat:@"  %d     ",_viewModel.praiseNum];
}

- (IBAction)zanAction:(UIButton *)sender {
//    NSDate * newDate = [NSDate date];
//    NSTimeInterval value = [newDate timeIntervalSince1970] - [nowDate timeIntervalSince1970];
//    nowDate = newDate;
//    if (value<0.15) {
//        return;
//    }
    
    [self.viewModel addZanEnergy];
    if (self.viewModel.priaseNum>5) {
        return;
    }
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima.toValue = [NSNumber numberWithFloat:M_PI];
    [self.zanIV.layer addAnimation:anima forKey:@"transformAnimation"];
    
    if (self.delegate) {
        [self.delegate praiseChannelAction];
    }
}

- (IBAction)imgBtnAction:(id)sender {
    
    if (self.delegate) {
        [self.delegate imgBtnActionWithUserId:self.userId];
    }
}

- (void)contentImgBtnAction:(UIButton *)btn {
    if (self.delegate) {
        [self.delegate contentImgBtnAction:self.imgsArr index:btn.tag - 1000];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 能量条逻辑

- (void)modityViewState{
    if (self.viewModel.priaseNum>5) {
        self.zanWarnImageView.hidden = NO;
        self.zanWarnImageView.alpha = 0.8;
    }else{
        self.zanWarnImageView.hidden = YES;
    }
    
    self.energyBarView.progress = self.viewModel.priaseNum/6.0f;
}

@end
