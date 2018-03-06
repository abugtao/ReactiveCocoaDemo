//
//  ViewController.h
//  ReactiveCocoaDemo
//
//  Created by zht on 15/4/17.
//  Copyright (c) 2015年 zht. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic,copy) NSString *userName;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)loginAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

