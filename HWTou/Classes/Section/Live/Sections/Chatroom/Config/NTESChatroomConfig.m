//
//  NTESChatroomConfig.m
//  NIM
//
//  Created by chris on 15/12/14.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESChatroomConfig.h"
#import "NTESChatroomMessageDataProvider.h"
#import "NTESBundleSetting.h"
#import "NSString+NTES.h"

@interface NTESChatroomConfig()

@property (nonatomic,strong) NTESChatroomMessageDataProvider *provider;

@end

@implementation NTESChatroomConfig

- (instancetype)initWithChatroom:(NSString *)roomId{
    self = [super init];
    if (self) {
        self.provider = [[NTESChatroomMessageDataProvider alloc] initWithChatroom:roomId];
    }
    return self;
}

- (id<NIMKitMessageProvider>)messageDataProvider{
    return self.provider;
}


- (NSArray<NSNumber *> *)inputBarItemTypes{
    return @[
             @(NIMInputBarItemTypeVoice),
               @(NIMInputBarItemTypeTextAndRecord),
               @(NIMInputBarItemTypeEmoticon),
               @(NIMInputBarItemTypeMore)
            ];
}


- (NSArray *)mediaItems
{
    NIMMediaItem *yy = [NIMMediaItem item:@"onTapMediaItemYY:"
                                     normalImage:[UIImage imageNamed:@"tc_btn_yy"]
                                   selectedImage:[UIImage imageNamed:@"tc_btn_yy"]
                                           title:@"语音"];
    
    NIMMediaItem *tp = [NIMMediaItem item:@"onTapMediaItemPicture:"
                                     normalImage:[UIImage imageNamed:@"tc_btn_tp"]
                                   selectedImage:[UIImage imageNamed:@"tc_btn_tp"]
                                           title:@"图片"];
    
    NIMMediaItem *sp       = [NIMMediaItem item:@"onTapMediaItemShoot:"
                                     normalImage:[UIImage imageNamed:@"tc_btn_sp"]
                                   selectedImage:[UIImage imageNamed:@"tc_btn_sp"]
                                           title:@"视频"];
    
    NIMMediaItem *wz =  [NIMMediaItem item:@"onTapMediaItemLocation:"
                                      normalImage:[UIImage imageNamed:@"tc_btn_wz"]
                                    selectedImage:[UIImage imageNamed:@"tc_btn_wz"]
                                            title:@"位置"];
    
    NIMMediaItem *sc =  [NIMMediaItem item:@"onTapMediaItemCollection:"
                                      normalImage:[UIImage imageNamed:@"tc_btn_sc"]
                                    selectedImage:[UIImage imageNamed:@"tc_btn_sc"]
                                            title:@"收藏"];
    
    NIMMediaItem *lm =  [NIMMediaItem item:@"onTapMediaItemLM:"
                                        normalImage:[UIImage imageNamed:@"tc_btn_lm"]
                                      selectedImage:[UIImage imageNamed:@"tc_btn_lm"]
                                              title:@"连麦"];
    
    return @[yy,tp,sp,wz,sc,lm];
}

- (BOOL)shouldHandleReceiptForMessage:(NIMMessage *)message
{
    //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
    NIMMessageType type = message.messageType;

    return type == NIMMessageTypeText ||
    type == NIMMessageTypeAudio ||
    type == NIMMessageTypeImage ||
    type == NIMMessageTypeVideo ||
    type == NIMMessageTypeFile ||
    type == NIMMessageTypeLocation ||
    type == NIMMessageTypeCustom;
}

- (NSArray<NIMInputEmoticonCatalog *> *)charlets{
    return [self loadChartletEmoticonCatalog];
}

- (BOOL)autoFetchWhenOpenSession
{
    return NO;
}

- (BOOL)shouldHandleReceipt
{
    return NO;
}

- (BOOL)disableProximityMonitor{
    return [[NTESBundleSetting sharedConfig] disableProximityMonitor];
}

- (NIMAudioType)recordType
{
    return [[NTESBundleSetting sharedConfig] usingAmr] ? NIMAudioTypeAMR : NIMAudioTypeAAC;
}

- (NSArray *)loadChartletEmoticonCatalog{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"NIMDemoChartlet.bundle"
                                         withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    NSArray  *paths   = [bundle pathsForResourcesOfType:nil inDirectory:@""];
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (NSString *path in paths) {
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            NIMInputEmoticonCatalog *catalog = [[NIMInputEmoticonCatalog alloc]init];
            catalog.catalogID = path.lastPathComponent;
            NSArray *resources = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:@"content"]];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSString *path in resources) {
                NSString *name  = path.lastPathComponent.stringByDeletingPathExtension;
                NIMInputEmoticon *icon  = [[NIMInputEmoticon alloc] init];
                icon.emoticonID = name.stringByDeletingPictureResolution;
                icon.filename   = path;
                [array addObject:icon];
            }
            catalog.emoticons = array;
            
            NSArray *icons     = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:@"icon"]];
            for (NSString *path in icons) {
                NSString *name  = path.lastPathComponent.stringByDeletingPathExtension.stringByDeletingPictureResolution;
                if ([name hasSuffix:@"normal"]) {
                    catalog.icon = path;
                }else if([name hasSuffix:@"highlighted"]){
                    catalog.iconPressed = path;
                }
            }
            [res addObject:catalog];
        }
    }
    return res;
}

@end
