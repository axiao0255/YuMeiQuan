//
//  RYRegisterSpecialtyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYRegisterSpecialtyViewController.h"
#import "RYRegisterSpecialtyTableViewCell.h"

@interface RYRegisterSpecialtyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray          *specialtyArray;
    BOOL             isFillout;
    UITableView      *theTableView;
    NSString         *sf_title;
    UITextField      *sf_textField;
}
@end

@implementation RYRegisterSpecialtyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
    self.title = sf_title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWIthSpecialtyArray:(NSArray *)array isFillout:(BOOL)fillout andTitle:(NSString *)title
{
    self = [super init];
    if ( self ) {
        if ( array && array.count > 0 ) {
            specialtyArray = [NSArray arrayWithArray:array];
        }
        isFillout = fillout;
        if ( title.length ) {
            sf_title = title;
        }
        else{
            sf_title = @"";
        }
    }
    return self;
}


- (void) initSubviews
{
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTableView.backgroundColor = [UIColor clearColor];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [self.view addSubview:theTableView];
}

#pragma mark - UITableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return specialtyArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    RYRegisterSpecialtyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[RYRegisterSpecialtyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ( specialtyArray.count ) {
        cell.contentLabel.text = [specialtyArray objectAtIndex:indexPath.row];
        cell.highlightImage = [UIImage imageNamed:@"ic_cell_selected.png"];
        cell.normalImage = [UIImage imageNamed:@"ic_cell_unselected.png"];
    }
    
    if ( isFillout && indexPath.row == specialtyArray.count - 1 ) {
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:200];
        [textField removeFromSuperview];
        textField= [[UITextField alloc] initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH - 120 - 45, 40)];
        textField.backgroundColor = [UIColor clearColor];
        textField.placeholder = [NSString stringWithFormat:@"请输入%@",[specialtyArray lastObject]];
        textField.tag = 200;
        textField.delegate = self;
        textField.textColor = [Utils getRGBColor:70.0 g:70.0 b:70.0 a:1.0];
        textField.font = [UIFont systemFontOfSize:14];
        sf_textField = textField;
        [cell.contentView addSubview:textField];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"aaa : %ld",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( [self.delegate respondsToSelector:@selector(selectSpecialtyTypeWithTag:didStr:)] ) {
        RYRegisterSpecialtyTableViewCell *cell = (RYRegisterSpecialtyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ( isFillout && indexPath.row == specialtyArray.count - 1 ) {
            [self.delegate selectSpecialtyTypeWithTag:self.view.tag didStr:sf_textField.text];
        }
        else{
            [self.delegate selectSpecialtyTypeWithTag:self.view.tag didStr:cell.contentLabel.text];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
