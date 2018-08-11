//
//  MyCollectionColView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CollectionColType){
    
    CollectionColType_SpendMoney = 0,      // 花钱
    CollectionColType_ActivityNews,        // 活动新闻(内容)
    CollectionColType_Activity,            // 活动
    CollectionColType_Unknown,
    
};

@protocol MyCollectionColViewDelegate <NSObject>

- (void)onDidSelectItem:(NSObject *)model;

@end

@interface MyCollectionColView : UIView

@property (nonatomic, weak) id<MyCollectionColViewDelegate> m_Delegate;

- (void)setMyCollectionColViewType:(CollectionColType)colType;

@end
