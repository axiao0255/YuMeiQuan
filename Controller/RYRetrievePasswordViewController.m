//
//  RYRetrievePasswordViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/13.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRetrievePasswordViewController.h"
#import "TextFieldWithLabel.h"

@interface RYRetrievePasswordViewController ()<UITextFieldDelegate>

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
    UITextField *phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [phoneTextField setPlaceholder:@"请输入您注册的手机号码"];
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.delegate = self;
    phoneTextField.font = [UIFont systemFontOfSize:14];
    [phoneTextField label:@"  " withWidth:10];
    [self.view addSubview:phoneTextField];
    
    //提交验证的按钮
    UIButton *sumbitBtn = [Utils getCustomLongButton:@"发送验证码"];
    sumbitBtn.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 20, CGRectGetHeight(sumbitBtn.bounds));
    sumbitBtn.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(phoneTextField.frame) + 20 + CGRectGetHeight(sumbitBtn.frame)/2.0);
    [sumbitBtn addTarget:self action:@selector(submitDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sumbitBtn];
}

- (void)submitDidClick:(id)sender
{
    NSLog(@"获取验证码");
}

#pragma mark -textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
