//
//  AddressManageViewController.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@class AddressGoodsDM;

typedef void(^AddressSelectedBlock)(AddressGoodsDM *address);
typedef void(^AddressModifyBlock)(AddressGoodsDM *address);
typedef void(^AddressDeleteBlock)(AddressGoodsDM *address);

@interface AddressManageViewController : BaseViewController

@property (nonatomic, copy) AddressSelectedBlock blockAddress;
@property (nonatomic, copy) AddressDeleteBlock  deleteAddress;
@property (nonatomic, copy) AddressModifyBlock  modifyAddress;

@end
