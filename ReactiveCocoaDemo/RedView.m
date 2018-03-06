//
//  RedView.m
//  ReactiveCocoaDemo
//
//  Created by zht on 2018/2/27.
//  Copyright © 2018年 zht. All rights reserved.
//

#import "RedView.h"

@implementation RedView
-(RACSubject *)clickSignal{
    if (!_clickSignal) {
        _clickSignal = [RACSubject subject];
    }
    return _clickSignal;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_clickSignal sendNext:@"点击了redview"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
