//
//  LevelView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                        Names:(NSArray<NSString*>*)names
                        icons:(NSArray<NSString*>*)icons;

- (void)updateSelectLevel:(NSString*)levelName;

- (NSInteger)selectedIndex;

@end
