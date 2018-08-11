//
//  HomeInteractCollectionViewCell.h
//  HWTou
//
//  Created by Reyna on 2018/3/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeInteractCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


+ (NSString *)getTheReuseIdentifier;

@end
