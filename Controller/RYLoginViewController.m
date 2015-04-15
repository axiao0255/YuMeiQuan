//
//  RYLoginViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYLoginViewController.h"
#import "RYRegisterViewController.h"
#import "RYRetrievePasswordViewController.h"
#import "RYRegisterSelectViewController.h"

@interface RYLoginViewController ()<UITextFieldDelegate>
{
    UITextField *userNameText;
    UITextField *passWordText;
}
@end

@implementation RYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登陆";
    [self initSubviews];
}

- (void)initSubviews
{
    userNameText = [[UITextField alloc]initWithFrame: \
                    CGRectMake(0, 10, SCREEN_WIDTH, 100/2)];
    
    [userNameText label:@"  用户名" withWidth:60];
    userNameText.backgroundColor = [UIColor whiteColor];
    [userNameText setPlaceholder:@"请输入您的手机号"];
    userNameText.delegate = self;
    userNameText.font = [UIFont systemFontOfSize:14];
    [userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:userNameText];
    
    passWordText = [[UITextField alloc]initWithFrame: \
                    CGRectMake(0, 10 + CGRectGetMaxY(userNameText.frame), SCREEN_WIDTH, 100/2)];
    [passWordText label:@"  密   码" withWidth:60];
    passWordText.backgroundColor = [UIColor whiteColor];
    [passWordText setPlaceholder:@"请输入您的密码"];
    passWordText.delegate = self;
    [passWordText setSecureTextEntry:YES];
    passWordText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:passWordText];
    
    //登录按钮
    UIButton *btnNextStep = [Utils getCustomLongButton:@"登录"];
    CGRect r = CGRectMake(10, \
                          CGRectGetMaxY(passWordText.frame) + 20, \
                          SCREEN_WIDTH - 2* 10, btnNextStep.frame.size.height);
    btnNextStep.frame = r;
    [btnNextStep addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNextStep];
    
    //注册
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnNextStep.frame.origin.x, \
                                                                       CGRectGetMaxY(btnNextStep.frame) + 15, 75, 31)];
    [registerBtn setExclusiveTouch:YES];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [registerBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    //找回密码按钮
    UIButton *forgetpw = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnNextStep.frame) - 102, \
                                                                    CGRectGetMaxY(btnNextStep.frame) + 15, 102, 31)];
    [forgetpw setExclusiveTouch:YES];
    forgetpw.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetpw setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [forgetpw setTitle:@"找回密码" forState:UIControlStateNormal];
    forgetpw.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetpw addTarget:self action:@selector(gotoFindPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetpw];
}

#pragma mark 登录
-(void)gotoLogin:(id)sender
{
    NSLog(@"登录");
}

#pragma mark 注册
-(void)registerUser
{
//    RYRegisterViewController *registerVC = [[RYRegisterViewController alloc] init];
//    [self.navigationController pushViewController:registerVC animated:YES];
    RYRegisterSelectViewController *registerSelectVC = [[RYRegisterSelectViewController alloc] init];
    [self.navigationController pushViewController:registerSelectVC animated:YES];
}

#pragma mark 找回密码
-(void)gotoFindPassWord:(id)sender
{
    RYRetrievePasswordViewController *retrievePasswordVC = [[RYRetrievePasswordViewController alloc] init];
    [self.navigationController pushViewController:retrievePasswordVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
