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
    NSString         *phone;
    UITextField      *newPasswordTextField;
    UITextField      *repetitionPasswordTextField;
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
    newPasswordTextField = passwordTextField;
    
    UITextField *notarizePasswordTextField = [Utils getCustomLongTextField:@"请输入新密码"];
    notarizePasswordTextField.frame = CGRectMake(CGRectGetMinX(passwordTextField.frame) ,CGRectGetMaxY(passwordTextField.frame) + 10, 250, 40);
    notarizePasswordTextField.delegate = self;
    [self.view addSubview:notarizePasswordTextField];
    repetitionPasswordTextField = notarizePasswordTextField;
    
    UIButton *submitBtn = [Utils getCustomLongButton:@"完成"];
    submitBtn.frame = CGRectMake(notarizePasswordTextField.frame.origin.x,CGRectGetMaxY(notarizePasswordTextField.frame) + 30, CGRectGetWidth(notarizePasswordTextField.bounds), CGRectGetHeight(notarizePasswordTextField.bounds));
    [self.view addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submitNewPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)submitNewPasswordClick:(id)sender
{
    if ( [ShowBox isEmptyString:newPasswordTextField.text] || [ShowBox isEmptyString:repetitionPasswordTextField.text] ) {
        [ShowBox showError:@"密码不能为空"];
        return;
    }
    
    if ( ![newPasswordTextField.text isEqualToString:repetitionPasswordTextField.text] ) {
        [ShowBox showError:@"两次密码不一致"];
        return;
    }
    
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI submitNewPasswordWithPhone:phone
                                         password:newPasswordTextField.text
                                          success:^(id responseDic) {
//                                              NSLog(@"responseDic :: %@",responseDic);
                                              NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                              BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                              if ( !success ) {
                                                  [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"网络出错，请稍候重试！"]];
                                                  return ;
                                              }
                                              
                                              [wSelf modificationSuccess];
            
        } failure:^(id errorString) {
//             NSLog(@"errorString :: %@",errorString);
             [ShowBox showError:@"网络出错，请稍候重试！"];
        }];
    }
}

// 密码修改成功
- (void)modificationSuccess
{
    // 清除 之前的 账号信息
    [RYUserInfo logout];
    // 用户注册成功 记住用户名和密码
    NSMutableDictionary *savedDic = [[NSMutableDictionary alloc] init];
    [savedDic setValue:phone forKey:USERNAME];
    [savedDic setValue:newPasswordTextField.text forKey:PASSWORD];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:LoginText];
    [savedDic writeToFile:path atomically:YES];
    NSArray *controllers = self.navigationController.viewControllers;
    for ( UIViewController *vc in controllers) {
        if ( [vc isKindOfClass:[RYLoginViewController class]] ) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
