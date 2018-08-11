//
//  PayTypeSelectedVC.h
//  HWTou
//
//  Created by Reyna on 2018/3/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeSelectedVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;


- (instancetype)initWithTotalPrice:(NSString *)totalPrice;

@end
