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
    [textField setText:[dataDic getStringValueForKey:@"title" defaultValue:@""]];
    [textField seperatorWidth:15];
    [textField becomeFirstResponder];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textField];
}

@end
