//
//  SubWYAuctionCollectionViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SubWYAuctionCollectionViewCell.h"
#import "PublicHeader.h"

@implementation SubWYAuctionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataArray:(NSMutableArray<GetSellerPerformListModel *> *)dataArray{
    
    CGRect frame = CGRectMake(0, 0, 160, 105);
    for (int i = 0; i<dataArray.count; i++) {
        GetSellerPerformListModel * specModel = dataArray[i];
        
        NSString * performIdKey = [NSString stringWithFormat:@"%ld",specModel.performId];
        if (!self.btnDict[performIdKey]) {
            UIButton * button = [[UIButton alloc] init];
            button.tag = specModel.performId;
            [button sd_setImageWithURL:[NSURL URLWithString:specModel.bmgUrl] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = frame;
            [self.scrollView addSubview:button];
            frame.origin.x = button.frame.origin.x+button.frame.size.width+10;
            
            [self.btnDict setObject:button forKey:performIdKey];
        }
    }
    [self.scrollView setContentSize:CGSizeMake((frame.size.width+10)*dataArray.count, 105)];
    
    _dataArray = dataArray;
}

- (void)buttonAction:(UIButton *)button{
    GetSellerPerformListModel * model = nil;
    for (GetSellerPerformListModel * specModel in _dataArray) {
        if (specModel.performId == button.tag) {
            model = specModel;
            break;
        }
    }
    _block(model);
}

- (NSMutableDictionary<NSString *,UIButton *> *)btnDict{
    if (!_btnDict) {
        _btnDict = [[NSMutableDictionary alloc] init];
    }
    return _btnDict;
}

+ (NSString *)cellIdentity{
    return @"SubWYAuctionCollectionViewCell";
}

@end
