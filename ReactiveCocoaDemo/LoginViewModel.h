//
//  LoginViewModel.h
//  ReactiveCocoaDemo
//
//  Created by EGO on 2018/3/9.
//  Copyright © 2018年 zht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import <ReactiveCocoa.h>
@interface LoginViewModel : NSObject
@property (nonatomic,strong) Account * account;

@property (nonatomic,strong) RACSignal * loginEnableSignal;
@end
