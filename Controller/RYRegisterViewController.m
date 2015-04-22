//
//  RYRegisterViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/10.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRegisterViewController.h"
#import "RYRegisterData.h"
#import "RYRegisterSpecialtyViewController.h"

@interface RYRegisterViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,RYRegisterSpecialtyDelegate>
{
    // 个人注册
    UITextField *userPhoneText;         // 手机号
    UITextField *securityCodeText;      // 验证码
    UITextField *passWordText;          // 密码
    UITextField *repetPasswordText;     // 重复密码
    BOOL        isDoctor;               // 判断是否医生
    UITextField *identityText;          // 专业
    UITextField *userNameText;          // 姓名
    UITextField *positionText;          // 职位
    UITextField *departmentText;        // 所属单位
    
    // 企业
    UITextField *companyTypeText;          // 企业类型
    UITextField *companyNameText;          // 企业名称
    UITextField *companyContactPersonText; // 企业联系人
    UITextField *commanyPhoneText;         // 企业电话
    UITextField *companyEmailText;         // 企业邮箱

    NSInteger   currentTime;
    NSTimer     *myTimer;
    registerType myType;
    UITableView *theTableView;
    imagesView  *proofImgView;        // 上传凭证视图
    
    UIButton    *identityBtn;         // 专业选择 按钮
    UIButton    *positionBtn;         // 职务选择按钮
    UIButton    *securityCodeBtn;     // 获取验证码 按钮
    
    
    // 数据
    RYRegisterData *registerData;
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
    [self initData];
    [self initSubviews];
    [self initTableBar];
}

- (void) initData
{
    registerData = [[RYRegisterData alloc] init];
    // 个人
    registerData.doctorSpecialtyArray = @[@"皮肤科医生",@"整形外科医生",@"其他临床专业"];
    registerData.ordinarySpecialtyArray = @[@"临床助理",@"医学生",@"咨询师",@"厂商人员",@"医疗机构人员",@"协会人员",@"其他专业"];
    registerData.doctorPositionArray = @[@"院长",@"科主任",@"科室副主任",@"医生",@"其他职务"];
    registerData.ordinaryPositionArray = @[@"营销总监",@"销售人员",@"市场人员",@"其他职务"];
    // 企业
    registerData.companyTypeArray = @[@"厂商",@"医疗机构",@"其他(协会)"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}


- (void)dealloc{
    NSLog(@"%@",self);
//    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
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
//    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:theTableView];
}

#pragma mark 选中后更新数据
- (void)selectSpecialtyTypeWithTag:(NSUInteger)tag didStr:(NSString *)str
{
    if ( [ShowBox isEmptyString:str] ) {
        return;
    }
    NSIndexPath *indexPath;
    if ( myType == typeCollective ) {
        if ( tag == 200 ) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            registerData.companyType = str;
        }
    }
    else
    {
        NSUInteger index = tag - 100;
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        if ( index == 5 ) {
            if ( isDoctor ) {
                registerData.userRofessional = str;
            }
            else{
                registerData.userIdentity = str;
            }
        }
        else if ( index == 7 ){
            if ( isDoctor ) {
                registerData.userPosition = str;
            }else{
                registerData.userOrdinaryPosition = str;
            }
        }

    }
    
    if ( indexPath ) {
        [theTableView beginUpdates];
        [theTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [theTableView endUpdates];
    }
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
            case 7:
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


#pragma mark - 自定义的cell 类型

#pragma mark ------ 企业cell-----------
- (UITableViewCell *)company_cell_top_tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *company_cell_top = @"company_cell_top";
    RYRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:company_cell_top];
    if ( !cell ) {
        cell = [[RYRegisterTableViewCell alloc] initWithTopStyle:UITableViewCellStyleDefault reuseIdentifier:company_cell_top];
    }
    UILabel *topLabel = (UILabel *)[cell.contentView viewWithTag:1212];
    topLabel.text = @"请填写以下信息，完成注册";
    
    companyTypeText = (UITextField *)[cell.contentView viewWithTag:101];
    companyTypeText.delegate = self;
    companyTypeText.placeholder = @"企业类型";
    companyTypeText.text = registerData.companyType;
    [companyTypeText setEnabled:NO];
    
    UIView *rigth_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 40)];
    rigth_view.tag = 2020;
    rigth_view.backgroundColor = [UIColor clearColor];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 40)];
    arrow.backgroundColor = [UIColor clearColor];
    arrow.image = [UIImage imageNamed:@"arrows_right.png"];
    [rigth_view addSubview:arrow];
    
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:1313];
    [button removeFromSuperview];
    button = [[UIButton alloc] initWithFrame:companyTypeText.frame];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.tag = 1313;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(companySelect) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    companyTypeText.rightView = rigth_view;
    companyTypeText.rightViewMode = UITextFieldViewModeAlways;
    
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
        {
            companyNameText = textField;
            companyNameText.placeholder = @"企业名称";
            companyNameText.text = registerData.companyName;
        }
            break;
        case 2:
        {
            companyContactPersonText =textField;
            companyContactPersonText.placeholder = @"联系人姓名";
            companyContactPersonText.text = registerData.companyContactPerson;
        }
            break;
        case 3:
        {
            commanyPhoneText = textField;
            commanyPhoneText.placeholder = @"请输入手机号码";
            commanyPhoneText.text = registerData.companyPhone;
        }
            break;
        case 4:
        {
            companyEmailText = textField;
            companyEmailText.placeholder = @"请输入邮箱";
            companyEmailText.text = registerData.companyEmail;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark -------------个人用户cell-----------------
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
        [textField setEnabled:NO];
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
        
        UIButton *btn = [[UIButton alloc] initWithFrame:textField.frame];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 50;
        [cell.contentView addSubview:btn];
    }
    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:50];
    [btn addTarget:self action:@selector(identityAndPositionSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:40];
    if ( indexPath.row == 5 ) {
        identityBtn = btn;
        identityText = textField;
        if ( isDoctor ) {
            identityText.text = registerData.userRofessional;
            identityText.placeholder = @"临床专业";
        }
        else{
            identityText.text = registerData.userIdentity;
            identityText.placeholder = @"身份";
        }
    }
    else{
        positionBtn = btn;
        positionText = textField;
        positionText.placeholder = @"职务";
        if ( isDoctor ) {
            positionText.text = registerData.userPosition;
        }else{
            positionText.text = registerData.userOrdinaryPosition;
        }
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
            securityCodeText.text = registerData.userSecurityCode;
            securityCodeText.placeholder = @"输入验证码";
        }
            break;
        case 2:
        {
            passWordText = textField;
            passWordText.text = registerData.userPassword;
            [passWordText setSecureTextEntry:YES];
            passWordText.placeholder = @"设置密码";
        }
            break;
        case 3:
        {
            repetPasswordText = textField;
            repetPasswordText.text = registerData.userRepetPassword;
            [repetPasswordText setSecureTextEntry:YES];
            repetPasswordText.placeholder = @"确认密码";
        }
            break;
        case 6:
        {
            userNameText = textField;
            userNameText.text = registerData.userName;
            userNameText.placeholder = @"姓名";
        }
            break;
            break;
        case 8:
        {
            departmentText = textField;
            departmentText.text = registerData.userCompany;
            departmentText.placeholder = @"单位";
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
    userPhoneText = textField;
    userPhoneText.text = registerData.userPhone;
    
    if ( securityCodeBtn ) {
        [securityCodeBtn removeFromSuperview];
    }
    securityCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
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

- (void)companySelect
{
    RYRegisterSpecialtyViewController *vc = [[RYRegisterSpecialtyViewController alloc] initWIthSpecialtyArray:registerData.companyTypeArray isFillout:NO andTitle:@"企业类型"];
    vc.delegate = self;
    vc.view.tag = 200;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)identityAndPositionSelect:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSArray * dataArr;
    NSString *title;
    NSUInteger tag;
    
    if ( btn == identityBtn ) {
        tag = 105;
        if ( isDoctor ) {
            dataArr = registerData.doctorSpecialtyArray;
            title = @"临床专业";
        }
        else{
            dataArr = registerData.ordinarySpecialtyArray;
            title = @"选择身份";
        }
    }
    else{
        tag = 107;
        title = @"选择职务";
        if ( isDoctor ) {
            dataArr = registerData.doctorPositionArray;
            
        }
        else{
            dataArr = registerData.ordinaryPositionArray;
        }
    }
    
    RYRegisterSpecialtyViewController *vc = [[RYRegisterSpecialtyViewController alloc] initWIthSpecialtyArray:dataArr isFillout:YES andTitle:title];
    vc.delegate = self;
    vc.view.tag = tag;
    [self.navigationController pushViewController:vc animated:YES];

}

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
    NSIndexPath *index_path = [NSIndexPath indexPathForRow:7 inSection:0];
    [indexPaths addObject:index_path];
    if ( indexPaths.count ) {
        [theTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    [theTableView endUpdates];
}

- (void)submitDidClick:(id)sender
{
    if ( myType == typePersonal ) {
        [self personalRegister];
    }
    else{
    }
}
// 个人注册 判断
- (void)personalRegister
{
    if ( [ShowBox alertPhoneNo:registerData.userPhone] ) {
        return;
    }
    if ( [ShowBox isEmptyString:registerData.userSecurityCode] ) {
        [ShowBox showError:@"请输入验证码"];
        return;
    }
    if ( [ShowBox isEmptyString:registerData.userPassword] ) {
        [ShowBox showError:@"请输入密码"];
        return;
    }
    if ( [ShowBox isEmptyString:registerData.userRepetPassword] && ![registerData.userRepetPassword isEqualToString:registerData.userPassword] ) {
        [ShowBox showError:@"两次密码不一致"];
        return;
    }
    if ( [ShowBox isEmptyString:identityText.text] ) {
        [ShowBox showError:@"请选择专业"];
        return;
    }
    
    if ( [ShowBox isEmptyString:registerData.userName] ) {
        [ShowBox showError:@"请输入姓名"];
        return;
    }
    
    if ( [ShowBox isEmptyString:positionText.text] ) {
        [ShowBox showError:@"请选择职务"];
        return;
    }
    if ( [ShowBox isEmptyString:registerData.userCompany] ) {
        [ShowBox showError:@"请填写单位"];
        return;
    }
    
    [self personalRegisterNet];
    
}

// 个人注册 提交网络
- (void)personalRegisterNet
{
    if ( [ShowBox checkCurrentNetwork] ) {
//
        NSString *strUrl = [NSString stringWithFormat:@"http://121.40.151.63/ios.php?mod=register&username=%@&code=%@&password=%@&doctor=%d&professional=%@&realname=%@&position=%@&company=%@",registerData.userPhone,registerData.userSecurityCode,registerData.userPassword,isDoctor,registerData.userRofessional,registerData.userName,registerData.userPosition,registerData.userCompany];
//        NSString *strUrl = @"http://api2.rongyi.com/app/v5/home/index.htm;jsessionid=057537E635C9F0A0526B700E2BB34AA5?type=latest&areaName=%E4%B8%8A%E6%B5%B7&cityId=51f9d7f231d6559b7d000002&lng=121.439659&lat=31.194059&currentPage=1&pageSize=20&version=v5_6";
//         NSString *strUrl = @"http://121.40.151.63/app.php";
        NSLog(@"strUrl :: %@",strUrl);
//        NSDictionary *parameter = @{@"mod":@"register",@"username":@"123"};
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        [parameter setValue:@"register" forKey:@"mod"];
        [parameter setValue:registerData.userPhone forKey:@"username"];
        [parameter setValue:registerData.userSecurityCode forKey:@"code"];
        [parameter setValue:registerData.userPassword forKey:@"password"];
        [parameter setValue:registerData.userSecurityCode forKey:@"code"];
        [parameter setValue:[NSNumber numberWithBool:isDoctor] forKey:@"doctor"];
        [parameter setValue:registerData.userRofessional forKey:@"professional"];
        [parameter setValue:registerData.userName forKey:@"realname"];
        [parameter setValue:registerData.userPosition forKey:@"position"];
        [parameter setValue:registerData.userCompany forKey:@"company"];
        
        NSLog(@"parameter :: %@",parameter);
        NSString *url = [NSString stringWithFormat:@"%@/ios.php",DEBUGADDRESS];
        [NetManager JSONDataWithUrl:url parameters:parameter success:^(id json) {
            NSLog(@"json :: %@", json);
        } fail:^(id error) {
             NSLog(@"error :: %@",error);
        }];
        
//        [NetManager postJSONWithUrl:@"http://121.40.151.63/ios.php" parameters:parameter success:^(id responseObject) {
//             NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//             NSLog(@"responseObject :: %@", responseObject);
//            NSLog(@"result :: %@",result);
//            
//        } fail:^(id error) {
//            NSLog(@"error :: %@",error);
//        }];
    }
}


- (void)getSecurityCode
{
    if ( [ShowBox alertPhoneNo:registerData.userPhone] ) {
        return;
    }
    [securityCodeBtn setEnabled:NO];
    __weak typeof(self) wSelf = self;
    if ( [ShowBox checkCurrentNetwork] ) {
        NSString *url = [NSString stringWithFormat:@"%@/ios.php?mod=duanxin&username=%@",DEBUGADDRESS,registerData.userPhone];
        [NetManager JSONDataWithUrl:url parameters:nil success:^(id json) {
            if ( !json && [json isKindOfClass:[NSNull class]] ) {
                [ShowBox showError:@"请稍后重试"];
                [wSelf securityCodeBtnTypeChangeWithBool:YES];
                return ;
            }
            NSDictionary *dic = [json getDicValueForKey:@"meta" defaultValue:nil];
            if ( !dic ) {
                [ShowBox showError:@"请稍后重试"];
                [wSelf securityCodeBtnTypeChangeWithBool:YES];
                return;
            }
            BOOL success = [dic getBoolValueForKey:@"success" defaultValue:NO];
            if ( !success ) {
                [ShowBox showError:[dic getStringValueForKey:@"msg" defaultValue:@"请稍后重试"]];
                [wSelf securityCodeBtnTypeChangeWithBool:YES];
                return;
            }
            currentTime = 60;
            NSString *timeString = [NSString stringWithFormat:@"%i s重发",currentTime];
            [securityCodeBtn setTitle:timeString forState:UIControlStateDisabled];
            [myTimer invalidate];
            myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimer:) userInfo:nil repeats:YES];
           
        } fail:^(id error) {
            [wSelf securityCodeBtnTypeChangeWithBool:YES];
        }];
    }
}

- (void)runTimer:(id)sender
{
    NSLog(@"%d",currentTime);
    currentTime -- ;
    NSString *timeString = [NSString stringWithFormat:@"%i s重发",currentTime];
    [securityCodeBtn setTitle:timeString forState:UIControlStateDisabled];
    if (currentTime <= 0)
    {
        [myTimer invalidate];
        [self securityCodeBtnTypeChangeWithBool:YES];
        [securityCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}


- (void)securityCodeBtnTypeChangeWithBool:(BOOL)canUsed
{
    if ( canUsed ) {
        [securityCodeBtn setEnabled:YES];
    }
    else{
        [securityCodeBtn setEnabled:NO];
    }
}

#pragma mark -textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( myType == typeCollective ) { // 企业
        if ( textField == companyTypeText ) {
            registerData.companyType = textField.text;
        }
        else if ( textField == companyNameText ){
            registerData.companyName = textField.text;
        }
        else if ( textField == companyContactPersonText ){
            registerData.companyContactPerson = textField.text;
        }
        else if ( textField == commanyPhoneText ){
            registerData.companyPhone = textField.text;
        }
        else if ( textField == companyEmailText ){
            registerData.companyEmail = textField.text;
        }
    }
    else // 个人
    {
        if ( textField == userPhoneText ) {
            registerData.userPhone = textField.text;
        }
        else if ( textField == securityCodeText ){
            registerData.userSecurityCode = textField.text;
        }
        else if ( textField == passWordText ){
            registerData.userPassword = textField.text;
        }
        else if ( textField == repetPasswordText ){
            registerData.userRepetPassword = textField.text;
        }
        else if ( textField == identityText ){  // 专业
            if ( isDoctor ) {
                registerData.userRofessional = textField.text;
            }else{
                registerData.userIdentity = textField.text;
            }
        }
        else if ( textField == userNameText ){
            registerData.userName = textField.text;
        }
        else if ( textField == positionText ){   // 职务
            if ( isDoctor ) {
                registerData.userPosition = textField.text;
            }else{
                registerData.userOrdinaryPosition = textField.text;
            }
        }
        else if ( textField == departmentText ){  // 单位
            registerData.userCompany = textField.text;
        }
    }
}


@end
