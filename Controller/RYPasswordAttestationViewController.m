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
    NSString *phone;
    UITextField *textField;
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
    [self.view addSubview:repeatBtn];
}

- (void)attestationBtnClick
{
    if ( [ShowBox isEmptyString:textField.text] ) {
        [ShowBox showError:@"请先输入验证码"];
        return;
    }
    
    RYNewPasswordViewController *vc = [[RYNewPasswordViewController alloc] initWithPhoneNum:phone];
    [self.navigationController pushViewController:vc animated:YES];
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
