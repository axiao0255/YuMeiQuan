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

@property (nonatomic,strong)UITableView         *tableView;        //
@property (nonatomic,strong)ZFTokenField        *tokenField;
@property (strong,nonatomic) NSString           *articleID;        // 文章id
@property (nonatomic,strong)NSMutableArray      *tokens;

@property (nonatomic,strong)NSString            *tid;              // 文章id
@property (nonatomic,strong)NSMutableArray      *systemTallyArray; // 系统标签数组
@property (nonatomic,strong)NSMutableArray      *customTallyArray; // 自定义标签
@property (nonatomic,strong)NSArray             *articleTallyArray;//本文已经定义好的标签
@property (nonatomic,strong)UIButton            *submitBtn;        //提交按钮


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
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tokenField];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitBtn];
    self.systemTallyArray = [NSMutableArray array];
    self.customTallyArray = [NSMutableArray array];
    self.articleTallyArray = [NSArray array];
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
        [NetRequestAPI getEditTallyWithSessionId:[RYUserInfo sharedManager].session
                                             tid:self.tid
                                         success:^(id responseDic) {
                                             NSLog(@"编辑标签 ：responseDic %@",responseDic);
                                             [wSelf analysisDataWithDict:responseDic];
            
        } failure:^(id errorString) {
            NSLog(@"编辑标签 ：errorString %@",errorString);
            [ShowBox showError:@"获取数据失败，请稍候重试"];
        }];
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        int  login = [meta getIntValueForKey:@"login" defaultValue:0];
        if ( login == 2 ) {  // login == 2 表示用户已过期 需要重新登录
            [RYUserInfo logout];
            __weak typeof(self) wSelf = self;
            RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
                if ( isLogin ) {
                    NSLog(@"登录完成");
                    // 登录完成 重新获取数据
                    [wSelf getNetData];
                }
            }];
            [self.navigationController pushViewController:nextVC animated:YES];
            return;
        }
        else{
            [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"获取数据失败，请稍候重试"]];
            return;
        }
    }
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( !info ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"获取数据失败，请稍候重试"]];
        return;
    }
    // 系统标签
    NSArray *tagsmessage = [info getArrayValueForKey:@"tagsmessage" defaultValue:nil];

    // 自定义标签
    NSArray *customTagsArray = [info getArrayValueForKey:@"favoritecatmessage" defaultValue:nil];
    
    // 已经拥有的标签
    NSArray *favoritefcidmessage = [info getArrayValueForKey:@"favoritefcidmessage" defaultValue:nil];
    self.articleTallyArray = [self getTagsNameWithArray:favoritefcidmessage];

    
    [self manageTagsWithSystemTags:tagsmessage andCustomArr:customTagsArray];
  
}

- (void)manageTagsWithSystemTags:(NSArray *)systemArr andCustomArr:(NSArray *)customArr;
{
    NSMutableArray  *systemTagsArr = systemArr.mutableCopy;
    NSMutableArray  *customTagsArr = customArr.mutableCopy;
    
    if ( systemTagsArr.count && customTagsArr.count ) {
        for ( NSInteger i = 0 ; i < systemTagsArr.count ; i ++ ) {
            //遍历系统标签
            NSDictionary *systemTagDict = [systemTagsArr objectAtIndex:i];
            NSString     *systemTagName = [systemTagDict getStringValueForKey:@"name" defaultValue:@""];
            if ( [ShowBox isEmptyString:systemTagName] ) {
                [systemTagsArr removeObject:systemTagDict];
                i --;
                continue;
            }
            
            // 遍历 自定义标签
            for ( NSInteger j = 0 ; j < customTagsArr.count; j ++ ) {
                NSDictionary *customTagDict = [customTagsArr objectAtIndex:j];
                NSString     *custopTagName = [customTagDict getStringValueForKey:@"name" defaultValue:@""];
                if ( [ShowBox isEmptyString:custopTagName] ) {
                    [customTagsArr removeObject:customTagDict];
                    j --;
                    continue;
                }
                //如果系统标签和 自定义标签相同 则把该标签从系统标签中移除
                if ( [systemTagName isEqualToString:custopTagName] ) {
                    [systemTagsArr removeObject:systemTagDict];
                    i --;
                    break;
                }
            }
        }
    }
    
    self.systemTallyArray = [self getTagsNameWithArray:systemTagsArr].mutableCopy;
    self.customTallyArray = [self getTagsNameWithArray:customTagsArr].mutableCopy;
    [self.tokens addObjectsFromArray:self.articleTallyArray];
    [self.tokenField reloadData];
    
    [self.tableView reloadData];
}

// 取 标签中的name
- (NSArray *)getTagsNameWithArray:(NSArray *)arr
{
    if ( arr.count == 0 ) {
        return nil;
    }
    NSMutableArray *tempTitleArray = [NSMutableArray array];
    for ( int i = 0 ; i < arr.count; i ++ ) {
        NSDictionary *temDict = [arr objectAtIndex:i];
        NSString *name = [temDict getStringValueForKey:@"name" defaultValue:@""];
        
        if ( ![ShowBox isEmptyString:name] ) {
            [tempTitleArray addObject:name];
        }
    }
    return tempTitleArray;
}


- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, VIEW_HEIGHT - 60 - 60)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [Utils setExtraCellLineHidden:_tableView];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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

- (UIButton *)submitBtn
{
    if ( _submitBtn == nil ) {
        _submitBtn = [Utils getCustomLongButton:@"提交"];
        _submitBtn.frame = CGRectMake(40, VIEW_HEIGHT - 10 - 40, SCREEN_WIDTH - 80, 40);
        [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
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
    self.tableView.top = offsetY + 8 + 30;
    self.tableView.height = VIEW_HEIGHT - (offsetY + 8 + 30) -60;
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


#pragma mark  UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        if (self.systemTallyArray.count) {
            return 1;
        }
        else{
            return 0;
        }
    }
    else{
        if (self.customTallyArray.count) {
            return 1;
        }
        else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        if ( self.systemTallyArray.count ) {
            CGFloat height = [self cellHeightWithArrar:self.systemTallyArray];
            return height;
        }
        else{
            return 0;
        }
    }
    else{
        if ( self.customTallyArray.count ) {
            CGFloat height = [self cellHeightWithArrar:self.customTallyArray];
            return height;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *token_Cell = @"token_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:token_Cell];
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:token_Cell];
        SelectLabelGroup *selectLabel = [[SelectLabelGroup alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, height)];
        selectLabel.tag = 1230 + indexPath.section;
        selectLabel.font = [UIFont systemFontOfSize:14];
        selectLabel.textColor = [UIColor blackColor];
        selectLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:selectLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SelectLabelGroup *selectLabel = (SelectLabelGroup *)[cell.contentView viewWithTag:1230 + indexPath.section];
    selectLabel.height = height;
    if ( indexPath.section == 0 ) {
        [selectLabel setItems:self.systemTallyArray];
    }
    else{
        [selectLabel setItems:self.customTallyArray];
    }
    __weak typeof(self) wSelf = self;
    selectLabel.itemClick = ^(SelectLabelGroup* lable, int i){
        __strong typeof(wSelf) sSelf = wSelf;
        if (sSelf.tokens.count < 4) {
            
            if ( lable.tag - 1230 == 0  ) {
                sSelf.tokenField.textField.text = [sSelf.systemTallyArray objectAtIndex:i];
            }
            else{
                sSelf.tokenField.textField.text = [sSelf.customTallyArray objectAtIndex:i];
            }
            [sSelf tokenField:sSelf.tokenField didReturnWithText:sSelf.tokenField.textField.text];
        }
        else{
            [ShowBox showError:@"最多只能输入4个标签哦！"];
        }
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) {
        if ( self.systemTallyArray.count ) {
            return 28;
        }
        else{
            return 0;
        }
    }
    else{
        if ( self.customTallyArray.count ) {
            return 28;
        }
        else{
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 28)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    if ( section == 0) {
        label.text = @"默认标签";
    }
    else{
        label.text = @"自定义标签";
    }
    [view addSubview:label];
    return view;
}


/**
 *
 * 根据数组 长度 计算 cell的高度
 */
- (CGFloat)cellHeightWithArrar:(NSArray *)array
{
    if ( array.count == 0 ) {
        return 0;
    }
    int row = 1;
    int totalWidth = 0;
    int cl = 0;
    for ( int i = 0 ; i < array.count; i ++ ) {
        NSString *str = [array objectAtIndex:i];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14]];
        cl ++;
        totalWidth += (size.width + 20) + (cl - 1)*8;
        if ( totalWidth > SCREEN_WIDTH - 30 ) {
            row ++ ;
            totalWidth = (size.width + 20) ;//+ 20;
            cl = 0;
        }
    }
    //    NSLog(@"row : %d",row);
    return row * 8 + row * 26 + 8;
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    if ( [ShowBox checkCurrentNetwork] ) {
        UIButton *tempBtn = (UIButton *)sender;
        __weak typeof(self) wSelf = self;
        [tempBtn setEnabled:NO];
        [NetRequestAPI additionCollectWithSessionId:[RYUserInfo sharedManager].session
                                               thid:self.tid
                                               tags:self.tokens
                                            success:^(id responseDic) {
                                                NSLog(@"添加收藏 responseDic : %@",responseDic);
                                                [tempBtn setEnabled:YES];
                                                [wSelf collectWithDict:responseDic];
                                            } failure:^(id errorString) {
                                                NSLog(@"添加收藏 errorString :%@",errorString);
                                                [ShowBox showError:@"收藏失败，请稍候重试"];
                                                [tempBtn setEnabled:YES];
                                            }];
        
    }
}

- (void)collectWithDict:(NSDictionary *)responseDic
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"收藏失败，请稍候重试"]];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectStateChange" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tallyChangeUpdate" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
