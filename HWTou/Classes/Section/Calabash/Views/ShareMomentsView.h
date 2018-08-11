//
//  ShareMomentsView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MediaModel.h"

@protocol ShareMomentsViewDelegate<NSObject>

- (void)onShareMomentsSuccess;
- (void)onChooseMediaSource:(NSInteger)maxNumMedia;
- (void)onPhotoBrowse:(NSArray<UIImageView *> *)imgArray currentIndex:(NSInteger)index;

@end

@interface ShareMomentsView : UIView

@property (nonatomic, weak) id<ShareMomentsViewDelegate> m_Delegate;

- (void)shareContentCheck;
- (void)returnsMediaFile:(NSArray<MediaModel *> *)imgArray;

@end
