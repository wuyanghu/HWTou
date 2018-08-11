//
//  MyMusicTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MyMusicTableViewCell.h"
#import "NTESLiveUtil.h"

@interface MyMusicTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MyMusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemDict:(NSDictionary *)itemDict{
    _itemDict = itemDict;
    self.titleLabel.text = itemDict[@"mName"];
}

- (IBAction)delMusic:(id)sender {
    [NTESLiveUtil delMusic:_itemDict];
    if (_cellDelegate) {
        [_cellDelegate delMusicAction];
    }
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"MyMusicTableViewCell";
}

@end
