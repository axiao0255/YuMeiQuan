//
//  RYRegisterViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/10.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRegisterViewController.h"

@interface RYRegisterViewController ()<UITextFieldDelegate>
{
    UITextField *userNameText;
    UITextField *passWordText;
    UITextField *emailText;
    UITextField *securityCodeText;
    
    NSInteger currentTime;
    NSTimer *myTimer;
}
@end

@implementation RYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册用户";
    [self initSubviews];
}

- (void)initSubviews
{
    // 用户名
    userNameText = [[UITextField alloc]initWithFrame: \
                    CGRectMake(0, 10, SCREEN_WIDTH, 100/2)];

    [userNameText label:@"  用户名" withWidth:60];
    userNameText.backgroundColor = [UIColor whiteColor];
    [userNameText setPlaceholder:@"请输入您的手机号"];
    userNameText.delegate = self;
    userNameText.font = [UIFont systemFontOfSize:14];
    [userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:userNameText];
    
    // 验证码
    securityCodeText = [[UITextField alloc] initWithFrame: \
                        CGRectMake(0, CGRectGetMaxY(userNameText.frame) + 10, SCREEN_WIDTH, 50)];
    [securityCodeText label:@"  验证码" withWidth:60];
    securityCodeText.backgroundColor = [UIColor whiteColor];
    [securityCodeText setPlaceholder:@"请输入验证码"];
    securityCodeText.delegate = self;
    securityCodeText.font = [UIFont systemFontOfSize:14];
    [securityCodeText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:securityCodeText];
    UIButton *securityCodeBtn = [Utils getCustomLongButton:@"获取验证码"];
    [securityCodeBtn setFrame:CGRectMake(0, 0, 90, 30)];
    [securityCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [securityCodeBtn addTarget:self action:@selector(getSecurityCode) forControlEvents:UIControlEventTouchUpInside];
    securityCodeBtn.layer.cornerRadius = 30/2.0;
    securityCodeBtn.layer.masksToBounds = YES;
    UIView* v = [[UIView alloc]initWithFrame: \
                 CGRectMake(0, 0, CGRectGetWidth(securityCodeBtn.bounds) + 10,CGRectGetHeight(securityCodeBtn.bounds))];
    [v addSubview:securityCodeBtn];
    [securityCodeText setRightView:v];
    securityCodeText.rightViewMode = UITextFieldViewModeAlways;
    
    // 密码
    passWordText = [[UITextField alloc] initWithFrame: \
                    CGRectMake(0,CGRectGetMaxY(securityCodeText.frame) + 10, SCREEN_WIDTH,  50)];
    passWordText.delegate = self;
    [passWordText setPlaceholder:@"请输入您的密码"];
    passWordText.font = [UIFont systemFontOfSize:14];
    passWordText.backgroundColor = [UIColor whiteColor];
    [passWordText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [passWordText setSecureTextEntry:YES];
    [passWordText label:@"  密   码" withWidth:60];
    [self.view addSubview:passWordText];
    
    // 邮箱
    emailText = [[UITextField alloc] initWithFrame: \
                    CGRectMake(0,CGRectGetMaxY(passWordText.frame) + 10, SCREEN_WIDTH,  50)];
    emailText.delegate = self;
    [emailText setPlaceholder:@"请输入您的邮箱"];
    emailText.font = [UIFont systemFontOfSize:14];
    emailText.backgroundColor = [UIColor whiteColor];
    [emailText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [emailText label:@"  邮   箱" withWidth:60];
    [self.view addSubview:emailText];
    
    //提交验证的按钮
    UIButton *sumbitBtn = [Utils getCustomLongButton:@"注册"];
    sumbitBtn.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 20, CGRectGetHeight(sumbitBtn.bounds));
    sumbitBtn.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(emailText.frame) + 20 + CGRectGetHeight(sumbitBtn.frame)/2.0);
    [sumbitBtn addTarget:self action:@selector(submitDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sumbitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitDidClick:(id)sender
{
    NSLog(@"提交注册");
    if ( [ShowBox alertPhoneNo:userNameText.text] ) {
        return;
    }
    
    if ( [ShowBox isEmptyString:securityCodeText.text] ) {
        [ShowBox showError:@"请填写验证码"];
        return;
    }
    
    if ( [ShowBox isEmptyString:passWordText.text] ) {
        [ShowBox showError:@"请输入密码"];
        return;
    }
    
    if ( [ShowBox alertEmail:emailText.text] ) {
        return;
    }
    
    [self submitRegisterNet];
}

- (void)submitRegisterNet
{
    [ShowBox checknetwork:^(BOOL status) {
        if ( status ) {
            NSLog(@"有网络");

            NSString *strUrl = [NSString stringWithFormat:@"http://121.40.151.63/member.php?mod=register&type=mobile&mobile=2&username=%@&password=%@&email=%@",userNameText.text,passWordText.text,emailText.text];
//               NSString *strUrl = @"http://api2.rongyi.com/app/v5/home/index.htm;jsessionid=?type=latest&areaName=%E4%B8%8A%E6%B5%B7&cityId=51f9d7f231d6559b7d000002&lng=121.439659&lat=31.194059&currentPage=1&pageSize=20&version=v5_6";
//            NSString *strUrl = @"http://121.40.151.63/app.php";
            [NetManager JSONDataWithUrl:strUrl success:^(id json) {
                NSLog(@"json :%@",json);
            } fail:^(id error) {
                NSLog(@"error :%@",error);
            }];
        }
        else{
            [ShowBox showError:@"没有网络"];
        }
    }];
}

- (void)getSecurityCode
{
    NSLog(@"获取验证码");
    if ( [ShowBox alertPhoneNo:userNameText.text] ) {
        return;
    }
}

#pragma mark -textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect rect = CGRectMake(0.0f, IsIOS7?64:0, self.view.frame.size.width, self.view.frame.size.height);
//        self.view.frame = rect;
//    }];
    return YES;
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
