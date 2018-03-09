//
//  SecondViewController.m
//  ReactiveCocoaDemo
//
//  Created by zht on 2018/2/27.
//  Copyright © 2018年 zht. All rights reserved.
//

#import "SecondViewController.h"
#import <ReactiveCocoa.h>
#import "ThirdViewController.h"
@interface SecondViewController ()
@property (nonatomic,strong) UIButton *codeBtn;

@property (nonatomic,assign) int second;

@property (nonatomic,strong) RACDisposable *disposeable;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 200, 100)];
    [self.codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
    self.codeBtn.backgroundColor = [UIColor yellowColor];
    [self.codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.codeBtn];
    
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
        [self.navigationController pushViewController:thirdVC animated:YES];
    }];
    [self.view addSubview:btn];
    @weakify(self)
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl * x) {
        @strongify(self)
        x.enabled = NO;
        
        self.second = 10;
        
        self.disposeable = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            self.second--;
            NSString * title = self.second > 0 ? [NSString stringWithFormat:@"%d",self.second] : @"重新获取验证码";
            NSLog(@"%@",title);
            [self.codeBtn setTitle:title forState:UIControlStateNormal];
            
            
            self.codeBtn.enabled = (self.second==0)? YES : NO;
            if (self.second ==0) {
                [self.disposeable dispose];
            }
            
            
        }];
        
        
        
    }];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.disposeable dispose];
}


-(void)dealloc{
    NSLog(@"dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
