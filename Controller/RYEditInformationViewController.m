//
//  RYEditInformationViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/8/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYEditInformationViewController.h"
#import "RYRegisterSpecialtyViewController.h"
#import "RYRegisterData.h"
#import "NYSegmentedControl.h"
#import "imagesView.h"

@interface RYEditInformationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RYRegisterSpecialtyDelegate>
{
    UITextField *identityText;          // 专业
    UITextField *userNameText;          // 姓名
    UITextField *positionText;          // 职位
    UITextField *qualificationsText;    // 职称
    UITextField *departmentText;        // 所属单位
    
    UIButton    *identityBtn;         // 专业选择 按钮
    UIButton    *positionBtn;         // 职务选择按钮
    UIButton    *qualificationsBtn;   // 职称按钮
    
    imagesView  *proofImgView;        // 上传凭证视图
    
    NSString    *imagePath;           // 证件路径
    
    RYRegisterData *registerData;     // 注册数据


}

@property (nonatomic , strong) UITableView    *tableView;
@property (nonatomic , assign) BOOL           isDoctor;
@property (nonatomic , strong) UIView         *tooBar;
@property (nonatomic , strong) UIImageView    *topView;


@end

@implementation RYEditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改资料";
    [self.view addSubview:self.tableView];
    [self getNetData];
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

- (void)getNetData
{
    if ( [ShowBox checkCurrentNetwork] ) {
         __weak typeof(self) wSelf = self;
        [NetRequestAPI getEditInformationWithSessionId:[RYUserInfo sharedManager].session
                                               success:^(id responseDic) {
                                                   NSLog(@"编辑数据 responseDic： %@",responseDic);
                                                    [wSelf analysisDataWithDict:responseDic];
            
        } failure:^(id errorString) {
              NSLog(@"编辑数据 errorString： %@",errorString);
            [wSelf showErrorView:wSelf.tableView];
        }];
    }
    else{
        [self showErrorView:self.tableView];
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [self showErrorView:self.tableView];
        return;
    }
    [self removeErroeView];
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    
    
    registerData = [[RYRegisterData alloc] init];
    // 个人
    registerData.doctorSpecialtyArray = @[@"皮肤科医生",@"整形外科医生",@"其他临床专业"];
    registerData.ordinarySpecialtyArray = @[@"临床助理",@"医学生",@"咨询师",@"厂商人员",@"医疗机构人员",@"协会人员",@"其他专业"];
    registerData.doctorPositionArray = @[@"院长",@"科主任",@"科室副主任",@"医生",@"其他职务"];
    registerData.ordinaryPositionArray = @[@"营销总监",@"销售人员",@"市场人员",@"其他职务"];
    registerData.QualificationsArray = @[@"住院医师",@"主治医师",@"副主任医师",@"主任医师",@"其他职称"];

    
    // 用户名字
    registerData.userName = [info getStringValueForKey:@"realname" defaultValue:@""];
    // 单位名称
    registerData.userCompany = [info getStringValueForKey:@"company" defaultValue:@""];
    // 是否医生
    self.isDoctor = [info getBoolValueForKey:@"doctor" defaultValue:NO];
    
    if (self.isDoctor){
        // 医生职务
        registerData.userPosition = [info getStringValueForKey:@"position" defaultValue:@""];
        // 医生专业
        registerData.userRofessional = [info getStringValueForKey:@"professional" defaultValue:@""];
        // 医生职称
        registerData.userQualifications = [info getStringValueForKey:@"occupation" defaultValue:@""];
    }
    else{
        // 非医生职务
        registerData.userOrdinaryPosition = [info getStringValueForKey:@"position" defaultValue:@""];
        // 非医生专业
        registerData.userIdentity = [info getStringValueForKey:@"professional" defaultValue:@""];
    }
    // 图片路径
    imagePath = [info getStringValueForKey:@"file" defaultValue:@""];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tooBar];
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, VIEW_HEIGHT - 90)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (UIView *)tooBar
{
    if ( _tooBar == nil ) {
        _tooBar = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - 50, SCREEN_WIDTH, 50)];
        _tooBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tooBar];
        
        //登录按钮
        UIButton *btnNextStep = [Utils getCustomLongButton:@"完成注册"];
        btnNextStep.frame = CGRectMake(15, 5, SCREEN_WIDTH - 30, 40);
        [btnNextStep addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tooBar addSubview:btnNextStep];
    }
    return _tooBar;
}

- (UIImageView *)topView
{
    if (_topView == nil ) {
        _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _topView.image = [UIImage imageNamed:@"ic_uploadVIew_top.png"];
        UILabel *label = [[UILabel alloc] initWithFrame:_topView.bounds];
        [_topView addSubview:label];
        [label setTextColor:[Utils getRGBColor:0x12 g:0x73 b:0xb7 a:1.0]];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"账号审核失败，请修改资料重提交"];
    }
    return _topView;
}

- (void)submitBtnClick:(id)sender
{
    if ( self.isDoctor ) {
        if ( [ShowBox isEmptyString:registerData.userRofessional] ) {
            [ShowBox showError:@"请选择专业"];
            return;
        }
        
        if ( [ShowBox isEmptyString:registerData.userPosition] ) {
            [ShowBox showError:@"请选择职务"];
            return;
        }
        
        if ( [ShowBox isEmptyString:registerData.userQualifications] ) {
            [ShowBox showError:@"请选择职称"];
            return;
        }
    }
    else{
        if ( [ShowBox isEmptyString:registerData.userIdentity] ) {
            [ShowBox showError:@"请选择身份"];
            return;
        }
        if ( [ShowBox isEmptyString:registerData.userOrdinaryPosition] ) {
            [ShowBox showError:@"请选择职务"];
            return;
        }
    }
    
    if ( [ShowBox isEmptyString:registerData.userName] ) {
        [ShowBox showError:@"请输入姓名"];
        return;
    }
    if ( [ShowBox isEmptyString:registerData.userCompany] ) {
        [ShowBox showError:@"请填写单位"];
        return;
    }
    
    NSArray * imgArray = [proofImgView getImgArray];
    if ( imgArray.count <= 0 ) {
        [ShowBox showError:@"请选择证件图片"];
        return;
    }

    [self submitRegisterNet];
}

- (void)submitRegisterNet
{
    if ( [ShowBox checkCurrentNetwork] ) {
        
        NSArray * imgArray = [proofImgView getImgArray];
        id imgPath = [imgArray objectAtIndex:0];
        UIImage *img;
        // 检查图片是本地图片 还是网络图片
        if ( [imgPath isKindOfClass:[NSString class]] && [imgPath isEqualToString:imagePath] ) {
            img = nil;
        }
        else{
            ALAsset *alas = [imgArray objectAtIndex:0];
            img = [self fullResolutionImageFromALAsset:alas];
        }
        // 设置专业
        NSString *professional;
        // 设置职务
        NSString *position;
        // 设置职称
        NSString *qualifications;
        if ( self.isDoctor ) {
            qualifications = registerData.userQualifications;
            professional = registerData.userRofessional;
            position = registerData.userPosition;
        }
        else{
            qualifications = nil;
            professional = registerData.userIdentity;
            position = registerData.userOrdinaryPosition;
        }
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeGradient];
        __weak typeof(self) wSelf = self;
        [NetRequestAPI submitEditInformationWithSessionId:[RYUserInfo sharedManager].session
                                                   doctor:self.isDoctor
                                             professional:professional
                                                 realname:registerData.userName
                                                 position:position
                                                  company:registerData.userCompany
                                               occupation:qualifications
                                                    image:img
                                                  success:^(id responseDic) {
                                                       [SVProgressHUD dismiss];
//                                                      NSLog(@"编辑提交 responseDic :: %@",responseDic);
                                                      NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
//                                                      NSLog(@"%@",[meta getStringValueForKey:@"msg" defaultValue:@"数据出错"]);
                                                      BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
                                                      if ( !success ) {
                                                          [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"网络出错，请稍候重试！"]];
                                                          return ;
                                                      }
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:nil];
                                                      [wSelf.navigationController popViewControllerAnimated:YES];
            
        } failure:^(id errorString) {
             [SVProgressHUD dismiss];
            [ShowBox showError:@"网络出错，请稍候重试！"];
//              NSLog(@"编辑提交 errorString :: %@",errorString);
        }];
    }
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


#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( registerData == nil ) {
        return 0;
    }
    else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        if ( self.isDoctor ) {
            return 7;
        }
        else{
            return 6;
        }
    }
    else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return 52;
    }
    else{
        return 115;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( indexPath.row == 0 ) {
            NSString *phone_cell = @"phone_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phone_cell];
            if ( !cell ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:phone_cell];
                cell.backgroundColor = [UIColor clearColor];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = [RYUserInfo sharedManager].username;
            return cell;
        }
        else{
            switch ( indexPath.row ) {
                case 1:
                    return [self doctorCellTableView:tableView indexPath:indexPath];
                    break;
                case 2:
                case 4:
                case 6:
                    return [self career_cell_tableView:tableView indexPath:indexPath];
                    break;
                case 3:
                case 5:
                    return [self customTableView:tableView indexPath:indexPath];
                default:
                    return nil;
                    break;
            }
        }
    }
    else{
        return [self picTableView:tableView indexPath:indexPath];
    }
}

#pragma mark 姓名和单位
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
        textField.tag = 1010;
        [cell.contentView addSubview:textField];
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1010 ];
    [textField setSecureTextEntry:NO];
    [textField setEnabled:YES];
    switch (indexPath.row) {
        case 3:
        {
            userNameText = textField;
            userNameText.text = registerData.userName;
            userNameText.placeholder = @"姓名";
        }
            break;
        case 5:
        {
            departmentText = textField;
            departmentText.text = registerData.userCompany;
            departmentText.placeholder = @"单位";

        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark 职务，职称，专业 cell
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
    if ( indexPath.row == 2 ) {
        identityBtn = btn;
        identityText = textField;
        if ( self.isDoctor ) {
            identityText.text = registerData.userRofessional;
            identityText.placeholder = @"临床专业";
        }
        else{
            identityText.text = registerData.userIdentity;
            identityText.placeholder = @"身份";
        }
    }
    else if(indexPath.row == 4){
        positionBtn = btn;
        positionText = textField;
        positionText.placeholder = @"职务";
        if ( self.isDoctor ) {
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

// 专业和职务选择
- (void)identityAndPositionSelect:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSArray * dataArr;
    NSString *title;
    NSUInteger tag;
    
    if ( btn == identityBtn ) {
        tag = 102;
        if ( self.isDoctor ) {
            dataArr = registerData.doctorSpecialtyArray;
            title = @"临床专业";
        }
        else{
            dataArr = registerData.ordinarySpecialtyArray;
            title = @"选择身份";
        }
    }
    else if ( btn == positionBtn ){
        tag = 104;
        title = @"选择职务";
        if ( self.isDoctor ) {
            dataArr = registerData.doctorPositionArray;
            
        }
        else{
            dataArr = registerData.ordinaryPositionArray;
        }
    }
    else{
        tag = 106;
        title = @"选择职称";
        dataArr = registerData.QualificationsArray;
    }
    
    RYRegisterSpecialtyViewController *vc = [[RYRegisterSpecialtyViewController alloc] initWIthSpecialtyArray:dataArr isFillout:YES andTitle:title];
    vc.delegate = self;
    vc.view.tag = tag;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 选中后更新数据
- (void)selectSpecialtyTypeWithTag:(NSUInteger)tag didStr:(NSString *)str
{
    if ( [ShowBox isEmptyString:str] ) {
        return;
    }
    NSIndexPath *indexPath;
    NSUInteger index = tag - 100;
    indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if ( index == 2 ) {
        if ( self.isDoctor ) {
            registerData.userRofessional = str;
        }
        else{
            registerData.userIdentity = str;
        }
    }
    else if ( index == 4 ){
        if ( self.isDoctor ) {
            registerData.userPosition = str;
        }else{
            registerData.userOrdinaryPosition = str;
        }
    }
    else{
        registerData.userQualifications = str;
    }
    
    if ( indexPath ) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}


#pragma mark 图片选择
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
    [proofImgView setImagesArray:@[imagePath]];
    return cell;
}


#pragma mark 是否医生 cell
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
        segmentedControl.tag = 2020;
        [cell.contentView addSubview:segmentedControl];
    }
    NYSegmentedControl *segmentedControl = (NYSegmentedControl *)[cell.contentView viewWithTag:2020];
    if ( self.isDoctor ) {
        [segmentedControl setSelectedSegmentIndex:0];
    }
    else{
        [segmentedControl setSelectedSegmentIndex:1];
    }
    
    return cell;
}

// 是否医生按钮点击
- (void)segmentSelectedControl:(NYSegmentedControl *)sender
{
    NSUInteger index = sender.selectedSegmentIndex;
    if ( index == 0 ) {
        self.isDoctor = YES;
    }
    else{
        self.isDoctor = NO;
    }
    [self.tableView beginUpdates];
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [indexPaths addObject:indexPath];
    NSIndexPath *index_path = [NSIndexPath indexPathForRow:4 inSection:0];
    [indexPaths addObject:index_path];
    if ( indexPaths.count ) {
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    if ( self.isDoctor ) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self.tableView endUpdates];
    
}

#pragma mark -textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( textField == identityText ){      // 专业
        if ( self.isDoctor ) {
           registerData.userRofessional = textField.text;
        }else{
            registerData.userIdentity = textField.text;
        }
    }
    else if ( textField == userNameText ){  // 姓名
        registerData.userName = textField.text;
    }
    else if ( textField == positionText ){   // 职务
        if ( self.isDoctor ) {
            registerData.userPosition = textField.text;
        }else{
            registerData.userOrdinaryPosition = textField.text;
        }
    }
    else if ( textField == departmentText ){  // 单位
        registerData.userCompany = textField.text;
    }
    else if ( textField == qualificationsText ){ // 职称
       registerData.userQualifications = textField.text;
    }

}

@end
