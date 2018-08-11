//
//  NTESMessageModel.m
//  NIMLiveDemo
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMessageModel.h"
#import "M80AttributedLabel.h"
#import "NTESUserUtil.h"
#import "NTESLiveManager.h"
#import "NTESDataManager.h"
//#import "PublicHeader.h"

@implementation NTESMessageModel

- (void)caculate:(CGFloat)width
{
    if (self.message.messageType == NIMMessageTypeText) {
        CGRect rect = [self.message.text boundingRectWithSize:CGSizeMake(UIScreenWidth-120, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                                                      context:nil];
        self.height = rect.size.height+37+18+20;
    }else if (self.message.messageType == NIMMessageTypeImage){
        self.height = 110+37+18;
    }
    
}

- (NTESDataUser *)getDataUser{
    NTESDataUser * user = [[NTESDataManager sharedInstance] infoByUser:self.message.from withMessage:self.message];
    return user;
}

- (NSAttributedString *)formatMessage
{
    NSString *showMessage = [self showMessage];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:showMessage];
    
    NIMChatroom *room = [[NTESLiveManager sharedInstance] roomInfo:self.message.session.sessionId];
    
    BOOL isCreator = [room.creator isEqualToString:self.message.from];
    UIColor *nickColor = isCreator? UIColorFromRGB(0xfaec55) : UIColorFromRGB(0xc2ff9a);
    
    [text setAttributes:@{NSForegroundColorAttributeName:nickColor,NSFontAttributeName:Chatroom_Message_Font} range:self.nickRange];
    [text setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xffffff),NSFontAttributeName:Chatroom_Message_Font} range:self.textRange];

    
    return text;
}

- (NSRange)nickRange
{
    NSString *nickName = [NTESUserUtil showName:self.message.from withMessage:self.message];
    return NSMakeRange(0, nickName.length);
}

- (NSRange)textRange
{
    NSString *showMessage = [self showMessage];
    return NSMakeRange(showMessage.length - self.message.text.length, self.message.text.length);
}

- (NSString *)showMessage
{
    NSString *nickName = [NTESUserUtil showName:self.message.from withMessage:self.message];
    NSString *showMessage = [NSString stringWithFormat:@"%@  %@",nickName,self.message.text];
    return showMessage;
}

M80AttributedLabel *NTESCaculateLabel()
{
    static M80AttributedLabel *label;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [[M80AttributedLabel alloc] init];
        label.font = Chatroom_Message_Font;
        label.numberOfLines = 0;
        label.lineBreakMode = kCTLineBreakByCharWrapping;
    });
    return label;
}

@end
