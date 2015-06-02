//
//  RYTokenView.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/22.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYTokenView.h"
#import "SelectLabelGroup.h"


#define WordNumber 10


@interface RYTokenView ()<ZFTokenFieldDataSource,ZFTokenFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton            *transparencyBtn;
@property (nonatomic,strong)UIView              *BGView;
@property (nonatomic,strong)UIView              *submitView;     //  提交／删除 按钮view

@property (nonatomic,strong)ZFTokenField        *tokenField;
@property (nonatomic,strong)NSMutableArray      *tokens;

@property (nonatomic,strong)UITableView         *tableView;      //

@end

@implementation RYTokenView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithTokenArray:(NSArray *)array
{
    self = [super init];
    
    if (self) {
        self.recommendedTokenArray = array;
    }
    return self;
}

- (void)showTokenView
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.transparencyBtn];
    [self addSubview:self.BGView];
    self.tokenField.height = 0;
    self.submitView.hidden = YES;
    
    [self.BGView addSubview:self.tokenField];
    [self.tokenField.textField becomeFirstResponder];
    
    [self addSubview:self.tableView];
    self.tableView.top = 60;
    
    [self addSubview:self.submitView];
    
    [UIView animateWithDuration:0 animations:^{
        self.BGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT);
        self.tokenField.height = VIEW_HEIGHT - 85;
        self.tableView.height = VIEW_HEIGHT - 115;
    } completion:^(BOOL finished) {
         self.submitView.hidden = NO;
    }];
    
}
- (void)dismissTokenView
{
    [self.tokens removeAllObjects];
    [self.tokenField reloadData];
    self.submitView.hidden = YES;
    [UIView animateWithDuration:0 animations:^{
        self.BGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.tokenField.height = 0;
        self.tableView.height = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIButton *)transparencyBtn
{
    if ( _transparencyBtn == nil ) {
        _transparencyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _transparencyBtn.backgroundColor = [Utils getRGBColor:0 g:0 b:0 a:0.5];
        [_transparencyBtn addTarget:self action:@selector(dismissTokenView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transparencyBtn;
}

- (UIView *)BGView
{
    if (_BGView==nil) {
        _BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _BGView.backgroundColor = [UIColor whiteColor];
    }
    return _BGView;
}

- (ZFTokenField *)tokenField
{
    if ( _tokenField == nil ) {
        _tokenField = [[ZFTokenField alloc] initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH - 30, 0)];
        _tokenField.backgroundColor = [UIColor clearColor];
        _tokenField.dataSource = self;
        _tokenField.delegate = self;
        _tokenField.textField.font = [UIFont systemFontOfSize:16];
        _tokenField.textField.placeholder = @"请输入标签";
    }
    return _tokenField;
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

- (UIView *)submitView
{
    if ( _submitView == nil ) {
        _submitView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-56, SCREEN_WIDTH, 40)];
        
        _submitView.backgroundColor = [UIColor clearColor];
        
        UIButton *submitBtn = [Utils getCustomLongButton:@"确定"];
        [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.frame = CGRectMake(16, 0, 140, 40);
        [_submitView addSubview:submitBtn];
        
        UIButton *cancelBtn = [Utils getCustomLongButton:@"取消"];
        cancelBtn.frame = CGRectMake(submitBtn.right + 8, 0, 140, 40);
        cancelBtn.backgroundColor = [Utils getRGBColor:0xd8 g:0xd8 b:0xd8 a:1.0];
        [cancelBtn addTarget:self action:@selector(dismissTokenView) forControlEvents:UIControlEventTouchUpInside];
        [_submitView addSubview:cancelBtn];
    }
    return _submitView;
}

- (void)submitBtnClick
{
    NSLog(@"提交");
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
    NSLog(@"row : %d",row);
    return row * 8 + row * 26 + 8;
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
    self.tableView.height = VIEW_HEIGHT - 66 - (offsetY + 8 + 30);
    
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self cellHeightWithArrar:self.recommendedTokenArray];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *token_Cell = @"token_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:token_Cell];
    CGFloat height = [self cellHeightWithArrar:self.recommendedTokenArray];
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
    
    [selectLabel setItems:self.recommendedTokenArray];
    __weak typeof(RYTokenView) *wSelf = self;
    selectLabel.itemClick = ^(SelectLabelGroup* lable, int i){
        RYTokenView *sSelf = wSelf;
        if (sSelf.tokens.count < 4) {
            
            if ( lable.tag - 1230 == 0  ) {
                sSelf.tokenField.textField.text = [sSelf.recommendedTokenArray objectAtIndex:i];
            }
            else{
                sSelf.tokenField.textField.text = [sSelf.recommendedTokenArray objectAtIndex:i];
            }
            [sSelf tokenField:sSelf.tokenField didReturnWithText:[sSelf.recommendedTokenArray objectAtIndex:i]];
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
    return 28;
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


@end
