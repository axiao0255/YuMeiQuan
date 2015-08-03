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
@property (nonatomic , strong)  NSMutableArray         *listData;
@property (nonatomic , assign)  BOOL                   notStretch;

@end

@implementation RYExchangeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换记录";
    [self.view addSubview:self.tableView];
    [self.tableView headerBeginRefreshing];
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

- (NSMutableArray *)listData
{
    if ( _listData == nil ) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}


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
    if ( [ShowBox checkCurrentNetwork]) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getExchangeHistoryListWithSessionId:[RYUserInfo sharedManager].session
                                                      page:currentPage
                                                   success:^(id responseDic) {
                                                       NSLog(@"兑换历史列表 responseDic:%@",responseDic);
                                                       [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
                                                       [wSelf analysisDataWithDict:responseDic isHead:isHeaderReresh];
            
        } failure:^(id errorString) {
             NSLog(@"兑换历史列表 errorString:%@",errorString);
            [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
            if ( wSelf.listData.count == 0 ) {
                [wSelf showErrorView:wSelf.tableView];
            }
        }];
    }
    else{
        [self tableViewRefreshEndWithIsHead:isHeaderReresh];
        if ( self.listData.count == 0 ) {
            [self showErrorView:self.tableView];
        }
    }
}

// 列表获取数据之后， 回到原来的位置  ，如果不是上下拉刷新，则不需要调用 endRefreshing方法，会引起显示错误
- (void)tableViewRefreshEndWithIsHead:(BOOL)isHead
{
    if ( !self.notStretch ) {
        if ( isHead ) {
            [self.tableView headerFinishRefreshing];
        }
        else{
            [self.tableView footerFinishRereshing];
        }
    }
    else{
        self.notStretch = NO;
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic isHead:(BOOL)isHead
{
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        int  login = [meta getIntValueForKey:@"login" defaultValue:0];
        if ( login == 2 ) {  // login == 2 表示用户已过期 需要重新登录
            __weak typeof(self) wSelf = self;
            [RYUserInfo automateLoginWithLoginSuccess:^(BOOL isSucceed) {
                // 自动登录一次
                if ( isSucceed ) { // 自动登录成功 刷新数据，
                    wSelf.notStretch = YES;
                    wSelf.tableView.currentPage = 0;
                    [wSelf getDataWithIsHeaderReresh:YES andCurrentPage:0];
                }
                else{// 登录失败 打开登录界面 手动登录
                    [wSelf openLoginVC];
                }
            } failure:^(id errorString) {
                [wSelf openLoginVC];
            }];
            return;
        }
        else{
            if ( self.listData.count == 0 ) {
                [self showErrorView:self.tableView];
            }
            return;
        }
    }
    
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    NSArray  *exchangelogmessage = [info getArrayValueForKey:@"exchangelogmessage" defaultValue:nil];
    if ( isHead ) {
        [self.listData removeAllObjects];
    }
    if ( exchangelogmessage.count  ) {
        [self.listData addObjectsFromArray:exchangelogmessage];
    }
    if ( self.listData.count == 0 ) {
        [self showErrorView:self.tableView];
    }
    else{
        [self removeErroeView];
    }
    
    [self.tableView reloadData];
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


#pragma  mark 如果自动登录不上则 需要打开登录界面手动登录
-(void)openLoginVC
{
    __weak typeof(self) wSelf = self;
    RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
        if ( isLogin ) {
            NSLog(@"登录完成");
            wSelf.notStretch = YES;
            wSelf.tableView.currentPage = 0;
            [wSelf getDataWithIsHeaderReresh:YES andCurrentPage:0];
        }
    }];
    [self.navigationController pushViewController:nextVC animated:YES];
}


@end
