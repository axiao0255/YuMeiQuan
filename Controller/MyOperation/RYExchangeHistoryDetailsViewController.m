//
//  RYExchangeHistoryDetailsViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/15.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYExchangeHistoryDetailsViewController.h"
#import "RYExchangeDetailsTableViewCell.h"
#import "RYExchangeHistoryDetailsTableViewCell.h"

@interface RYExchangeHistoryDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)NSDictionary   *exchangeDict;
@property (nonatomic , strong)UITableView    *tableView;

@end

@implementation RYExchangeHistoryDetailsViewController

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return 8;
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
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
        else{
            if ( indexPath.row == 3 ) {
                NSString *address = [self.exchangeDict getStringValueForKey:@"address" defaultValue:@""];
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
                CGRect rect = [address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 84, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];
                return 20 + rect.size.height;
                
            }
            else{
                return 36;
            }
        }
    }
    else{
        NSString *explain = [self.exchangeDict getStringValueForKey:@"explain" defaultValue:@""];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGRect rect = [explain boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
        return 20 + rect.size.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
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
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                line.backgroundColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0];
                line.tag = 130;
                [cell.contentView addSubview:line];
            }
            UIView *line  = [cell.contentView viewWithTag:130];
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            line.top = height- 0.5;
            cell.textLabel.text = [self.exchangeDict getStringValueForKey:@"subject" defaultValue:@""];
            return cell;
            
        }
        else{
            
            NSString *details_cell = @"details_cell";
            RYExchangeHistoryDetailsTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:details_cell];
            if ( !cell ) {
                cell = [[RYExchangeHistoryDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:details_cell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.contentLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
            NSString *title;
            NSString *name;
            if ( indexPath.row == 2 ) {
                title = @"姓名：";
                name = [self.exchangeDict getStringValueForKey:@"name" defaultValue:@""];
            }
            else if ( indexPath.row == 3 ){
                title = @"地址：";
                name = [self.exchangeDict getStringValueForKey:@"address" defaultValue:@""];
            }
            else if ( indexPath.row == 4 ){
                title = @"电话：";
                name = [self.exchangeDict getStringValueForKey:@"phone" defaultValue:@""];
            }
            else if ( indexPath.row == 5 ){
                title = @"数量：";
                name = [self.exchangeDict getStringValueForKey:@"number" defaultValue:@""];
            }
            else if ( indexPath.row == 6 ){
                title = @"消耗积分：";
                name = [self.exchangeDict getStringValueForKey:@"jifen" defaultValue:@""];
                cell.contentLabel.textColor = [Utils getRGBColor:0xcd g:0x24 b:0x2b a:1.0];
            }
            else{
                title = @"兑换日期：";
                name = [self.exchangeDict getStringValueForKey:@"time" defaultValue:@""];
            }
            
            CGRect titleRect = [self adjustSiteWithString:title andWidth:200 andHeight:16];
            cell.titleLabel.width = titleRect.size.width;
            cell.titleLabel.height = titleRect.size.height;
            cell.titleLabel.text = title;
            
            CGRect nameRect = [self adjustSiteWithString:name andWidth:SCREEN_WIDTH - 40 - titleRect.size.width andHeight:MAXFLOAT];
            cell.contentLabel.left = cell.titleLabel.right;
            cell.contentLabel.width = nameRect.size.width;
            cell.contentLabel.height = nameRect.size.height;
            cell.top = cell.titleLabel.top;
            cell.contentLabel.text = name;
            
            return cell;
        }
    }
    else{
        NSString *explain_cell = @"explain_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:explain_cell];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:explain_cell];
            cell.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [Utils getRGBColor:0x66 g:0x66 b:0x66 a:1.0];
        }
        cell.textLabel.text = [self.exchangeDict getStringValueForKey:@"explain" defaultValue:@""];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ( section == 0 ) {
        return 0;
    }
    else{
        return 40;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [Utils getRGBColor:0xcc g:0xcc b:0xcc a:1.0];
    [view addSubview:line];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    titleLabel.text = @"兑奖说明";
    [view addSubview:titleLabel];
    
    return view;
}



- (CGRect)adjustSiteWithString:(NSString *)string andWidth:(CGFloat)width andHeight:(CGFloat)height
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    return rect;
}

@end
