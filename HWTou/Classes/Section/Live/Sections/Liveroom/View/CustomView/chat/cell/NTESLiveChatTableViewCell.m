//
//  NTESLiveChatTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/3/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "NTESLiveChatTableViewCell.h"
#import "NTESDataManager.h"
#import "PublicHeader.h"
#import "PYPhotoBrowser.h"
#import "UIView+NTES.h"

@interface NTESLiveChatTableViewCell()
{
    UILongPressGestureRecognizer *_longPressGesture;
    NTESMessageModel * messageModel;
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBtnImageViewWidth;

@end

@implementation NTESLiveChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self addGestureRecognizer:tap];
    
    _longPressGesture= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePress:)];
    [self addGestureRecognizer:_longPressGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)refresh:(NTESMessageModel *)model
{
    messageModel = model;
    NTESDataUser * user = [messageModel getDataUser];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrlString] placeholderImage:user.avatarImage];
    self.nickLabel.text = user.showName;
    
    
    BOOL isText = messageModel.message.messageType == NIMMessageTypeText;
    BOOL isImage = messageModel.message.messageType == NIMMessageTypeImage;
    self.textView.hidden = !isText;
    self.contentLabel.hidden = !isText;
    self.contentImageView.hidden = !isImage;
    if (isText) {
        self.contentLabel.text = model.message.text;
    }else if(isImage){
        if (model.message && model.message.attachmentDownloadState == NIMMessageAttachmentDownloadStateNeedDownload) {
            [[NIMSDK sharedSDK].chatManager fetchMessageAttachment:model.message error:nil];
        }
        
        NIMImageObject * imageObject = (NIMImageObject*)model.message.messageObject;
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:imageObject.url] placeholderImage:[UIImage imageNamed:imageObject.path]];
        
        self.contentImageViewWidth.constant = 110*imageObject.size.width/imageObject.size.height;
        self.contentBtnImageViewWidth.constant = self.contentImageViewWidth.constant;
        NSLog(@"%.f-%.f",imageObject.size.width,imageObject.size.height);
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (IBAction)headerClickAction:(id)sender {
    [_cellDelegate headerAction:messageModel];
}

- (void)longGesturePress:(UIGestureRecognizer *)gestureRecognizer{
    [_cellDelegate longGesturePress:messageModel];
}

- (void)doTap:(UITapGestureRecognizer*)recognizer{
    [_cellDelegate doTap:recognizer];
}

- (IBAction)bigImageAction:(id)sender {
    BOOL isImage = messageModel.message.messageType == NIMMessageTypeImage;
    if (isImage && _contentImageView.image) {
        [self lookBigPict:@[_contentImageView] index:0];
    }
}

- (void)lookBigPict:(NSArray *)imgArray index:(NSInteger)index{
    if (!IsArrEmpty(imgArray)) {
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
        [photoBroseView setShowDuration:0.f];
        [photoBroseView setHiddenDuration:0.f];
        
        [photoBroseView setSourceImgageViews:imgArray];// 2.1 设置图片源(UIImageView)数组
        [photoBroseView setCurrentIndex:index];// 2.2 设置初始化图片下标（即当前点击第几张图片）
        [photoBroseView show];// 3.显示(浏览)
        
    }
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"NTESLiveChatTableViewCell";
}

@end
