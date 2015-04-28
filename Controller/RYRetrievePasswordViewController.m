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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitDidClick:(id)sender
{
    NSLog(@"获取验证码");
    if ( [ShowBox alertPhoneNo:phoneTextField.text] ) {
        return;
    }
    
    RYPasswordAttestationViewController *vc = [[RYPasswordAttestationViewController alloc] initWithPhoneNum:phoneTextField.text];
    [self.navigationController pushViewController:vc animated:YES];
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
