//
//  ThirdViewController.m
//  ReactiveCocoaDemo
//
//  Created by EGO on 2018/3/9.
//  Copyright © 2018年 zht. All rights reserved.
//

#import "ThirdViewController.h"
#import "LoginViewModel.h"
#import <ReactiveCocoa.h>
@interface ThirdViewController ()
@property (nonatomic,strong) LoginViewModel * viewModel;


@property (nonatomic,strong) UITextField * nameTextField;

@property (nonatomic,strong) UITextField * pwdTextField;


@property (nonatomic,strong) UIButton * loginBtn;

@property (nonatomic,copy) NSString * name;
@end

@implementation ThirdViewController

-(LoginViewModel *)viewModel{
    if (_viewModel==nil) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initViews];
    [self bindViewModel];
    
}
- (void)initViews{
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 300, 40)];
    self.nameTextField.placeholder = @"name";
    [self.view addSubview:self.nameTextField];
    
    self.pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 300, 40)];
    self.pwdTextField.placeholder = @"pwd";
    [self.view addSubview:self.pwdTextField];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 300, 40)];
    
    self.loginBtn.backgroundColor = [UIColor redColor];
    [self.loginBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"aa");
//    }];
    [self.view addSubview:self.loginBtn];
}
- (void)bindViewModel{
//    RAC(<#TARGET, ...#>)
    //修改textfield改变account属性
    RAC(self.viewModel.account,name) = _nameTextField.rac_textSignal;
    RAC(self.viewModel.account,pwd) = _pwdTextField.rac_textSignal;
    
    RAC(self.loginBtn,enabled) = self.viewModel.loginEnableSignal;
}
- (void)buttonAction{
    
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
