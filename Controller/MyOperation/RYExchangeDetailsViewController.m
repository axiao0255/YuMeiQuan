//
//  RYExchangeDetailsViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYExchangeDetailsViewController.h"
#import "RYExchangeDetailsTableViewCell.h"

@interface RYExchangeDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic , strong)UITableView    *tableView;
@property (nonatomic , strong)NSDictionary   *exchangeDict;
@property (nonatomic , strong)UITextField    *nameTextField;
@property (nonatomic , strong)UITextField    *addressTextField;
@property (nonatomic , strong)UITextField    *phoneTextField;

@end

@implementation RYExchangeDetailsViewController

-(id)initWithExchangeDict:(NSDictionary *)dict
{
    self = [super init];
    if ( self ) {
        self.exchangeDict = dict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分兑换";
    [self.view addSubview:self.tableView];
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

-(UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        return 190;
    }
    else if ( indexPath.row == 1 ){
        NSString *subject = [self.exchangeDict getStringValueForKey:@"subject" defaultValue:@""];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGRect rect = [subject boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attributes
                                                       context:nil];
        return 10 + rect.size.height;
    }
    else if ( indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 ){
        return 55;
    }
    else if ( indexPath.row == 5 ){
        return 26;
    }
    else{
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        NSString *top_cell = @"top_cell";
        RYExchangeDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:top_cell];
        if (!cell) {
            cell = [[RYExchangeDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:top_cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setValueWithDict:self.exchangeDict];
        return cell;
    }
    else if ( indexPath.row == 1 ){
        NSString *subject_cell = @"subject_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subject_cell];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subject_cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        }
        cell.textLabel.text = [self.exchangeDict getStringValueForKey:@"subject" defaultValue:@""];
        return cell;
    }
    else if ( indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 ){
        NSString *textField_cell = @"textField_cell";
        RYExchangeTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textField_cell];
        if ( !cell ) {
            cell = [[RYExchangeTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textField_cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textField.delegate = self;
        if ( indexPath.row == 2 ) {
            self.nameTextField = cell.textField;
            self.nameTextField.placeholder = @"姓名";
            self.nameTextField.text = [RYUserInfo sharedManager].realname;
        }
        else if ( indexPath.row == 3 ){
            self.addressTextField = cell.textField;
            self.addressTextField.placeholder = @"地址";
        }
        else{
            self.phoneTextField = cell.textField;
            self.phoneTextField.placeholder = @"电话";
            self.phoneTextField.text = [RYUserInfo sharedManager].username;
        }
        return cell;
    }
    else if ( indexPath.row == 5 ){
        NSString *number_cell = @"number_cell";
        RYExchangeNumberSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:number_cell];
        if ( !cell ) {
            cell = [[RYExchangeNumberSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:number_cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setValueWithDict:self.exchangeDict];
        return cell;
    }
    else{
        NSString *buttom_cell = @"buttom_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:buttom_cell];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttom_cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *btn = [Utils getCustomLongButton:@"立即兑换"];
            [btn addTarget:self action:@selector(exchangeSubmit:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(SCREEN_WIDTH/2 - 240/2, 16, 240, 44);
            btn.tag = 120;
            [cell.contentView addSubview:btn];
        }
        UIButton *btn = (UIButton *)[cell.contentView viewWithTag:120];
        NSInteger jifen = [self.exchangeDict getIntValueForKey:@"jifen" defaultValue:0];
        NSInteger myJifen = [[RYUserInfo sharedManager].credits integerValue];
        if ( myJifen >= jifen ) {
            [btn setEnabled:YES];
            [btn setBackgroundColor:[Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0]];
            [btn setTitle:@"立即兑换" forState:UIControlStateNormal];
        }
        else{
            [btn setEnabled:NO];
            [btn setBackgroundColor:[Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0]];
            [btn setTitle:@"积分不足" forState:UIControlStateNormal];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 提交兑换
-(void)exchangeSubmit:(id)sender
{
    NSLog(@"提交兑换");
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
