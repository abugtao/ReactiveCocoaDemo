//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by zht on 15/4/17.
//  Copyright (c) 2015年 zht. All rights reserved.
//

#import "ViewController.h"
#include <ReactiveCocoa.h>
#import "RedView.h"
#import "SecondViewController.h"
#import "Person.h"
@interface ViewController ()


@property (nonatomic,strong) id subscriber;

@property (nonatomic,strong) RedView *redView;


@property (nonatomic,strong) RACCommand * command;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //rac 替换了delegate
    self.redView =  [[RedView alloc] initWithFrame:CGRectMake(0, 400, 100, 100)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.redView.clickSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [self.view addSubview:self.redView];
    
    
    
    
    //  RACObserve(self, userName)  自己生产一个信号
    [RACObserve(self, userName) subscribeNext:^(NSString *newName){
    
        NSLog(@"%@",newName);
    
    }];
    
    
    
   
    

    
    
    [[RACSignal combineLatest:@[self.pwdTextField.rac_textSignal] reduce:^(NSString *pwd){
        return @(pwd.length>0);
    }] subscribeNext:^(id x) {
        self.loginButton.enabled = [x boolValue];
    }];
    
    
    
    
    
    [[self rac_signalForSelector:@selector(loginAction:)] subscribeNext:^(id x) {
        NSLog(@"点击我了");
    }];
    
    
    
    

    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
    

}

- (void)test{
    //调用 顺序 创建信号的block会在订阅信号的时候调用
    //订阅信号的block会在订阅者发布信息的时候调用
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //不订阅这个信号 这个block不会掉用
        NSLog(@"aaaa");
        
        //3、发布信息
        [subscriber sendNext:@"I'm send next data"];  //这个函数内部回调用步骤4  执行完步骤4后在接着往下执行
        self.subscriber = subscriber;
        
        
        NSLog(@"啥时候运行");
        
        return [RACDisposable disposableWithBlock:^{
            //这个block调用时机  1. 订阅者被销毁 2. RACDisposable调用dispose取消订阅
            NSLog(@"disposable");
            
            
        }];
    }];
    
    //2订阅信号
    RACDisposable *disposable =  [signal subscribeNext:^(id x) {
        //4.收到信息后掉用
        NSLog(@"%@",x);
    }]; //这个函数内部会调用步骤3
    
    [disposable dispose];  //取消订阅
}


- (void)test2{
    // RACSubject 是 RACSignal 的子类   他可以被订阅多次，并且只能是先订阅后发布。
    
    
    //1创建信号
    RACSubject *subject = [RACSubject subject]; //内部创建了一个_disposable取消信号和用来保存订阅者的数组_subscribers
    
    [subject sendNext:@"这里发送信息，收不到的 ，只能先订阅 在发布信息"];
    
    //2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];  //订阅信息的时候 会创建订阅者，并保存到_subscribers数组中
    
    [subject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //3.发送数据
    [subject sendNext:@"abc"];  //遍历_subscribers 的订阅者，依次发送信息

}

- (void)test3{
    //RACReplaySubject 是 RACSubject 的子类 ，可以先发送信号在订阅 。
    //1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];//在父类的基数上多了一步，创建了一个可变数组_valuesReceived来保存要发生的数据
    //2.发送数据
    [replaySubject sendNext:@"先发送数据了，等你接收"];//然后调用父类的发送方法（此时会发送失败，因为没有订阅者），发送完了看发送成功了没，成功了就删除数据，避免一个数据多次发送。
    [replaySubject sendNext:@"先发送数据了，"];
    //3.订阅信号   先遍历一次_valuesReceived保存数据的数组，如果有就执行 2
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"2----%@",x);
    }];
    
}

- (void)test4{
    //RACCommand 在RAC中是对一个动作的触发条件以及它产生的触发时间的封装。
    
    //1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"%@",input);
        
        //2.创建信号，来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"发布消息"];  //订阅者发送数据
            //注意：数据传递完，最好调用sendCompleted，这时命令才执行完
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    self.command = command;
    
    
    //3订阅RACCommand中的信号   必须在execute 前
    [command.executionSignals subscribeNext:^(id x) {
        //这里的x是一个信号RACDynamicSignal
        [x subscribeNext:^(id x) {
            NSLog(@"接受消息--%@",x);
        }];
    }];

    
    
    

    //4执行命令
    [command execute:@1];
    
    
    
    
    
    
//    RACSignal *signal = [command execute:@"飞起来"];
//
//    [signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);   //接受信息
//    }];
    
    
}


- (void)test5{
    //RACTuple 其实就是对数组的封装
    
    
    //RACSequence  可以用来代替NSArray NSDictionary 主要就是用来快速遍历，和用来字段转模型
    NSArray *numbers = @[@1,@2,@3,@4];
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    NSDictionary *dic = @{@"name":@"zht",
                          @"age":@27};
    [dic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        //这里的x的类型是RACTuple
        NSLog(@"key = %@,value = %@",[x first],x[1]);
    }];
    
    
    
    NSArray *array = @[@{@"name":@"zht",@"age":@27},@{@"name":@"qfx",@"age":@27}];
    
    
    NSArray *personArray = [[array.rac_sequence map:^id(id value) {
        NSLog(@"value = %@",value);
        Person *p = [[Person alloc] init];
        p.name = value[@"name"];
        p.age = value[@"age"];
        return p;
    }] array];
    NSLog(@"%@",personArray);
}

- (void)test6{
    //处理多个请求，都返回结果的时候，统一做处理
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"发送1"];
        return nil;
    }];
    
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"发送2"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateWithR1:r2:) withSignalsFromArray:@[request1,request2]];  //每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法
}
- (void)updateWithR1:(id)data1 r2:(id)data2{
    NSLog(@"更新UI %@ %@",data1,data2);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
//    [self test4];

    
    SecondViewController *secondeVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondeVC animated:YES];
}


@end
