//
//  RYRegisterViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/10.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRegisterViewController.h"

@interface RYRegisterViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *userNameText;
    UITextField *passWordText;
    UITextField *emailText;
    UITextField *securityCodeText;
    
    NSInteger   currentTime;
    NSTimer     *myTimer;
    
    registerType myType;
    
    UITableView *theTableView;
    
    imagesView  *proofImgView;        // 上传凭证视图
    
}
@end

@implementation RYRegisterViewController

- (id)initWithRefisterType:(registerType) type
{
    self = [super init];
    if ( self ) {
        myType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册用户";
    [self initSubviews];
    [self initTableBar];
}

- (void)initTableBar
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - 50, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    //登录按钮
    UIButton *btnNextStep = [Utils getCustomLongButton:@"完成注册"];
    CGRect r = CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 , \
                          7, \
                          250, 35);
    btnNextStep.frame = r;
    [btnNextStep addTarget:self action:@selector(submitDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btnNextStep];
}

- (void)initSubviews
{
//    // 用户名
//    userNameText = [[UITextField alloc]initWithFrame: \
//                    CGRectMake(0, 10, SCREEN_WIDTH, 100/2)];
//
//    [userNameText label:@"  用户名" withWidth:60];
//    userNameText.backgroundColor = [UIColor whiteColor];
//    [userNameText setPlaceholder:@"请输入您的手机号"];
//    userNameText.delegate = self;
//    userNameText.font = [UIFont systemFontOfSize:14];
//    [userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
//    [self.view addSubview:userNameText];
//
//    // 验证码
//    securityCodeText = [[UITextField alloc] initWithFrame: \
//                        CGRectMake(0, CGRectGetMaxY(userNameText.frame) + 10, SCREEN_WIDTH, 50)];
//    [securityCodeText label:@"  验证码" withWidth:60];
//    securityCodeText.backgroundColor = [UIColor whiteColor];
//    [securityCodeText setPlaceholder:@"请输入验证码"];
//    securityCodeText.delegate = self;
//    securityCodeText.font = [UIFont systemFontOfSize:14];
//    [securityCodeText setClearButtonMode:UITextFieldViewModeWhileEditing];
//    [self.view addSubview:securityCodeText];
//    UIButton *securityCodeBtn = [Utils getCustomLongButton:@"获取验证码"];
//    [securityCodeBtn setFrame:CGRectMake(0, 0, 90, 30)];
//    [securityCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [securityCodeBtn addTarget:self action:@selector(getSecurityCode) forControlEvents:UIControlEventTouchUpInside];
//    securityCodeBtn.layer.cornerRadius = 30/2.0;
//    securityCodeBtn.layer.masksToBounds = YES;
//    UIView* v = [[UIView alloc]initWithFrame: \
//                 CGRectMake(0, 0, CGRectGetWidth(securityCodeBtn.bounds) + 10,CGRectGetHeight(securityCodeBtn.bounds))];
//    [v addSubview:securityCodeBtn];
//    [securityCodeText setRightView:v];
//    securityCodeText.rightViewMode = UITextFieldViewModeAlways;
//    
//    // 密码
//    passWordText = [[UITextField alloc] initWithFrame: \
//                    CGRectMake(0,CGRectGetMaxY(securityCodeText.frame) + 10, SCREEN_WIDTH,  50)];
//    passWordText.delegate = self;
//    [passWordText setPlaceholder:@"请输入您的密码"];
//    passWordText.font = [UIFont systemFontOfSize:14];
//    passWordText.backgroundColor = [UIColor whiteColor];
//    [passWordText setClearButtonMode:UITextFieldViewModeWhileEditing];
//    [passWordText setSecureTextEntry:YES];
//    [passWordText label:@"  密   码" withWidth:60];
//    [self.view addSubview:passWordText];
//    
//    // 邮箱
//    emailText = [[UITextField alloc] initWithFrame: \
//                    CGRectMake(0,CGRectGetMaxY(passWordText.frame) + 10, SCREEN_WIDTH,  50)];
//    emailText.delegate = self;
//    [emailText setPlaceholder:@"请输入您的邮箱"];
//    emailText.font = [UIFont systemFontOfSize:14];
//    emailText.backgroundColor = [UIColor whiteColor];
//    [emailText setClearButtonMode:UITextFieldViewModeWhileEditing];
//    [emailText label:@"  邮   箱" withWidth:60];
//    [self.view addSubview:emailText];
//    
//    //提交验证的按钮
//    UIButton *sumbitBtn = [Utils getCustomLongButton:@"注册"];
//    sumbitBtn.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 20, CGRectGetHeight(sumbitBtn.bounds));
//    sumbitBtn.center = CGPointMake(SCREEN_WIDTH / 2, CGRectGetMaxY(emailText.frame) + 20 + CGRectGetHeight(sumbitBtn.frame)/2.0);
//    [sumbitBtn addTarget:self action:@selector(submitDidClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:sumbitBtn];
    
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT - 50)];
    theTableView.backgroundColor = [Utils getRGBColor:0xe3 g:0xee b:0xf8 a:1.0];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:theTableView];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:theTableView];
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,25, 250, 40)];
//    topView.backgroundColor = [Utils getRGBColor:0x04 g:0x8c b:0xcb a:1.0];
//    [theScrollView addSubview:topView];
//    // 绘制圆角
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds
//                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
//                                                         cornerRadii:CGSizeMake(5, 5)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = topView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    topView.layer.mask = maskLayer;
//    
//    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,0, 250, 35)];
//    topLabel.backgroundColor = [UIColor clearColor];
//    topLabel.textColor = [UIColor whiteColor];
//    topLabel.font = [UIFont boldSystemFontOfSize:14];
//    topLabel.text = @"请填写以下信息，完成注册";
//    topLabel.textAlignment = NSTextAlignmentCenter;
//    [topView addSubview:topLabel];
//  
    
    // 用户名
//    userNameText = [Utils getCustomLongTextField:@"请输入手机号码"];
//    userNameText.frame = CGRectMake(topView.frame.origin.x, 60, topView.frame.size.width, 35);
//    userNameText = [[UITextField alloc]initWithFrame: \
//                    CGRectMake(topLabel.frame.origin.x, 60, topLabel.frame.size.width, 40)];
//    
////    [userNameText label:@"  用户名" withWidth:60];
//    userNameText.backgroundColor = [UIColor whiteColor];
//    [userNameText setPlaceholder:@"请输入您的手机号"];
//    userNameText.delegate = self;
//    userNameText.font = [UIFont systemFontOfSize:14];
//    [userNameText setClearButtonMode:UITextFieldViewModeWhileEditing];
//    [self.view addSubview:userNameText];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 9;
    }
    else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        switch ( indexPath.row ) {
            case 0:
                return 100;
                break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
                return 50;
                break;
            default:
                return 0;
                break;
        }
    }
    else{
        return 115;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        switch ( indexPath.row ) {
            case 0:
                return [self topCellWithTableView:tableView indexPath:indexPath];
                break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
                return [self customTableView:tableView indexPath:indexPath];
                break;
            default:
                return [[UITableViewCell alloc] init];
                break;
        }
    }
    else{
        return [self picTableView:tableView indexPath:indexPath];
    }
}

- (UITableViewCell *)picTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *picIndent = @"picIndent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:picIndent];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:picIndent];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,0, 250, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [Utils getRGBColor:0xaa g:0xaa b:0xaa a:1.0];
        label.text = @"证件资料，点击选择图片";
        [cell.contentView addSubview:label];
        
        imagesView *a = [[imagesView alloc] initWithMaxNum:1];
        a.frame = CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 - 10, 0, 0 , 0);
        [a fixFrameH:25];
        [a seteidtEnable:couldEdit];           //可编辑
        [a setMainVC:self];                    //设置所在viewcontroller
        [a setPickerType:AlbumCollectionType]; //设置照片获取方式
        [a setTag:666];
        [a show];
        [cell.contentView addSubview:a];
    }
    proofImgView = (imagesView *)[cell.contentView viewWithTag:666];
    return cell;
}

- (UITableViewCell *)customTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"indentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [Utils getCustomLongTextField:@"请输入验证码"];
        textField.frame = CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,0, 250, 40);
        textField.delegate = self;
        textField.tag = 102;
        [cell.contentView addSubview:textField];
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:102];
    [textField setSecureTextEntry:NO];
    [textField setEnabled:YES];
    switch ( indexPath.row ) {
        case 1:
        {
            securityCodeText = textField;
            securityCodeText.placeholder = @"输入验证码";
            
        }
            break;
        case 2:
        {
            passWordText = textField;
            [passWordText setSecureTextEntry:YES];
            passWordText.placeholder = @"设置密码";
        }
            break;
        case 3:
        {
            [textField setSecureTextEntry:YES];
            textField.placeholder = @"确认密码";
        }
            break;
        case 4:
        {
            textField.placeholder = @"身份";
            [textField setEnabled:NO];
        }
            break;
        case 5:
        {
            textField.placeholder = @"临床专业";
        }
            break;
        case 6:
        {
            textField.placeholder = @"姓名";
        }
            break;
        case 7:
        {
            textField.placeholder = @"职务";
        }
            break;
        case 8:
        {
            textField.placeholder = @"单位";
        }
            break;
    
        default:
            textField.placeholder = @"";
            break;
    }
    return cell;
}

// 第一个cell
- (UITableViewCell *)topCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *cell_0 = @"cell_0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_0];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_0];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,15, 250, 40)];
        topView.backgroundColor = [Utils getRGBColor:0x04 g:0x8c b:0xcb a:1.0];
        [cell.contentView addSubview:topView];
        // 绘制圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = topView.bounds;
        maskLayer.path = maskPath.CGPath;
        topView.layer.mask = maskLayer;
        
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,0, 250, 35)];
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.font = [UIFont boldSystemFontOfSize:14];
        topLabel.text = @"请填写以下信息，完成注册";
        topLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:topLabel];
        
        UITextField *textField = [Utils getCustomLongTextField:@"请输入手机号码"];
        textField.frame = CGRectMake(topView.frame.origin.x, 50, topView.frame.size.width, 40);
        textField.delegate = self;
        textField.tag = 101;
        [cell.contentView addSubview:textField];
        
        UIButton *securityCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        securityCodeBtn.backgroundColor = [UIColor clearColor];
        [securityCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [securityCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [securityCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [securityCodeBtn addTarget:self action:@selector(getSecurityCode) forControlEvents:UIControlEventTouchUpInside];
        [textField setRightView:securityCodeBtn];
        textField.rightViewMode = UITextFieldViewModeAlways;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, securityCodeBtn.frame.size.height)];
        line.backgroundColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0];
        [securityCodeBtn addSubview:line];
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:101];
    userNameText = textField;
    return cell;
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
