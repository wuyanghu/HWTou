//
//  MediaColViewCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MediaModel.h"

#define kMediaColViewCellId     (@"MediaColViewCellId")

@protocol MediaColViewCellDelegate <NSObject>

- (void)onDidSelectItem:(MediaModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)onDeleteItem:(MediaModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MediaColViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) MediaModel *m_Model;
@property (nonatomic, weak) id<MediaColViewCellDelegate> m_Delegate;

- (void)setMediaColViewCellUpDataSource:(MediaModel *)model
                  cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
