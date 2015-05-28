//
//  RYWeeklyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYWeeklyViewController.h"
#import "RYNewsPageTableViewCell.h"
#import "RYWeeklyTableViewCell.h"
#import "RYArticleViewController.h"
#import "RYPastWeeklyViewController.h"

@interface RYWeeklyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView      *tableView;

@end

@implementation RYWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"周报";
    [self setup];
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

- (NSArray *)listData
{
    if ( _listData == nil ) {
        _listData = [NSArray array];
    }
    return _listData;
}

- (UITableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (void)setup
{
    [self.view addSubview:self.tableView];
    [self setNavigationItem];
}

- (void)setNavigationItem
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18)];
    [rightBtn setImage:[UIImage imageNamed:@"ic_default_select.png"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnClick:(id)sender
{
    RYPastWeeklyViewController *vc = [[RYPastWeeklyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark  UITableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.listData.count ) {
        if ( section == 0 ) {
            return 1;
        }
        else{
            if ( self.listData.count > 1 )
                return self.listData.count - 1;
            else
                return 0;
        }
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.listData.count ) {
        if ( indexPath.section == 0 ) {
            return 180;
        }
        else{
            if ( self.listData.count > 1 ) {
                NSDictionary *dict = [self.listData objectAtIndex:indexPath.row + 1];
                NSString *subhead = [dict getStringValueForKey:@"subhead" defaultValue:@""];
                if ( [ShowBox isEmptyString:subhead] ) {
                    return 87;
                }
                else{
                    return 105;
                }
            }
            else
                return 0;
        }
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSString *adverCell = @"adverCell";
        RYAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adverCell];
        if ( !cell ) {
            cell = [[RYAdverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adverCell];
        }
        if ( self.listData.count ) {
            [cell setValueWithDict:[self.listData objectAtIndex:0]];
        }
        return cell;
    }
    else{
        NSString *weekly_cell = @"weekly_cell";
        RYWeeklyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:weekly_cell];
        if ( !cell ) {
            cell = [[RYWeeklyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:weekly_cell];
        }
        if ( self.listData.count ) {
            [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row + 1]];
        }
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( self.listData.count > 1 ) {
        if ( section == 0 ) {
            return 26;
        }else{
            return 0;
        }
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( self.listData.count > 1 ) {
        if ( section == 0 ) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 26)];
            view.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 26)];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
            label.text = @"2015-04-18 总第219期";
            [view addSubview:label];
            
            return view;
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RYArticleViewController *vc = [[RYArticleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
