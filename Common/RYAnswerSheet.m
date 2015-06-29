//
//  RYAnswerSheet.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYAnswerSheet.h"
#import "RYAnswerSheetTableViewCell.h"

@interface RYAnswerSheet ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UIView       *topView;
@property (nonatomic ,strong) UILabel      *surplusNumLabel; //剩余名额 label
@property (nonatomic ,strong) UIView       *buttomView;
@property (nonatomic ,strong) UIButton     *submitButton;    // 提交按钮

@property (nonatomic ,strong) UITableView  *tableView;

@property (nonatomic ,strong) NSString     *answerStr;

@property (nonatomic ,strong) NSMutableArray  *selectArr;   // 答完题后的 数组

@property (nonatomic ,strong) NSArray         *questions;

@property (nonatomic ,assign) BOOL            isJurisdiction; // 是否有权限答题

@property (nonatomic ,strong) NSString        *qtid;          // 题目的ID


@end

@implementation RYAnswerSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithDataSource:(NSDictionary *)dataSource
{
    self = [super initWithFrame:CGRectZero];
    if ( self ) {
        self.dataDict = dataSource;
    }
    if ( self.dataDict ) {
        [self setup];
    }
//    self.answerStr = @"A.因其独特的作用原理因其独特的作用原理因其独特的作用原理因其独特的作用原理因其独特的作用原理";
    return self;
}

- (void)setDataDict:(NSDictionary *)dataDict
{
    if ( ![_dataDict isEqualToDictionary:dataDict] ) {
        _dataDict = dataDict;
    }
    
    if ( _dataDict ) {
         [self setup];
    }
}

- (void) setup
{
    self.questions = [self getQuestionsWithDict:self.dataDict];
    self.qtid = [self.dataDict getStringValueForKey:@"id" defaultValue:@""];
    self.isJurisdiction = [self.dataDict getBoolValueForKey:@"questions" defaultValue:NO];
    if ( !self.isJurisdiction ) {
        [self.submitButton setEnabled:NO];
        self.submitButton.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAXFLOAT);
    self.tableView.frame = self.frame;
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.buttomView;
    
    // 设置 剩余名额
    NSInteger  num = [self.dataDict getIntValueForKey:@"syminge" defaultValue:0];
    NSString *surplusStr = [NSString stringWithFormat:@"剩余名额%li名",(long)num];
    NSAttributedString *hightForNumStr = [Utils getAttributedString:surplusStr andHightlightString:[NSString stringWithFormat:@"%li",(long)num]];
    [self.surplusNumLabel setAttributedText:hightForNumStr];
}

- (NSArray *)getQuestionsWithDict:(NSDictionary *)dict
{
    if ( dict == nil ) {
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary * q1 = [dict getDicValueForKey:@"q1" defaultValue:nil];
    if ( q1 ) {
        [arr addObject:q1];
    }
    NSDictionary *q2 = [dict getDicValueForKey:@"q2" defaultValue:nil];
    if ( q2 ) {
        [arr addObject:q2];
    }
    NSDictionary *q3 = [dict getDicValueForKey:@"q3" defaultValue:nil];
    if ( q3 ) {
        [arr addObject:q3];
    }
    
    return arr;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (NSMutableArray *)selectArr
{
    if ( _selectArr == nil ) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (UIView *)topView
{
    if ( _topView == nil ) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
        _topView.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
        
        UIView *partitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        partitionView.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
        [_topView addSubview:partitionView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 130, CGRectGetHeight(_topView.bounds) - 8)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.text = @"有奖问答";
        [_topView addSubview:label];
        
        [_topView addSubview:self.surplusNumLabel];
    }
    return _topView;
}

- (UILabel *)surplusNumLabel
{
    if ( _surplusNumLabel == nil ) {
        _surplusNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 130, 8, 130, 35)];
        _surplusNumLabel.font = [UIFont systemFontOfSize:14];
        _surplusNumLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        _surplusNumLabel.textAlignment = NSTextAlignmentRight;
        _surplusNumLabel.backgroundColor = [UIColor clearColor];
    }
    return _surplusNumLabel;
}

- (UIView *)buttomView
{
    if ( _buttomView == nil ) {
        _buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 67)];
        [_buttomView addSubview:self.submitButton];
    }
    return _buttomView;
}

- (UIButton *)submitButton
{
    if ( _submitButton == nil ) {
        _submitButton = [Utils getCustomLongButton:@"提交"];
        _submitButton.frame = CGRectMake(40, 8, SCREEN_WIDTH - 80, 40);
        [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (void)submitButtonClick:(id)sender
{
    NSLog(@"提交");
    
    if ( self.selectArr.count && self.selectArr.count == self.questions.count) {
        for ( NSInteger i = 0; i < self.selectArr.count; i ++ ) {
            NSIndexPath *selectIndexPath = [self.selectArr objectAtIndex:i];
            // 找到 第几道题目
            NSInteger questionIndex = selectIndexPath.section;
            // 取该题目正确答案
            NSDictionary *q = [self.questions objectAtIndex:questionIndex];
            NSInteger rightAnswerIndex = [q getIntValueForKey:@"realanswer" defaultValue:0];
            
            // 匹配 该题是否 回答正确
            NSInteger answerIndex = selectIndexPath.row;
            
            if ( rightAnswerIndex - 1 != answerIndex ) {
                [ShowBox showError:@"亲！回答错误，请重新选择答案"];
                return;
            }
        }
        
        [self submitAnswer];
    }
    else{
        [ShowBox showError:@"亲！请先把题目做完才能提交哦！"];
    }
}
// 提交答案
- (void)submitAnswer
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI answerTheQuestionWithSessionId:[RYUserInfo sharedManager].session
                                                 thid:self.thid
                                                 qtid:self.qtid
                                              success:^(id responseDic) {
                                                  NSLog(@"responseDic :: 回答问题 %@",responseDic);
                                                  [wSelf submitResultWithDict:responseDic];
            
        } failure:^(id errorString) {
            NSLog(@"errorString 回答问题：%@",errorString);
            [ShowBox showError:@"网络出错，请换个环境重试！"];
        }];
    }
}

- (void)submitResultWithDict:(NSDictionary *)responseDic
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"网络出错，请换个环境重试！"];
        return;
    }
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( !meta ) {
        [ShowBox showError:@"网络出错，请换个环境重试！"];
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"网络出错，请换个环境重试！"]];
    }
    else{
        NSString *jifen = [NSString stringWithFormat:@"恭喜！恭喜！得到%@积分！",[self.dataDict getStringValueForKey:@"jifen" defaultValue:@"0"]] ;
        [ShowBox showSuccess:jifen];
    }
    
    if ( [self.delegate respondsToSelector:@selector(submitAnawerDidFinish)] )
    {
        [self.delegate submitAnawerDidFinish];
    }
}

/**
 * 获取整个 答题 view的总高度
 */
- (CGFloat)getAnswerSheetHeight
{
    NSInteger sectionNum = [self numberOfSectionsInTableView:self.tableView];
    CGFloat   height = 0;
    for ( NSInteger i = 0; i < sectionNum; i ++ ) {
        height += [self tableView:self.tableView heightForHeaderInSection:i];
        for ( NSInteger j = 0; j < 3; j ++ ) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            height += [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
        }
    }
    
    height += self.topView.height + self.buttomView.height;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.tableView.frame = self.frame;
    return height;
}

#pragma mark UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.questions.count ) {
        NSDictionary *q = [self.questions objectAtIndex:section];
        NSDictionary *answerDict = [q getDicValueForKey:@"answer" defaultValue:nil];
        return answerDict.allKeys.count;
    }
    else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *q = [self.questions objectAtIndex:indexPath.section];
    NSDictionary *answerDict = [q getDicValueForKey:@"answer" defaultValue:nil];
    NSString *answerStr = @"";
    if ( indexPath.row == 0 ) {
        answerStr = [answerDict getStringValueForKey:@"a" defaultValue:@""];
    }
    else if ( indexPath.row == 1 ){
        answerStr = [answerDict getStringValueForKey:@"b" defaultValue:@""];
    }
    else{
        answerStr = [answerDict getStringValueForKey:@"c" defaultValue:@""];
    }
    
    if ( answerStr.length ) {
        CGSize size = [answerStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 75, MAXFLOAT)];
        return size.height + 32;
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    NSString *string = @"诺龙独有的eMatrix水滴阵替治疗";
//    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
//    return size.height + 16;
    NSDictionary *q = [self.questions objectAtIndex:section];
    NSString *string = [q getStringValueForKey:@"question" defaultValue:@""];
    if ( ![ShowBox isEmptyString:string] ) {
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
        return size.height + 16;
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, height - 16)];
    label.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    [view addSubview:label];
    
    NSDictionary *q = [self.questions objectAtIndex:section];
    NSString *string = [q getStringValueForKey:@"question" defaultValue:@""];
    label.text = string;

    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_1 = @"cell_1";
    RYAnswerSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_1];
    if ( !cell ) {
        cell = [[RYAnswerSheetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_1];
    }
    
    NSDictionary *q = [self.questions objectAtIndex:indexPath.section];
    NSDictionary *answerDict = [q getDicValueForKey:@"answer" defaultValue:nil];
    NSString *answerStr = @"";
    if ( indexPath.row == 0 ) {
        answerStr = [answerDict getStringValueForKey:@"a" defaultValue:@""];
    }
    else if ( indexPath.row == 1 ){
        answerStr = [answerDict getStringValueForKey:@"b" defaultValue:@""];
    }
    else{
        answerStr = [answerDict getStringValueForKey:@"c" defaultValue:@""];
    }
    [cell setValueWithString:answerStr];
    
    if ( self.isJurisdiction ) {
        BOOL isExist = NO;
        if ( self.selectArr.count ) {
            for ( NSIndexPath *selectIndexPath in self.selectArr ) {
                if ( [selectIndexPath compare:indexPath] == NSOrderedSame ) {
                    isExist = YES;
                }
            }
        }
        [cell changeSelectHighlighted:isExist];
    }
    else{
        // 设置 cell 是否可以点击   不可答题时 该题可以看答案，不可提交数据
        [cell setUserInteractionEnabled:NO];
        NSInteger rightAnswerIndex = [q getIntValueForKey:@"realanswer" defaultValue:0];
        BOOL isExist = NO;
        if ( indexPath.row == rightAnswerIndex - 1 ) {
            isExist = YES;
        }
        [cell changeSelectHighlighted:isExist];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isExist = NO;
    if ( self.selectArr.count ) {
        for ( int i = 0; i < self.selectArr.count ; i++ ) {
            NSIndexPath *selectIndexPath = [self.selectArr objectAtIndex:i];
            if ( selectIndexPath == indexPath ) {
                isExist = YES;
                break;
            }
            if ( selectIndexPath.section == indexPath.section ) // 相同 section
            {
                [self.selectArr removeObject: selectIndexPath];
                isExist = NO;
                break;
            }
        }
    }
    else{
        isExist = NO;
    }
    if ( !isExist ) {
        [self.selectArr addObject:indexPath];
        [tableView reloadData];
    }
    
}

@end
