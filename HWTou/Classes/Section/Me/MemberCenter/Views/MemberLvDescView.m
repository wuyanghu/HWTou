//
//  MemberLvDescView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MemberLvDescView.h"

#import "PublicHeader.h"

@interface MemberLvDescView()



@end

@implementation MemberLvDescView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addMainView];
        
        [self setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers

@end
