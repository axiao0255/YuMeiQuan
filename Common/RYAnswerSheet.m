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

@property (nonatomic ,strong) NSDictionary *dataDict;
@property (nonatomic ,strong) UIView       *topView;
@property (nonatomic ,strong) UILabel      *surplusNumLabel; //剩余名额 label
@property (nonatomic ,strong) UIView       *buttomView;
@property (nonatomic ,strong) UIButton     *submitButton;    // 提交按钮

@property (nonatomic ,strong) UITableView  *tableView;

@property (nonatomic ,strong) NSString     *answerStr;

@property (nonatomic ,strong) NSMutableArray  *selectArr;

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
//    if ( self.dataDict ) {
        [self setup];
//    }
    self.answerStr = @"A.因其独特的作用原理因其独特的作用原理因其独特的作用原理因其独特的作用原理因其独特的作用原理";
    return self;
}

- (void) setup
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAXFLOAT);
    self.tableView.frame = self.frame;
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.buttomView;
    
    // 设置 剩余名额
    NSInteger  num = 10;
    NSString *surplusStr = [NSString stringWithFormat:@"剩余名额%li名",(long)num];
    NSAttributedString *hightForNumStr = [Utils getAttributedString:surplusStr andHightlightString:[NSString stringWithFormat:@"%li",(long)num]];
    [self.surplusNumLabel setAttributedText:hightForNumStr];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self.answerStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 75, MAXFLOAT)];
    return size.height + 32;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *string = @"诺龙独有的eMatrix水滴阵替治疗";
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
    return size.height + 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 30, height - 16)];
    label.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    label.numberOfLines = 0;
    label.text = @"诺龙独有的eMatrix水滴阵替治疗";
    label.font = [UIFont systemFontOfSize:18];
    [view addSubview:label];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_1 = @"cell_1";
    RYAnswerSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_1];
    if ( !cell ) {
        cell = [[RYAnswerSheetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_1];
    }
    [cell setValueWithString:self.answerStr];
    
    BOOL isExist = NO;
    if ( self.selectArr.count ) {
        for ( NSIndexPath *selectIndexPath in self.selectArr ) {
            if ( [selectIndexPath compare:indexPath] == NSOrderedSame ) {
                isExist = YES;
            }
        }
    }
    [cell changeSelectHighlighted:isExist];
    return cell;
    
//    if ( indexPath.row == 1 ) {
//        // 设置 选中第几行
//        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    }
//    else{
//    }
    // 设置 cell 是否可以点击
//    [cell setUserInteractionEnabled:NO];
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
