//
//  RYExchangeHistoryViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/15.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYExchangeHistoryViewController.h"
#import "RYExchangeHistoryTableViewCell.h"
#import "RYExchangeHistoryDetailsViewController.h"
#import "MJRefreshTableView.h"

@interface RYExchangeHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate>

@property (nonatomic , strong)  MJRefreshTableView     *tableView;
@property (nonatomic , strong)  NSArray                *listData;

@end

@implementation RYExchangeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换记录";
    
    NSMutableArray *arr = [NSMutableArray array];
    for ( NSInteger i = 0 ; i < 10; i ++ ) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"http://img1.cache.netease.com/catchpic/3/35/35AFDF1C4CFF12DDB31C9811E4F1441A.jpg" forKey:@"pic"];
        [dict setValue:@"精美礼品，吊坠挂件" forKey:@"name"];
        [dict setValue:@"足球主题曲响彻操场，足球舞蹈展示着运动活力。在精彩的节目演出后，重庆市教委副巡视员帅逊、万盛经开区党工委副书记肖猛" forKey:@"subject"];
        [dict setValue:@"20" forKey:@"maxNumber"];
        [dict setValue:@"200" forKey:@"jifen"];
        [dict setValue:@"2015-04-25" forKey:@"time"];
        [dict setValue:@"史家琪" forKey:@"name"];
        [dict setValue:@"上海市浦东区黄浦江东方路上海市浦东区黄浦江东方路上海市浦东区黄浦江东方路1023号" forKey:@"address"];
        [dict setValue:@"2" forKey:@"number"];
        [dict setValue:@"13800138000" forKey:@"phone"];
        [dict setValue:@"足球主题曲响彻操场，足球舞蹈展示着运动活力。在精彩的节目演出后，重庆市教委副巡视员帅逊、万盛经开区党工委副书记肖猛" forKey:@"explain"];
        [arr addObject:dict];
    }
    self.listData = arr;
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

-(MJRefreshTableView *)tableView
{
    if ( _tableView == nil ) {
        _tableView = [[MJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delegateRefersh = self;
        [Utils setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

-(void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *history_cell = @"history_cell";
    RYExchangeHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:history_cell];
    if ( !cell ) {
        cell = [[RYExchangeHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:history_cell];
    }
    if ( self.listData.count ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        [cell setValueWithDict:dict];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
    RYExchangeHistoryDetailsViewController *vc = [[RYExchangeHistoryDetailsViewController alloc] initWithExchangeDict:dict];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
