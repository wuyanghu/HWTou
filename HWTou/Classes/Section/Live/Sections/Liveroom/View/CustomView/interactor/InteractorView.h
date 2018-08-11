//
//  Interactor.h
//  HWTou
//
//  Created by robinson on 2018/3/21.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTESMicConnector;

typedef enum : NSUInteger{
    offType,//关
    onType,//开
}switchType;

@protocol InteractorViewDelegate

- (void)onSelectMicConnector:(NTESMicConnector *)connector;
- (void)onCloseBypassing;
- (void)openOrCloseInteractor:(switchType)type;
- (void)newInteractMsg;
@end

@interface InteractorView : UIControl

@property (nonatomic, weak) id<InteractorViewDelegate> interactorDelegate;
- (void)refreshWithQueue:(NSArray<NTESMicConnector *> *)queue isNotice:(BOOL)isNotice;
- (void)show;
- (void)dismiss;
@end
