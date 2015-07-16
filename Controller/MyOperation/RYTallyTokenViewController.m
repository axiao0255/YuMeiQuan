//
//  RYTallyTokenViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYTallyTokenViewController.h"
#import "ZFTokenField.h"
#import "SelectLabelGroup.h"
#import "RYTokenView.h"


#define WordNumber 10

@interface RYTallyTokenViewController ()<ZFTokenFieldDataSource,ZFTokenFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView         *tableView;      //
@property (nonatomic,strong)ZFTokenField        *tokenField;
@property (strong,nonatomic) NSArray            *officialTagsArr; // 默认标签
@property (strong,nonatomic) NSArray            *customTagsArr;   // 自定义标签
@property (strong,nonatomic) NSString           *articleID;       // 文章id
@property (nonatomic,strong)NSMutableArray      *tokens;

@property (nonatomic,strong)NSString            *tid;             // 文章id


@end


@implementation RYTallyTokenViewController

-(id)initWithTid:(NSString *)tid
{
    self = [super init];
    if ( self ) {
        self.tid = tid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tokenField];
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
        [NetRequestAPI getEditTallyWithSessionId:[RYUserInfo sharedManager].session
                                             tid:self.tid
                                         success:^(id responseDic) {
                                             NSLog(@"编辑标签 ：responseDic %@",responseDic);
            
        } failure:^(id errorString) {
            NSLog(@"编辑标签 ：errorString %@",errorString);
        }];
    }
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 115)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (ZFTokenField *)tokenField
{
    if ( _tokenField == nil ) {
        _tokenField = [[ZFTokenField alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, VIEW_HEIGHT - 85)];
        _tokenField.backgroundColor = [UIColor clearColor];
        _tokenField.dataSource = self;
        _tokenField.delegate = self;
        _tokenField.textField.font = [UIFont systemFontOfSize:16];
        _tokenField.textField.placeholder = @"请输入标签";
    }
    return _tokenField;
}

-(NSMutableArray *)tokens
{
    if (_tokens == nil) {
        _tokens = [NSMutableArray array];
    }
    return _tokens;
}


- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self.tokenField indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.tokens removeObjectAtIndex:index];
        [self.tokenField reloadData];
    }
}

#pragma mark - ZFTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    return 24;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    return self.tokens.count;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    UILabel *label = [[UILabel alloc] init];
    label.text = self.tokens[index];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
    CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, 24)];
    label.frame = CGRectMake(4, 0, size.width, 24);
    view.frame = CGRectMake(0, 0, size.width + 30, 24);
    [view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(view.width-22, 2, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"ic_token_close.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    
    return view;
}

- (void)textFieldViewOffsetY:(CGFloat)offsetY
{
    NSLog(@"aaaa");
//    self.tableView.top = offsetY + 8 + 30;
//    self.tableView.height = VIEW_HEIGHT - 66 - (offsetY + 8 + 30);
    
}


#pragma mark - ZFTokenField Delegate
- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}

- (void)tokenField:(ZFTokenField *)tokenField didReturnWithText:(NSString *)text
{
    if ( text.length ) {
        BOOL isExist = NO;
        for ( NSString *string in self.tokens ) {
            if ( [string isEqualToString:text] ) {
                isExist = YES;
            }
        }
        if ( !isExist ) {
            if ( text.length >= WordNumber ) {
                text = [text substringToIndex:WordNumber];
            }
            [self.tokens addObject:text];
        }
    }
    [tokenField reloadData];
}

- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    [self.tokens removeObjectAtIndex:index];
}

- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    if ( textField.textField.text.length ) {
        return NO;
    }
    else{
        return YES;
    }
}

- (BOOL)tokenField:(ZFTokenTextField *)tokenField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( self.tokens.count >= 4 && string.length ) {
        [ShowBox showError:@"最多只能有4个标签"];
        [tokenField resignFirstResponder];
        return NO;
    }
    UITextRange *markRange = tokenField.markedTextRange;
    // pos是当前输入的高亮部分长度
    NSInteger pos = [tokenField offsetFromPosition:markRange.start
                                        toPosition:markRange.end];
    //获取高亮部分
    if ( pos > 0 ) {
        if ( tokenField.text.length > pos ) {
            // 获取当前有效的文字
            NSString *validStr = [NSString stringWithFormat:@"%@",[tokenField.text substringToIndex:tokenField.text.length - pos]];
            if ( validStr.length >= WordNumber && string.length ) {
                [ShowBox showError:[NSString stringWithFormat:@"每个标签最多不超过%i字",WordNumber]];
                [tokenField resignFirstResponder];
                return NO;
            }
        }
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            if ( tokenField.text.length >= WordNumber*2 && string.length ) {
                [ShowBox showError:[NSString stringWithFormat:@"每个标签最多不超过%i字",WordNumber]];
                [tokenField resignFirstResponder];
                return NO;
            }
        }
        else{ // 其他键盘
            if ( tokenField.text.length >= WordNumber && string.length ) {
                [ShowBox showError:[NSString stringWithFormat:@"每个标签最多不超过%i字",WordNumber]];
                [tokenField resignFirstResponder];
                return NO;
            }
        }
    }
    else{
        if ( tokenField.text.length >= WordNumber && string.length ) {
            [ShowBox showError:[NSString stringWithFormat:@"每个标签最多不超过%i字",WordNumber]];
            [tokenField resignFirstResponder];
            return NO;
        }
    }
    return YES;
}



@end
