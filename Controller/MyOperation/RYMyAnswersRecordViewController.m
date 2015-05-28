//
//  RYMyAnswersRecordViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyAnswersRecordViewController.h"
#import "RYBaiJiaPageTableViewCell.h"
#import "RYArticleViewController.h"

@interface RYMyAnswersRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView      *tableView;
@property (nonatomic,strong) NSArray          *listData;

@end

@implementation RYMyAnswersRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问答记录";
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    self.listData = [self setData];
    [self.view addSubview:self.tableView];
}

- (NSArray *)setData
{
    NSMutableArray *arr = [NSMutableArray array];
    for ( int i = 0; i < 10; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
        [dic setObject:@"护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，" forKey:@"title"];
        [arr addObject:dic];
    }
    return arr;
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *answersRecord = @"AnswersRecord";
    RYBaiJiaPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:answersRecord];
    if ( !cell ) {
        cell = [[RYBaiJiaPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:answersRecord];
    }
    if ( self.listData.count ) {
        [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RYArticleViewController *vc = [[RYArticleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
