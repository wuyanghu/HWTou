//
//  RadioHeaderCell.h
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

//0:发布去向  1:聊天去向
typedef NS_ENUM(NSUInteger, RadioHeaderType) {
    RadioHeaderTypeProvince = 0,//交通台
    RadioHeaderTypeNational = 1,//方言台
    RadioHeaderTypeLocation = 2,//本地台
    RadioHeaderTypeNetwork = 3,//娱乐台
};

@protocol RadioHeaderTypeDelegate <NSObject>

- (void)radioHeaderSelectAction:(RadioHeaderType)type;

@end

@interface RadioHeaderCell : UITableViewCell

@property (nonatomic, weak) __weak id<RadioHeaderTypeDelegate> delegate;

+ (NSString *)cellReuseIdentifierInfo;

@end
