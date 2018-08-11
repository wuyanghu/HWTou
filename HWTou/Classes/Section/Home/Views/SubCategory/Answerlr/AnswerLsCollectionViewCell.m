//
//  AnswerLsCollectionViewCell.m
//  HWTou
//
//  Created by robinson on 2018/1/29.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnswerLsCollectionViewCell.h"
#import "PublicHeader.h"
#import "GetSpecListModel.h"

@interface AnswerLsCollectionViewCell()

@end

@implementation AnswerLsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)cellIdentity{
    return @"AnswerLsCollectionViewCell";
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    CGRect frame = CGRectMake(0, 0, 160, 105);
    for (int i = 0; i<dataArray.count; i++) {
        GetSpecListModel * specModel = dataArray[i];
        
        UIButton * button = [[UIButton alloc] init];
        button.tag = specModel.specId;
        [button sd_setImageWithURL:[NSURL URLWithString:specModel.coverUrl] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = frame;
        [self.bgScrollView addSubview:button];
        frame.origin.x = button.frame.origin.x+button.frame.size.width+10;
    }
    [self.bgScrollView setContentSize:CGSizeMake((frame.size.width+10)*_dataArray.count, 105)];
}

- (void)buttonAction:(UIButton *)button{
    GetSpecListModel * model = nil;
    for (GetSpecListModel * specModel in _dataArray) {
        if (specModel.specId == button.tag) {
            model = specModel;
            break;
        }
    }
    if (self.cellDeleagte) {
        [self.cellDeleagte buttonAction:model];
    }
}

@end
