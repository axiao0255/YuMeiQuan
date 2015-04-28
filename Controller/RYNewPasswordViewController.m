//
//  RYNewPasswordViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/23.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYNewPasswordViewController.h"

@interface RYNewPasswordViewController ()<UITextFieldDelegate>
{
    NSString *phone;
}
@end

@implementation RYNewPasswordViewController

- (id)initWithPhoneNum:(NSString *)phoneNum
{
    self = [super init];
    if ( self ) {
        phone = phoneNum;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    UITextField *passwordTextField = [Utils getCustomLongTextField:@"请输入新密码"];
    passwordTextField.frame = CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,20, 250, 40);
    passwordTextField.delegate = self;
    [self.view addSubview:passwordTextField];
    
    UITextField *notarizePasswordTextField = [Utils getCustomLongTextField:@"请输入新密码"];
    notarizePasswordTextField.frame = CGRectMake(CGRectGetMinX(passwordTextField.frame) ,CGRectGetMaxY(passwordTextField.frame) + 10, 250, 40);
    notarizePasswordTextField.delegate = self;
    [self.view addSubview:notarizePasswordTextField];
    
    UIButton *submitBtn = [Utils getCustomLongButton:@"完成"];
    submitBtn.frame = CGRectMake(notarizePasswordTextField.frame.origin.x,CGRectGetMaxY(notarizePasswordTextField.frame) + 30, CGRectGetWidth(notarizePasswordTextField.bounds), CGRectGetHeight(notarizePasswordTextField.bounds));
    [self.view addSubview:submitBtn];
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
