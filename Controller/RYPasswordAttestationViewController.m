//
//  RYPasswordAttestationViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/23.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYPasswordAttestationViewController.h"
#import "RYNewPasswordViewController.h"

@interface RYPasswordAttestationViewController ()<UITextFieldDelegate>
{
    NSString    *phone;
    UITextField *textField;
    NSInteger   currentTime;
    NSTimer     *myTimer;
    UIButton    *securityCodeBtn;
}
@end

@implementation RYPasswordAttestationViewController

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
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubViews
{
    UILabel *hintLabel = [[UILabel alloc] initWithFrame: CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,20, 250, 40)];
    hintLabel.font = [UIFont systemFontOfSize:10];
    hintLabel.textColor = [Utils getRGBColor:150.0 g:150.0 b:150.0 a:1.0];
    hintLabel.text = [NSString stringWithFormat:@"已发送验证码到%@",phone];
    [self.view addSubview:hintLabel];
    
    textField = [Utils getCustomLongTextField:@"请输入验证码"];
    textField.frame = CGRectMake(CGRectGetMinX(hintLabel.frame) ,CGRectGetMaxY(hintLabel.frame) + 5 , CGRectGetWidth(hintLabel.bounds), CGRectGetHeight(hintLabel.bounds));
    textField.delegate = self;
    [self.view addSubview:textField];
    
    UIButton *attestationBtn = [Utils getCustomLongButton:@"验证"];
    attestationBtn.frame = CGRectMake(CGRectGetMinX(textField.frame), CGRectGetMaxY(textField.frame) + 10, CGRectGetWidth(textField.bounds), CGRectGetHeight(textField.bounds));
    [attestationBtn addTarget:self action:@selector(attestationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:attestationBtn];
    
    UILabel *repeatLabel = [[UILabel alloc] init];
    repeatLabel.frame = CGRectMake(CGRectGetMinX(attestationBtn.frame), CGRectGetMaxY(attestationBtn.frame) + 10, CGRectGetWidth(attestationBtn.bounds), CGRectGetHeight(attestationBtn.bounds));
    repeatLabel.font = [UIFont systemFontOfSize:10];
    repeatLabel.textColor = [Utils getRGBColor:150.0 g:150.0 b:150.0 a:1.0];
    repeatLabel.text = @"没有收到验证码？";
    [self.view addSubview:repeatLabel];
    
    UIButton *repeatBtn = [Utils getCustomLongButton:@"重新发送"];
    repeatBtn.frame = CGRectMake(repeatLabel.frame.origin.x,CGRectGetMaxY(repeatLabel.frame), CGRectGetWidth(repeatLabel.bounds), CGRectGetHeight(repeatLabel.bounds));
    [repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repeatBtn];
    securityCodeBtn = repeatBtn;
}
/**
 *重新获取验证码
 */
- (void)repeatBtnClick:(id)sender{
    if ( [ShowBox checkCurrentNetwork] ) {
        [securityCodeBtn setEnabled:NO];
        [securityCodeBtn setBackgroundColor:[Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0]];
        [self startRuntime];
        [NetRequestAPI getFindPasswordSMS_codeWithPhoneNumber:phone
                                                      success:^(id responseDic) {
                                                          NSLog(@"responseDic :: %@",responseDic);
                                                          NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                                          BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                                          if ( !success ) {
                                                              [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"获取验证码出错，请稍候重试！"]];
                                                          }
                                                      } failure:^(id errorString) {
                                                          [ShowBox showError:@"获取验证码出错，请稍候重试！"];
                                                      }];
    }
}
- (void)startRuntime
{
    currentTime = 60;
    NSString *timeString = [NSString stringWithFormat:@"%li s重发",(long)currentTime];
    [securityCodeBtn setTitle:timeString forState:UIControlStateDisabled];
    [myTimer invalidate];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimer:) userInfo:nil repeats:YES];
}

// 重获验证码 时间 调整
- (void)runTimer:(id)sender
{
    currentTime -- ;
    if ( currentTime < 0 ) {
        [securityCodeBtn setEnabled:YES];
        securityCodeBtn.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
        [securityCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [myTimer invalidate];
    }
    else{
        NSString *timeString = [NSString stringWithFormat:@"%li s重发",(long)currentTime];
        [securityCodeBtn setTitle:timeString forState:UIControlStateDisabled];
    }
}

/**
 *提交验证码
 */
- (void)attestationBtnClick
{
    if ( [ShowBox isEmptyString:textField.text] ) {
        [ShowBox showError:@"请先输入验证码"];
        return;
    }
    
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI submitSecurityCodeWithPhone:phone
                                              code:textField.text
                                           success:^(id responseDic) {
//                                               NSLog(@"提交验证码 ： responseDic%@",responseDic);
                                               NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                               BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                               if ( !success ) {
                                                   [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"网络出错，请稍候重试！"]];
                                                   return ;
                                               }
                                               RYNewPasswordViewController *vc = [[RYNewPasswordViewController alloc] initWithPhoneNum:phone];
                                               [wSelf.navigationController pushViewController:vc animated:YES];
            
        } failure:^(id errorString) {
//            NSLog(@"提交验证码 ： errorString%@",errorString);
            [ShowBox showError:@"网络出错，请稍候重试！"];
        }];
    }
}

#pragma mark -textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
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
