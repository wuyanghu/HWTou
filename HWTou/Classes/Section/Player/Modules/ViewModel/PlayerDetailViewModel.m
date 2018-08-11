//
//  PlayerDetailViewModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerDetailViewModel.h"
#import "PublicHeader.h"
#import "ChatMusicListModel.h"

@implementation PlayerDetailViewModel
@synthesize priaseNum;

- (void)bindWithDic:(NSDictionary *)dic {
    if (![dic objectForKey:@"data"]) {
        return;
    }
    if ([[dic objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
        return;
    }
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    
    self.playingUrl = [BaseModel safeFromatWithString:[dataDic objectForKey:@"playingUrl"]];
    self.bmgs = [BaseModel safeFromatWithString:[dataDic objectForKey:@"bmgs"]];
    self.avater = [BaseModel safeFromatWithString:[dataDic objectForKey:@"avater"]];
    self.title = [BaseModel safeFromatWithString:[dataDic objectForKey:@"title"]];
    self.name = [BaseModel safeFromatWithString:[dataDic objectForKey:@"name"]];
    NSString *contentString = [BaseModel safeFromatWithString:[dataDic objectForKey:@"content"]];
    
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[contentString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.content = contentString;
//    self.contentAttributedText = attrStr;
    self.contentImg = [BaseModel safeFromatWithString:[dataDic objectForKey:@"contentImg"]];
    self.createTime = [BaseModel safeFromatWithString:[dataDic objectForKey:@"createTime"]];
    
    self.praiseNum = [[dataDic objectForKey:@"praiseNum"] intValue];
    self.lookNum = [[dataDic objectForKey:@"lookNum"] intValue];
    self.commentNum = [[dataDic objectForKey:@"commentNum"] intValue];
    self.giftNum = [[dataDic objectForKey:@"giftNum"] intValue];
    self.radioId = [[dataDic objectForKey:@"radioId"] intValue];
    self.rtcId = [[dataDic objectForKey:@"rtcId"] intValue];
    self.isCollected = [[dataDic objectForKey:@"isCollected"] intValue];
    
    self.createBy = [dataDic objectForKey:@"createBy"];
    self.labelNames = [dataDic objectForKey:@"labelNames"];
    self.chatDefNum = [[dataDic objectForKey:@"chatDefNum"] intValue];
    
    //1.将字符串转化为标准HTML字符串
    NSString *str1 = [self htmlEntityDecode:self.content];
    //2.将HTML字符串转换为attributeString
    self.htmlContent = [self attributedStringWithHTMLString:str1];
    
    [self.bmgsArr removeAllObjects];
    if ([self.bmgs containsString:@","]) {
        NSArray *arr = [self.bmgs componentsSeparatedByString:@","];
        for (int i=0; i<arr.count; i++) {
                [self.bmgsArr addObject:arr[i]];
        }
    }
    else {
        [self.bmgsArr addObject:self.bmgs];
    }
    
    [self.contentImgsArray removeAllObjects];
    if (![self.contentImg isEqualToString:@""]) {
        NSArray *imgsDataArr = [self.contentImg componentsSeparatedByString:@","];
        for (int i=0; i<imgsDataArr.count; i++) {
            [self.contentImgsArray addObject:imgsDataArr[i]];
        }
    }
    
    NSArray * chatArr = dataDic[@"chatMusicList"];
    for (NSDictionary * chatDict in chatArr) {
        ChatMusicListModel * chatModel = [ChatMusicListModel new];
        [chatModel setValuesForKeysWithDictionary:chatDict];
        
        [self.chatMusicListArray addObject:chatModel];
    }
    
    CGFloat height = [self.htmlContent boundingRectWithSize:CGSizeMake(kMainScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    NSInteger lines = 0;
    CGFloat imgHeight = (kMainScreenWidth - 50)/3.0;
    
    if (self.contentImgsArray.count % 3 == 0) {
        lines = self.contentImgsArray.count / 3;
    }
    else {
        lines = self.contentImgsArray.count / 3 + 1;
    }
    if (lines > 0) {
        self.imgsHeight = lines * imgHeight + (lines - 1) * 15;
    }
    else {
        self.imgsHeight = 0;
    }
    
    self.infoCellHeight = 161 + self.imgsHeight + height;
}

- (NSMutableArray *)bmgsArr {
    if (!_bmgsArr) {
        _bmgsArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _bmgsArr;
}

- (NSMutableArray *)contentImgsArray {
    if (!_contentImgsArray) {
        _contentImgsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _contentImgsArray;
}

- (NSMutableArray<ChatMusicListModel *> *)chatMusicListArray{
    if (!_chatMusicListArray) {
        _chatMusicListArray = [NSMutableArray array];
    }
    return _chatMusicListArray;
}

#pragma mark - 能量条逻辑
//增加能量条
- (void)addZanEnergy{
    if (priaseNum<6) {
//        NSLog(@"增加 priaseNum = %.2f",priaseNum);
        if (self.detailViewModelDelegate) {
            [self.detailViewModelDelegate modityViewState];
        }
        priaseNum++;
    }
}

//减少能量条
- (void)reduceZanEnergy{
    if (priaseNum>=0) {
//        NSLog(@"减少 priaseNum = %.2f",priaseNum);
        if (self.detailViewModelDelegate) {
            [self.detailViewModelDelegate modityViewState];
        }
        if (priaseNum != 0) {
            priaseNum -= 1;
        }
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self startTimer];
    }
    return self;
}

#pragma mark - 定时器

- (void)startTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reduceZanEnergy) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    if (timer && timer.isValid) {
        [timer invalidate];
        timer=nil;
    }
}

#pragma mark - HTMLContent

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}

@end
