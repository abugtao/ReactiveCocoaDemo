//
//  RedView.h
//  ReactiveCocoaDemo
//
//  Created by zht on 2018/2/27.
//  Copyright © 2018年 zht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>
@interface RedView : UIView
@property (nonatomic,strong) RACSubject *clickSignal;
@end
