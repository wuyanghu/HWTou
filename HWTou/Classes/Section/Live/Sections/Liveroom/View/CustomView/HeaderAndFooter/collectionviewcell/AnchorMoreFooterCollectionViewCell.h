//
//  AnchorMoreFooterCollectionViewCell.h
//  HWTou
//
//  Created by robinson on 2018/3/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define imgKey @"imgKey"
#define titleKey @"titleKey"
#define selectimgKey @"selectimgKey"
#define selecttitleKey @"selecttitleKey"
#define tagKey @"tagKey"

@interface AnchorMoreFooterCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (NSString *)cellIdentity;
@property (nonatomic,strong) NSDictionary * imageTitleDict;
- (void)setImageTitleDict:(NSDictionary *)imageTitleDict isNormal:(BOOL)isNormal;
@end
