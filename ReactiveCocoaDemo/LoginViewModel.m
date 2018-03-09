//
//  LoginViewModel.m
//  ReactiveCocoaDemo
//
//  Created by EGO on 2018/3/9.
//  Copyright © 2018年 zht. All rights reserved.
//

#import "LoginViewModel.h"



@interface LoginViewModel()





@end
@implementation LoginViewModel


-(instancetype)init{
    self = [super init];
    if (self) {
        [self initBind];
    }
    return self;
}

-(Account *)account{
    if (_account==nil) {
        _account = [[Account alloc] init];
    }
    return _account;
}
//初始化绑定
- (void)initBind{
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self.account, name),RACObserve(self.account, pwd)] reduce:^id(NSString *name,NSString *pwd){
        
        return @(name.length>0&&pwd.length>0);
    }];
}
@end
