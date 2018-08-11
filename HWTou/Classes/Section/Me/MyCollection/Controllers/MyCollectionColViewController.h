//
//  MyCollectionColViewController.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

#import "MyCollectionColView.h"

@protocol MyCollectionColViewControllerDelegate<NSObject>

- (void)onDidSelectItem:(NSObject *)model withCollectionType:(CollectionColType)type;

@end

@interface MyCollectionColViewController : BaseViewController

@property (nonatomic, weak) id<MyCollectionColViewControllerDelegate> m_Delegate;

- (void)setMyCollectionColViewController:(CollectionColType)colType;

@end
