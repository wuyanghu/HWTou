//
//  AddsetMusicTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AddsetMusicTableViewCell.h"
#import "NTESLiveUtil.h"

@interface AddsetMusicTableViewCell()

@end

@implementation AddsetMusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.downMusicBtn setImage:[UIImage imageNamed:@"tjpy_icon_yx"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemDict:(NSDictionary *)itemDict{
    _itemDict = itemDict;
    self.titleLabel.text = itemDict[@"mName"];
    NSDictionary * allMusic = [NTESLiveUtil getAllLiveMusic];
    self.downMusicBtn.selected = allMusic[itemDict[@"bmgUrl"]]==nil?NO:YES;
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"AddsetMusicTableViewCell";
}
- (IBAction)downLoadAction:(id)sender {
    if (_cellDelegate) {
        self.downMusicBtn.selected = YES;
        [_cellDelegate downLoadAction:_itemDict];
        
    }
}

@end
