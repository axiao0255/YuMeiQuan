//
//  RYRetrievePasswordViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRetrievePasswordViewController.h"
#import "TextFieldWithLabel.h"
#import "RYPasswordAttestationViewController.h"

@interface RYRetrievePasswordViewController ()<UITextFieldDelegate>
{
    UITextField *phoneTextField;
    UIButton    *securityCodeBtn; // 发送验证码按钮
}
@end

@implementation RYRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    [self initSubviews];
}

- (void)initSubviews
{
    UITextField *textField = [Utils getCustomLongTextField:@"请输入您注册的手机号"];
    textField.frame = CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,20, 250, 40);
    textField.delegate = self;
    phoneTextField = textField;
    [self.view addSubview:textField];
    
    //提交验证的按钮
    UIButton *sumbitBtn = [Utils getCustomLongButton:@"发送验证码"];
    sumbitBtn.bounds = CGRectMake(0, 0, CGRectGetWidth(textField.bounds), CGRectGetHeight(sumbitBtn.bounds));
    sumbitBtn.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(textField.frame) + 20 + CGRectGetHeight(sumbitBtn.frame)/2.0);
    [sumbitBtn addTarget:self action:@selector(submitDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sumbitBtn];
    securityCodeBtn = sumbitBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitDidClick:(id)sender
{
    if ( [ShowBox alertPhoneNo:phoneTextField.text] ) {
        return;
    }
    if ( [ShowBox checkCurrentNetwork] ) {
        [securityCodeBtn setEnabled:NO];
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getFindPasswordSMS_codeWithPhoneNumber:phoneTextField.text
                                                      success:^(id responseDic) {
                                                          NSLog(@"responseDic :: %@",responseDic);
                                                          [securityCodeBtn setEnabled:YES];
                                                          RYPasswordAttestationViewController *vc = [[RYPasswordAttestationViewController alloc] initWithPhoneNum:phoneTextField.text];
                                                          [wSelf.navigationController pushViewController:vc animated:YES];
        } failure:^(id errorString) {
            [securityCodeBtn setEnabled:YES];
            RYPasswordAttestationViewController *vc = [[RYPasswordAttestationViewController alloc] initWithPhoneNum:phoneTextField.text];
            [wSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
}

#pragma mark -textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger textLength = [Utils getTextFieldActualLengthWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    if ( textLength > 11 ) {
        return NO;
    }
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
