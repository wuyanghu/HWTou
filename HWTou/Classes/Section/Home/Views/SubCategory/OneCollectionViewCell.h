//
//  OneCollectionViewCell.h
//  HWTou
//
//  Created by robinson on 2018/1/3.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "ChatClassesModel.h"

typedef void(^OneCollectionViewCellActionBlock)(ChatClassSecsModel * secsModel);

@interface OneCollectionViewCell : BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic,copy) OneCollectionViewCellActionBlock actionBlock;

@property (nonatomic,strong) ChatClassesModel * classModel;
@property (nonatomic,strong) ChatClassesModel * otherClassModel;

+ (NSString *)otherCellIdentity;
@end
