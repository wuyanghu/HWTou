//
//  SuccessView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SuccessView.h"

#import "PublicHeader.h"

@interface SuccessView()



@end

@implementation SuccessView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addMainView];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addViews];
    
}

- (void)addViews{

    UIImageView *imgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SUCCESS_ICON
                                        withIsUserInteraction:NO];
    
    [self addSubview:imgView];
    
    UILabel *promptLbl= [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                          size:CLIENT_COMMON_FONT_TITLE_INCREASE_SIZE];
    
    [promptLbl setText:@"恭喜您修改手机号成功!"];
    
    [self addSubview:promptLbl];
    
    /* ********** layout UI ********** */
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(54);
        make.centerX.equalTo(self.mas_centerX);
        make.size.equalTo(CGSizeMake(55, 55));
        
    }];
    
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imgView.mas_bottom).offset(10);
        make.centerX.equalTo(imgView.mas_centerX);
        
    }];
    
    /* ********** layout UI End ********** */
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

@end
