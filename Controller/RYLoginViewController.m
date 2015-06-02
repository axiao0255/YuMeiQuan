//
//  RYLoginViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYLoginViewController.h"
#import "RYRetrievePasswordViewController.h"
#import "RYRegisterSelectViewController.h"

#define USERNAMELENGTH 11              // 用户名的长度
#define PASSWORDLENGTH 15              // 密码长度

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
    self.title = @"登录";
    [self initSubviews];
}

- (void)initSubviews
{
//    UIImage *image = [UIImage imageNamed:@"input_text_bk_long.png"];
    userNameText = [[UITextField alloc]initWithFrame: \
                    CGRectMake(15, 32,SCREEN_WIDTH - 30,40)];
    [userNameText setBorderStyle:UITextBorderStyleNone];
//    userNameText.layer.masksToBounds = YES;
//    userNameText.layer.cornerRadius = 5.0;
    [userNameText label:@"  用户名" withWidth:60];
    userNameText.backgroundColor = [UIColor whiteColor];
    [userNameText setPlaceholder:@"请输入您的手机号"];
    userNameText.delegate = self;
//    userNameText.background = image;
    userNameText.font = [UIFont systemFontOfSize:14];
    [userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:userNameText];
    
    passWordText = [[UITextField alloc]initWithFrame: \
                    CGRectMake(CGRectGetMinX(userNameText.frame), \
                               8 + CGRectGetMaxY(userNameText.frame),
                               CGRectGetWidth(userNameText.bounds), CGRectGetHeight(userNameText.bounds))];
//    passWordText.layer.masksToBounds = YES;
//    passWordText.layer.cornerRadius = 5.0;
    [passWordText setBorderStyle:UITextBorderStyleNone];
//    passWordText.background = image;
    [passWordText label:@"  密   码" withWidth:60];
    passWordText.backgroundColor = [UIColor whiteColor];
    [passWordText setPlaceholder:@"请输入您的密码"];
    passWordText.delegate = self;
    [passWordText setSecureTextEntry:YES];
    passWordText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:passWordText];
    
    //登录按钮
    UIButton *btnLogin = [Utils getCustomLongButton:@"登录"];
    CGRect r = CGRectMake(CGRectGetMinX(passWordText.frame), \
                          CGRectGetMaxY(passWordText.frame) + 40, \
                          CGRectGetWidth(passWordText.bounds),\
                          40);
    btnLogin.frame = r;
    btnLogin.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
    [btnLogin addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    //找回密码按钮
    UIButton *forgetpw = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnLogin.frame) - 102, \
                                                                    CGRectGetMaxY(btnLogin.frame) + 5, 102, 30)];
    [forgetpw setExclusiveTouch:YES];
    forgetpw.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetpw setTitleColor:[Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0] forState:UIControlStateNormal];
    [forgetpw setTitle:@"找回密码" forState:UIControlStateNormal];
    forgetpw.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetpw addTarget:self action:@selector(gotoFindPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetpw];
    
    //注册
    UIButton *registerBtn = [Utils getCustomLongButton:@"注册账号"];
    registerBtn.frame = CGRectMake(CGRectGetMinX(btnLogin.frame),\
                                   CGRectGetMaxY(btnLogin.frame) + (IS_IPHONE_5?128:80), \
                                   CGRectGetWidth(btnLogin.bounds), \
                                   CGRectGetHeight(btnLogin.bounds));
    registerBtn.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
    [registerBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    [self setUsernameAndPassword];
}

- (void)setUsernameAndPassword
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:LoginText];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (dict) {
        userNameText.text = [dict getStringValueForKey:@"userName" defaultValue:@""];
        passWordText.text = [dict getStringValueForKey:@"password" defaultValue:@""];
    }
}

#pragma mark 登录
-(void)gotoLogin:(id)sender
{
    NSLog(@"登录");
    
    if ( [ShowBox alertPhoneNo:userNameText.text] ) {
        return;
    }
    
    if ( passWordText.text.length < 3 || passWordText.text.length > PASSWORDLENGTH ) {
        [ShowBox showError:@"密码不正确"];
        return;
    }
    
    if ( [ShowBox checkCurrentNetwork] ) {
        
        [NetRequestAPI userLoginWithUserName:userNameText.text password:passWordText.text success:^(id responseDic) {
            NSLog(@"responseDic : %@",responseDic);
            if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
                [ShowBox showError:@"登录失败，请稍候重试"];
                return ;
            }
            NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
            if ( meta == nil || [meta isKindOfClass:[NSNull class]]) {
                [ShowBox showError:@"登录失败，请稍候重试"];
                return ;
            }
            
            BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
            if ( !success ) {
                [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"登录失败，请稍候重试"]];
                return;
            }
            // 登录成功后 记住用户名和密码
            NSMutableDictionary *savedDic = [[NSMutableDictionary alloc] init];
            [savedDic setObject:userNameText.text forKey:@"userName"];
            [savedDic setObject:passWordText.text forKey:@"password"];
            [savedDic setObject:@"1" forKey:@"islogin"];
            
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path = [docPath stringByAppendingPathComponent:LoginText];
            [savedDic writeToFile:path atomically:YES];
            
            NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
            [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:info];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(id errorString) {
            NSLog(@"errorString :13800%@",errorString);
        }];
        
    }
}

#pragma mark 注册
-(void)registerUser
{
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( textField == userNameText ) {
        if ( textField.text.length >= USERNAMELENGTH && string.length ) {
            return NO;
        }
    }
    else if ( textField == passWordText )
    {
        if ( textField.text.length >= PASSWORDLENGTH && string.length ) {
            return NO;
        }
    }
    return YES;
}

@end
