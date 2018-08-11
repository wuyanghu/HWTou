//
//  RadioTopHeaderCell.h
//  
//
//  Created by Reyna on 2017/11/26.
//

#import <UIKit/UIKit.h>
#import "RadioViewModel.h"

@protocol RadioTopHeaderDelegate <NSObject>
- (void)topSelectBtnAction:(NSInteger)index;
@end

@interface RadioTopHeaderCell : UITableViewCell
@property (nonatomic, weak) __weak id<RadioTopHeaderDelegate> delegate;

+ (NSString *)cellReuseIdentifierInfo;

- (void)bind:(RadioViewModel *)viewModel;

+ (CGFloat)cellRatioHeight;

@end
