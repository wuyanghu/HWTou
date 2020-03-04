//
//  TopicWorkDetailModel.m
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicWorkDetailModel.h"

@implementation TopicWorkDetailModel

@end

@implementation MyTopicListModel

- (NSString *)content{
    return [self filterHTML:_content];
}

- (NSString *)filterHTML:(NSString *)html {
    
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    while([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

@end

@implementation TopicLabelListModel

- (id)initWithLabelId:(NSString *)labelId labelName:(NSString *)labelName{
    self = [super init];
    if (self) {
        _labelId = labelId;
        _labelName = labelName;
    }
    return self;
}
@end

@implementation TopicBannerListModel
@end
