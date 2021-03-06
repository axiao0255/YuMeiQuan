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
#import "TextFieldWithLabel.h"
#import "NYSegmentedControl.h"
#import "RYCompanyRegisterSuccessViewController.h"

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
    UITextField *qualificationsText;    // 职称
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
    UIButton    *qualificationsBtn;   // 职称按钮
    UIButton    *securityCodeBtn;     // 获取验证码 按钮
    
    UIButton    *submitBtn;           // 提交按钮
    
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
    registerData.QualificationsArray = @[@"住院医师",@"主治医师",@"副主任医师",@"主任医师",@"其他职称"];
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
    btnNextStep.frame = CGRectMake(15, 5, SCREEN_WIDTH - 30, 40);
    [btnNextStep addTarget:self action:@selector(submitDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btnNextStep];
    submitBtn = btnNextStep;
}

- (void)initSubviews
{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT - 50)];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:theTableView];
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
        else{
            registerData.userQualifications = str;
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
            if ( isDoctor ) {
                return 10;
            }
            else{
                return 9;
            }
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
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                return 52;
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
                    return [self customTableView:tableView indexPath:indexPath];
                }
                else{
                    return [self company_cell_top_tableView:tableView indexPath:indexPath];
                }
            }
                break;
            case 1:
            {
                if ( myType == typePersonal ) {
                    return [self securityCodeTableView:tableView indexPath:indexPath];
                }
                else{
                    return [self company_cell_tableView:tableView indexPath:indexPath];
                }
            }
                break;
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
            case 9:
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:company_cell_top];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:company_cell_top];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 40)];
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [textField seperatorWidth:14];
        textField.backgroundColor = [UIColor whiteColor];
        textField.delegate = self;
        textField.tag = 101;
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
        
        UIButton *button = (UIButton *)[cell.contentView viewWithTag:1313];
        [button removeFromSuperview];
        button = [[UIButton alloc] initWithFrame:textField.frame];
        [button setTitle:@"" forState:UIControlStateNormal];
        button.tag = 1313;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(companySelect) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    companyTypeText = (UITextField *)[cell.contentView viewWithTag:101];
    companyTypeText.placeholder = @"企业类型";
    companyTypeText.text = registerData.companyType;
    [companyTypeText setEnabled:NO];
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
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 40)];
        textField.font = [UIFont systemFontOfSize:14];
        textField.backgroundColor = [UIColor redColor];
        textField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [textField seperatorWidth:14];
        textField.backgroundColor = [UIColor whiteColor];
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
            commanyPhoneText.placeholder = @"联系电话";
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
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 40)];
        textField.font = [UIFont systemFontOfSize:14];
        [textField seperatorWidth:15];
        textField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        textField.backgroundColor = [UIColor whiteColor];
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
    else if(indexPath.row == 7){
        positionBtn = btn;
        positionText = textField;
        positionText.placeholder = @"职务";
        if ( isDoctor ) {
            positionText.text = registerData.userPosition;
        }else{
            positionText.text = registerData.userOrdinaryPosition;
        }
    }
    else{
        qualificationsBtn = btn;
        qualificationsText = textField;
        qualificationsText.placeholder = @"职称";
        qualificationsText.text = registerData.userQualifications;
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
                
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 40)];
        textField.font = [UIFont systemFontOfSize:16];
        [textField seperatorWidth:15];
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        textField.delegate = self;
        textField.tag = 1110;
        textField.placeholder = @"用户类型";
        textField.enabled = NO;
        [cell.contentView addSubview:textField];
        
        NYSegmentedControl *segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"医生",@"非医生"]];
        [segmentedControl addTarget:self action:@selector(segmentSelectedControl:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.borderColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];// 边界的颜色
        segmentedControl.borderWidth = 0.8;
        segmentedControl.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0]; // 底部的颜色
        segmentedControl.segmentIndicatorBackgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0]; // 所选按钮颜色
        segmentedControl.segmentIndicatorInset = 0; // 按钮缩小
        segmentedControl.titleTextColor = [UIColor whiteColor]; // 字体颜色
        segmentedControl.selectedTitleTextColor = [UIColor whiteColor];  // 选择时的字体颜色
        segmentedControl.segmentIndicatorBorderColor = [UIColor whiteColor]; // 所选按钮的字体颜色
        segmentedControl.frame = CGRectMake(SCREEN_WIDTH - 15 - 184, 8, 184 , 40);
        [cell.contentView addSubview:segmentedControl];
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 ,0, 250, 30)];
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [Utils getRGBColor:0xaa g:0xaa b:0xaa a:1.0];
        label.text = @"证件资料，点击选择图片";
        [cell.contentView addSubview:label];
        
        imagesView *a = [[imagesView alloc] initWithMaxNum:1];
        a.frame = CGRectMake(20, 0, 0 , 0);
        [a fixFrameH:18];
        [a seteidtEnable:couldEdit];           //可编辑
        [a setMainVC:self];                    //设置所在viewcontroller
        [a setPickerType:AlbumCollectionType]; //设置照片获取方式
        [a setTag:666];
        a.backgroundColor = [UIColor clearColor];
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
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 40)];
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        [textField seperatorWidth:15];
        textField.backgroundColor = [UIColor whiteColor];
        textField.delegate = self;
//        textField.tag = 110 + indexPath.row;
         textField.tag = 1010;
        [cell.contentView addSubview:textField];
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1010 ];
    [textField setSecureTextEntry:NO];
    [textField setEnabled:YES];
    switch ( indexPath.row ) {
        case 0:
        {
            userPhoneText = textField;
            userPhoneText.text = registerData.userPhone;
            userPhoneText.placeholder = @"请输入手机号";
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

- (UITableViewCell *)securityCodeTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"securityCode";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, 40)];
        textField.font = [UIFont systemFontOfSize:16];
        [textField seperatorWidth:15];
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        textField.delegate = self;
        textField.tag = 1314;
        [cell.contentView addSubview:textField];
        
        securityCodeBtn = [Utils getCustomLongButton:@"获取验证码"];
        securityCodeBtn.frame = CGRectMake(0, 0, 92, 40);
        securityCodeBtn.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
        securityCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [securityCodeBtn addTarget:self action:@selector(getSecurityCode) forControlEvents:UIControlEventTouchUpInside];
        textField.rightView = securityCodeBtn;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1314];
    securityCodeText = textField;
    securityCodeText.text = registerData.userSecurityCode;
    securityCodeText.placeholder = @"输入验证码";
    
    return cell;

}

#pragma mark -------------------------------------
// 企业类型选择
- (void)companySelect
{
    RYRegisterSpecialtyViewController *vc = [[RYRegisterSpecialtyViewController alloc] initWIthSpecialtyArray:registerData.companyTypeArray isFillout:NO andTitle:@"企业类型"];
    vc.delegate = self;
    vc.view.tag = 200;
    [self.navigationController pushViewController:vc animated:YES];
}

// 专业和职务选择
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
    else if ( btn == positionBtn ){
        tag = 107;
        title = @"选择职务";
        if ( isDoctor ) {
            dataArr = registerData.doctorPositionArray;
            
        }
        else{
            dataArr = registerData.ordinaryPositionArray;
        }
    }
    else{
        tag = 109;
        title = @"选择职称";
        dataArr = registerData.QualificationsArray;
    }
    
    RYRegisterSpecialtyViewController *vc = [[RYRegisterSpecialtyViewController alloc] initWIthSpecialtyArray:dataArr isFillout:YES andTitle:title];
    vc.delegate = self;
    vc.view.tag = tag;
    [self.navigationController pushViewController:vc animated:YES];
}
// 是否医生按钮点击
- (void)segmentSelectedControl:(NYSegmentedControl *)sender
{
    NSUInteger index = sender.selectedSegmentIndex;
    if ( index == 0 ) {
        isDoctor = YES;
    }
    else{
        isDoctor = NO;
    }
    [theTableView beginUpdates];
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    [indexPaths addObject:indexPath];
    NSIndexPath *index_path = [NSIndexPath indexPathForRow:7 inSection:0];
    [indexPaths addObject:index_path];
    if ( indexPaths.count ) {
        [theTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    if ( isDoctor ) {
        [theTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:9 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [theTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:9 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [theTableView endUpdates];

}

// 提交注册 按钮点击
- (void)submitDidClick:(id)sender
{
    if ( myType == typePersonal ) {
        // 个人注册
        [self personalRegister];
    }
    else{
        // 企业 注册
        [self companyRegister];
    }
}
// 获取验证码
- (void)getSecurityCode
{
    if ( [ShowBox alertPhoneNo:registerData.userPhone] ) {
        return;
    }
    [securityCodeBtn setEnabled:NO];
    __weak typeof(self) wSelf = self;
    if ( [ShowBox checkCurrentNetwork] ) {
        [NetRequestAPI getRegSMS_codeWithPhoneNumber:registerData.userPhone
                                             success:^(id responseDic) {
//                                                 NSLog(@"获取短信验证码：responseDic  %@",responseDic);
                                                 [wSelf startRuntime];
                                                 NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
                                                 BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                                 if ( !success ) {
                                                     [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"网络出错，请稍候重试！"]];
                                                 }
            
        } failure:^(id errorString) {
//            NSLog(@"获取短信验证码：errorString  %@",errorString);
            [wSelf startRuntime];
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
        [self securityCodeBtnTypeChangeWithBool:YES];
        [securityCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [myTimer invalidate];
    }
    else{
        NSString *timeString = [NSString stringWithFormat:@"%li s重发",(long)currentTime];
        [securityCodeBtn setTitle:timeString forState:UIControlStateDisabled];
    }
}

// 获取验证码按钮是否 可以点击
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"textField.text : %@",textField.text);
//    NSLog(@"string :::: %@",string);
    
    if ( textField == userPhoneText ) {
        NSString *phone = textField.text;
        if ( ![ShowBox isEmptyString:string] ) {
            phone = [phone stringByAppendingString:string];
        }
        registerData.userPhone = phone;
//        NSLog(@"userPhone : %@",registerData.userPhone);
    }
    
    if ( [ShowBox isEmptyString:string] ) {
        return YES;
    }
    
    NSUInteger textLength = [Utils getTextFieldActualLengthWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    if ( textField == userPhoneText ) {
        if ( textLength > 11 ) {
            return NO;
        }
    }
    
    if ( textField == securityCodeText ) {
        if ( textLength > 6 ) {
            return NO;
        }
    }
    
    if ( textField == passWordText || textField == repetPasswordText ) {
        if ( textLength > 20 ) {
            return NO;
        }
    }
    
    if ( textField == commanyPhoneText ) {
        if ( textLength >= 25 ) {
            return NO;
        }
    }
    
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
        else if ( textField == qualificationsText ){
            registerData.userQualifications = textField.text;
        }
    }
}

#pragma mark - 个人注册数据 处理
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
    
    if ( isDoctor ) {
        if ( [ShowBox isEmptyString:registerData.userQualifications]) {
            [ShowBox showError:@"请填写职称"];
            return;
        }
    }

    NSArray * imgArray = [proofImgView getImgArray];
    if ( imgArray.count <= 0 ) {
        [ShowBox showError:@"请选择证件图片"];
        return;
    }
    [self personalRegisterNet];
}

/**
 *  取相册中 图片
 *
 *  @param asset 相册返回的 图片类型
 *
 *  @return 返回 UIImage
 */
- (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

// 个人注册 提交网络
- (void)personalRegisterNet
{
    if ( [ShowBox checkCurrentNetwork] ) {
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeGradient];
        __weak typeof(self) wSelf = self;
        [submitBtn setEnabled:NO];
        NSArray * imgArray = [proofImgView getImgArray];
        ALAsset *alas = [imgArray objectAtIndex:0];
        UIImage *img = [self fullResolutionImageFromALAsset:alas];
        
        // 设置职称
        NSString *qualifications;
        // 设置专业
        NSString *professional;
        // 设置职务
        NSString *position;
        if ( isDoctor ) {
            qualifications = registerData.userQualifications;
            professional = registerData.userRofessional;
            position = registerData.userPosition;
        }
        else{
            qualifications = nil;
            professional = registerData.userIdentity;
            position = registerData.userOrdinaryPosition;
        }
        [NetRequestAPI submitRegisterDataWithUserName:registerData.userPhone
                                                 code:registerData.userSecurityCode
                                             password:registerData.userPassword
                                               doctor:isDoctor
                                         professional:professional
                                             realname:registerData.userName
                                             position:position
                                              company:registerData.userCompany
                                           occupation:qualifications
                                                image:img
                                              success:^(id responseDic) {
                                                  NSLog(@" 提交注册 responseDic: %@",responseDic);
                                                  [submitBtn setEnabled:YES];
                                                  [SVProgressHUD dismiss];
                                                  [wSelf manageRegisterNetWithDict:responseDic];
                                                  
                                              } failure:^(id errorString) {
                                                  NSLog(@" 提交注册 errorString: %@",errorString);
                                                  [submitBtn setEnabled:YES];
                                                  [SVProgressHUD dismiss];
                                                  [ShowBox showError:@"提交失败，请稍候重试"];
                                              }];
    }
}

-(void)manageRegisterNetWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"服务器出错，请稍候重试"]];
        return;
    }
    [self successReguster];
//
//
//    [self uploadImageWithUid:uid];
}

///**
// *uid 是提交资料时 后台生产 的uid
// */
//- (void)uploadImageWithUid:(NSString *)uid
//{
//    NSArray * imgArray = [proofImgView getImgArray];
//    if ( imgArray.count <= 0 || [ShowBox isEmptyString:uid] ) {
//        [SVProgressHUD dismiss];
//        [ShowBox showError:@"数据出错"];
//        return;
//    }
//    ALAsset *alas = [imgArray objectAtIndex:0];
//    UIImage *img = [self fullResolutionImageFromALAsset:alas];
//    __weak typeof(self) wSelf = self;
//    [NetRequestAPI uploadImageWithImage:img uid:uid success:^(id responseDic) {
//        [SVProgressHUD dismiss];
//        //        NSLog(@"上传图片 responseDic%@",responseDic);
//        NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
//        BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
//        if ( !success ) {
//            [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据出错，请稍候重试"]];
//            return ;
//        }
//        [wSelf successReguster];
//    } failure:^(id errorString) {
//        [SVProgressHUD dismiss];
//        [ShowBox showError:@"上传失败，请稍候重试"];
//        NSLog(@"上传图片 errorString%@",errorString);
//    }];
//}

/**
 *个人注册成功
 */
-(void)successReguster
{
    // 清除 之前的 账号信息
    [RYUserInfo logout];
    
    // 用户注册成功 记住用户名和密码
    NSMutableDictionary *savedDic = [[NSMutableDictionary alloc] init];
    [savedDic setValue:registerData.userPhone forKey:USERNAME];
    [savedDic setValue:registerData.userPassword forKey:PASSWORD];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:LoginText];
    [savedDic writeToFile:path atomically:YES];
    
    NSArray *controllers = self.navigationController.viewControllers;
    for ( UIViewController *vc in controllers) {
        if ( [vc isKindOfClass:[RYLoginViewController class]] ) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}


#pragma mark - 企业注册 数据处理

-(void)companyRegister
{
    if ( [ShowBox isEmptyString:registerData.companyType] ) {
        [ShowBox showError:@"请选择企业类型"];
        return;
    }
    if ( [ShowBox isEmptyString:registerData.companyName] ) {
        [ShowBox showError:@"输入企业名称"];
        return;
    }
    if ( [ShowBox isEmptyString:registerData.companyContactPerson] ) {
        [ShowBox showError:@"请输入联系人"];
        return;
    }
    if ( [ShowBox isEmptyString:registerData.companyPhone] || registerData.companyPhone.length < 7 || registerData.companyPhone.length > 25 ) {
        [ShowBox showError:@"请输入正确的联系电话"];
        return;
    }
    if ( [ShowBox isEmptyString:registerData.companyEmail] || ![ShowBox isValidateEmail:registerData.companyEmail]) {
        [ShowBox showError:@"请输入正确邮箱"];
        return;
    }
    [self companyRegisterNet];
}

// 企业注册 提交网络
- (void)companyRegisterNet
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeGradient];
        [NetRequestAPI submitCompanyRegisterWithType:registerData.companyType
                                             company:registerData.companyName
                                                name:registerData.companyContactPerson
                                                 tel:registerData.companyPhone
                                               email:registerData.companyEmail
                                             success:^(id responseDic) {
                                                  NSLog(@"企业注册 responseDic: %@",responseDic);
                                                 [SVProgressHUD dismiss];
                                                 [wSelf manageCompanyRegisterNetWithDict:responseDic];
                                             } failure:^(id errorString) {
                                                 NSLog(@"企业注册 errorString：%@",errorString);
                                                 [SVProgressHUD dismiss];
                                             }];
    }
}

-(void)manageCompanyRegisterNetWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"服务器出错，请稍候重试"]];
        return;
    }
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    
    RYCompanyRegisterSuccessViewController *vc = [[RYCompanyRegisterSuccessViewController alloc] initWithDict:info];
    [self.navigationController pushViewController:vc animated:YES];

}
@end
