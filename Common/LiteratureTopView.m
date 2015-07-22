//
//  LiteratureTopView.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/22.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "LiteratureTopView.h"
#import "RYLiteratureQueryTableViewCell.h"

@interface LiteratureTopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView  *tableView;

@end

@implementation LiteratureTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    self = [super init];
    if ( self ) {
        [self addSubview:self.tableView];
    }
    return self;
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


-(void)setArticleData:(RYArticleData *)articleData
{
    _articleData = articleData;
    [self.tableView removeFromSuperview];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content;
    if ( indexPath.row == 0 ) {
        content = self.articleData.subhead;
    }
    else if ( indexPath.row == 1 ){
        content = self.articleData.author;
    }
    else if ( indexPath.row == 2 ){
         content = self.articleData.periodical;
    }
    else if ( indexPath.row ==3 ){
        content = self.articleData.dateline;
    }
    else{
        content = self.articleData.DOI;
    }
    
    if ( [ShowBox isEmptyString:content] ) {
        return 0;
    }
    else{
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
        return rect.size.height + 31;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ordinary_cell = @"ordinary_cell";
    RYLiteratureQueryOrdinaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ordinary_cell];
    if ( !cell ) {
        cell = [[RYLiteratureQueryOrdinaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ordinary_cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ( indexPath.row == 0 ) {
        
        // 设置 标题
        if ( ![ShowBox isEmptyString:self.articleData.subhead] ) {
            cell.leftView.backgroundColor = [Utils getRGBColor:0x00 g:0x91 b:0xea a:1.0];
            cell.titleLabel.text = @"标题";
            [cell setValueWithString:self.articleData.subhead];
        }
    }
    else if ( indexPath.row == 1 ){
        
        // 设置作者
        if ( ![ShowBox isEmptyString:self.articleData.author] ) {
            cell.leftView.backgroundColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
            cell.titleLabel.text = @"作者";
            [cell setValueWithString:self.articleData.author];
        }
    }
    else if ( indexPath.row == 2 ){
        
        // 设置 期刊
        if ( ![ShowBox isEmptyString:self.articleData.periodical] ) {
            cell.leftView.backgroundColor = [Utils getRGBColor:0xea g:0x73 b:0xc5 a:1.0];
            cell.titleLabel.text = @"期刊";
            [cell setValueWithString:self.articleData.periodical];
        }
    }
    else if ( indexPath.row == 3 ){
        
        // 设置 日期
        if ( ![ShowBox isEmptyString:self.articleData.dateline] ) {
            cell.leftView.backgroundColor = [Utils getRGBColor:0x0b g:0xcd b:0xd3 a:1.0];
            cell.titleLabel.text = @"日期";
            [cell setValueWithString:self.articleData.dateline];
        }
    }
    else if ( indexPath.row == 4 ){
        
        // 设置 DOI
        if ( ![ShowBox isEmptyString:self.articleData.DOI] ) {
            cell.leftView.backgroundColor = [Utils getRGBColor:0xee g:0x18 b:0x18 a:1.0];
            cell.titleLabel.text = @"DOI";
            [cell setValueWithString:self.articleData.DOI];
        }
    }
    
    return cell;

}

- (CGFloat)getLiteratureTopViewHeight
{
//    NSInteger sectionNum = [self numberOfSectionsInTableView:self.tableView];
    CGFloat   height = 0;
//    for ( NSInteger i = 0; i < sectionNum; i ++ ) {
//        height += [self tableView:self.tableView heightForHeaderInSection:i];
//        for ( NSInteger j = 0; j < 5; j ++ ) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//            height += [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
//        }
//    }
    for ( NSInteger i = 0 ; i < 5; i ++ ) {
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
         height += [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.tableView.frame = self.frame;
    return height;
}


@end
