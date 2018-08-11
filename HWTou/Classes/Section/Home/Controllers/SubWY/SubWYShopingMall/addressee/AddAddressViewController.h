//
//  AddAddressViewController.h
//  HWTou
//
//  Created by robinson on 2018/4/12.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddAddressViewControllerDelegate
- (void)addAddressVCAction;
@end

@interface AddAddressViewController : BaseViewController
@property (nonatomic,weak) id<AddAddressViewControllerDelegate> delegate;
@end
