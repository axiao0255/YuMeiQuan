//
//  RYEditClassifyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/28.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYEditClassifyViewController.h"
#import "TextFieldWithLabel.h"

@interface RYEditClassifyViewController ()<UITextFieldDelegate>
{
    NSDictionary *dataDic;
}
@end

@implementation RYEditClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if ( self ) {
        dataDic = dic;
    }
    return self;
}

- (void)initSubviews
{
    UITextField *textField = [[UITextField alloc]initWithFrame: \
                    CGRectMake(0,40,SCREEN_WIDTH, 40)];
    [textField setBorderStyle:UITextBorderStyleNone];
    textField.backgroundColor = [UIColor whiteColor];
    [textField setPlaceholder:@"请输入新的标签"];
    [textField setText:[dataDic getStringValueForKey:@"name" defaultValue:@""]];
    [textField seperatorWidth:15];
    [textField becomeFirstResponder];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14];
    textField.returnKeyType = UIReturnKeySend;
    [self.view addSubview:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"addsasd");
    
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
         [SVProgressHUD showWithStatus:@"提交中中..." maskType:SVProgressHUDMaskTypeGradient];
        [NetRequestAPI amendTallyWithSessionId:[RYUserInfo sharedManager].session
                                       JSTL_ID:[dataDic objectForKey:@"id"]
                                          name:textField.text
                                       success:^(id responseDic) {
                                           [SVProgressHUD dismiss];
                                           NSLog(@"修改标签 responseDic%@",responseDic);
                                           [wSelf verifyResultWithDict:responseDic];
            
        } failure:^(id errorString) {
            [SVProgressHUD dismiss];
             NSLog(@"修改标签 errorString%@",errorString);
            [ShowBox showError:@"修改失败，请稍候重试"];
        }];
    }
    return YES;
}

- (void)verifyResultWithDict:(NSDictionary *)responseDic
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"修改失败，请稍候重试"];
        return;
    }
    
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( meta == nil ) {
        [ShowBox showError:@"修改失败，请稍候重试"];
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"修改失败，请稍候重试" ]];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tallyChangeUpdate" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
