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
    BOOL        isDoctor;            // 判断是否医生
    
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
    isDoctor = YES;
    [self initSubviews];
    [self initTableBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}


- (void)dealloc{
    NSLog(@"%@",self);
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}

#pragma mark - 初始化 子视图
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
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT - 50)];
    theTableView.backgroundColor = [Utils getRGBColor:0xe3 g:0xee b:0xf8 a:1.0];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:theTableView];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:theTableView];
}


#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( myType == typePersonal ) {
         return 2;
    }
    else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( myType == typePersonal ) { // 个人注册
        if ( section == 0 ) {
            return 9;
        }
        else{
            return 1;
        }
    }
    else{    // 企业注册
        return 5;
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
            {
                if ( myType == typePersonal ) {
                    return [self topCellWithTableView:tableView indexPath:indexPath];
                }
                else{
                    return [self company_cell_top_tableView:tableView indexPath:indexPath];
                }
            }
                break;
            case 1:
            case 2:
            case 3:
            case 6:
            case 7:
            case 8:
            {
                if ( myType == typePersonal ) {
                     return [self customTableView:tableView indexPath:indexPath];
                }else{
                    return [self company_cell_tableView:tableView indexPath:indexPath];
                }
            }
                break;
            case 4:
            {
                if ( myType == typePersonal ) {
                     return [self doctorCellTableView:tableView indexPath:indexPath];
                }else{
                    return [self company_cell_tableView:tableView indexPath:indexPath];
                }
            }
                break;
            case 5:
                return [self career_cell_tableView:tableView indexPath:indexPath];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 5 ) {
            NSLog(@"临床专业");
        }
    }
}

#pragma mark - 自定义的cell 类型

- (UITableViewCell *)company_cell_top_tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *company_cell_top = @"company_cell_top";
    RYRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:company_cell_top];
    if ( !cell ) {
        cell = [[RYRegisterTableViewCell alloc] initWithTopStyle:UITableViewCellStyleDefault reuseIdentifier:company_cell_top];
    }
    UILabel *topLabel = (UILabel *)[cell.contentView viewWithTag:1212];
    topLabel.text = @"请填写以下信息，完成注册";
    
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:101];
    textField.delegate = self;
    textField.enabled = NO;
    textField.placeholder = @"企业类型";
    UIView *rigth_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 40)];
    rigth_view.tag = 2020;
    rigth_view.backgroundColor = [UIColor clearColor];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 40)];
    arrow.backgroundColor = [UIColor clearColor];
    arrow.image = [UIImage imageNamed:@"arrows_right.png"];
    [rigth_view addSubview:arrow];
    textField.rightView = rigth_view;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    return cell;
}

- (UITableViewCell *)company_cell_tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *company_cell = @"company_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:company_cell];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:company_cell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [Utils getCustomLongTextField:@""];
        textField.font = [UIFont systemFontOfSize:14];
        textField.frame = CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,0, 250, 40);
        textField.delegate = self;
        textField.tag = 110 + indexPath.row;
        [cell.contentView addSubview:textField];
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:110 + indexPath.row];
    
    switch (indexPath.row ) {
        case 1:
            textField.placeholder = @"企业名称";
            break;
        case 2:
            textField.placeholder = @"联系人姓名";
            break;
        case 3:
            textField.placeholder = @"请输入手机号码";
            break;
        case 4:
            textField.placeholder = @"请输入邮箱";
            break;
            
        default:
            break;
    }
 
    return cell;
}

- (UITableViewCell *)career_cell_tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *career_cell = @"career_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:career_cell];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:career_cell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [Utils getCustomLongTextField:@""];
        textField.font = [UIFont systemFontOfSize:14];
        textField.frame = CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,0, 250, 40);
        textField.delegate = self;
        textField.tag = 40;
        textField.enabled = NO;
        [cell.contentView addSubview:textField];
        
        UIView *rigth_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 40)];
        rigth_view.tag = 2020;
        rigth_view.backgroundColor = [UIColor clearColor];
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 40)];
        arrow.backgroundColor = [UIColor clearColor];
        arrow.image = [UIImage imageNamed:@"arrows_right.png"];
        [rigth_view addSubview:arrow];
        textField.rightView = rigth_view;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:40];
    if ( isDoctor ) {
        textField.placeholder = @"临床专业";
    }
    else{
        textField.placeholder = @"身份";
    }
    return cell;
}


- (UITableViewCell *)doctorCellTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *doctor_cell = @"doctor_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doctor_cell];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doctor_cell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [Utils getCustomLongTextField:@"是否医生"];
        textField.font = [UIFont systemFontOfSize:14];
        textField.frame = CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,0, 250, 40);
        textField.delegate = self;
        textField.tag = 1110;
        textField.enabled = NO;
        [cell.contentView addSubview:textField];
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1110];
    for ( int i  = 0 ;  i < 2; i ++ ) {
        UIButton * btn = (UIButton *)[cell.contentView viewWithTag:1300 + i];
        if ( !btn ) {
            btn = [[UIButton alloc] initWithFrame:CGRectMake(textField.frame.origin.x + 70 + i * 75, 0, 100, 40)];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(checkedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1300 + i;
            [cell.contentView addSubview:btn];
            
            UIImageView *checkImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            checkImage.backgroundColor = [UIColor clearColor];
            checkImage.tag = 111;
            [btn addSubview:checkImage];
            
            UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, btn.frame.size.width - 40, 40)];
            checkLabel.font = [UIFont systemFontOfSize:14];
            checkLabel.backgroundColor = [UIColor clearColor];
            checkLabel.tag = 112;
            [btn addSubview:checkLabel];
        }
        
        UIImageView *tempImage = (UIImageView *)[btn viewWithTag:111];
        UILabel     *tempLabel = (UILabel *)[btn viewWithTag:112];
        
        if ( btn.tag == 1300 ) {
            tempLabel.text = @"是医生";
            if ( isDoctor ) {
                tempImage.image = [UIImage imageNamed:@"ic_checked.png"];
                tempLabel.textColor = [Utils getRGBColor:70.0 g:70.0 b:70.0 a:1.0];
            }
            else{
                tempImage.image = [UIImage imageNamed:@"ic_unchecked.png"];
                tempLabel.textColor = [Utils getRGBColor:160.0 g:160.0 b:160.0 a:1.0];
            }
        }
        else{
            tempLabel.text = @"不是医生";
            if ( isDoctor ) {
                tempImage.image = [UIImage imageNamed:@"ic_unchecked.png"];
                tempLabel.textColor = [Utils getRGBColor:160.0 g:160.0 b:160.0 a:1.0];
            }
            else{
                tempImage.image = [UIImage imageNamed:@"ic_checked.png"];
                tempLabel.textColor = [Utils getRGBColor:70.0 g:70.0 b:70.0 a:1.0];
            }
        }
    }
    return cell;
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
        
        UITextField *textField = [Utils getCustomLongTextField:@""];
        textField.font = [UIFont systemFontOfSize:14];
        textField.frame = CGRectMake(SCREEN_WIDTH / 2.0 - 250/2.0 ,0, 250, 40);
        textField.delegate = self;
        textField.tag = 110 + indexPath.row;
        [cell.contentView addSubview:textField];
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:110 + indexPath.row];
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

// 个人注册     第一个cell
- (UITableViewCell *)topCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *cell_0 = @"cell_0";    
    RYRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_0];
    if ( !cell ) {
        cell = [[RYRegisterTableViewCell alloc] initWithTopStyle:UITableViewCellStyleDefault reuseIdentifier:cell_0];
    }
    UILabel *topLabel = (UILabel *)[cell.contentView viewWithTag:1212];
    topLabel.text = @"请填写以下信息，完成注册";
    
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:101];
    textField.delegate = self;
    textField.placeholder = @"请输入手机号码";
    userNameText = textField;
    
    UIButton *securityCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    securityCodeBtn.backgroundColor = [UIColor clearColor];
    [securityCodeBtn setTitleColor:[Utils getRGBColor:70.0 g:70.0 b:70.0 a:1.0] forState:UIControlStateNormal];
    [securityCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [securityCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [securityCodeBtn addTarget:self action:@selector(getSecurityCode) forControlEvents:UIControlEventTouchUpInside];
    [textField setRightView:securityCodeBtn];
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, securityCodeBtn.frame.size.height)];
    line.backgroundColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0];
    [securityCodeBtn addSubview:line];

    return cell;
}

#pragma mark -------------------------------------

- (void)checkedBtnClick:(id)sender
{
    NSLog(@"是医生");
    UIButton *btn = (UIButton *)sender;
    if ( btn.tag == 1300 ) {
        isDoctor = YES;
    }else{
        isDoctor = NO;
    }
    NSLog(@"btn :: %@",btn);
    [theTableView beginUpdates];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for ( int i = 4 ; i <= 5; i ++ ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    if ( indexPaths.count ) {
        [theTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    [theTableView endUpdates];
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
