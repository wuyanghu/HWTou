//
//  RdAppError+filter.h
//  demoapp
//
//  Created by Liang Shen on 16/4/22.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import "RdAppError.h"
#import "ServiceCommon.h"


@interface RdAppError (filter)

-(void)filterErrorCode:(RdAppErrorType) errorType;

-(void)showErrorMessage:(RdAppError *)rdError;

@end
