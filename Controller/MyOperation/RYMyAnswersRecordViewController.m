//
//  RYMyAnswersRecordViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyAnswersRecordViewController.h"
#import "RYArticleViewController.h"
#import "MJRefreshTableView.h"
#import "RYAnswersRecordTableViewCell.h"

@interface RYMyAnswersRecordViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate>

@property (nonatomic,strong) MJRefreshTableView      *tableView;
@property (nonatomic,strong) NSMutableArray          *listData;
@property (nonatomic,assign) BOOL                    notStretch;

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
//    self.listData = [self setData];
    self.listData = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView headerBeginRefreshing];
//    [self getNetData];
}

- (NSArray *)setData
{
    NSMutableArray *arr = [NSMutableArray array];
    for ( int i = 0; i < 10; i ++ ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"http://image.tianjimedia.com/uploadImages/2015/131/49/6FPNGYZA50BS_680x500.jpg" forKey:@"pic"];
        [dic setObject:@"护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，护肤品中的生长因子安全吗，" forKey:@"title"];
        [dic setObject:@"1000" forKey:@"jifen"];
        [arr addObject:dic];
    }
    return arr;
}

- (void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getMyAnswersListWithSessionId:[RYUserInfo sharedManager].session
                                                page:currentPage
                                             success:^(id responseDic) {
                                                 NSLog(@"问答记录 responseDic : %@",responseDic);
                                                 [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
                                                 [wSelf analysisDataWithDict:responseDic isHeadRefresh:isHeaderReresh];
                                                 
                                             } failure:^(id errorString) {
                                                 NSLog(@"问答记录 errorString : %@",errorString);
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

- (void)analysisDataWithDict:(NSDictionary *)responseDic isHeadRefresh:(BOOL) ishead
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
    [self removeErroeView];
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    self.tableView.totlePage = [info getIntValueForKey:@"total" defaultValue:1];
    if ( ishead ) {
        [self.listData removeAllObjects];
    }
    NSArray *questionlogmessage = [info getArrayValueForKey:@"questionlogmessage" defaultValue:nil];
    if ( questionlogmessage.count ) {
        [self.listData addObjectsFromArray:questionlogmessage];
    }
    [self.tableView reloadData];
    if ( self.listData.count == 0 ) {
        [self showErrorView:self.tableView];
    }
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *answersRecord = @"AnswersRecord";
    RYAnswersRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:answersRecord];
    if ( !cell ) {
        cell = [[RYAnswersRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:answersRecord];
    }
    if ( self.listData.count ) {
        [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
    NSString *tid = [dict getStringValueForKey:@"tid" defaultValue:@""];
    if ( ![ShowBox isEmptyString:tid] ) {
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:tid];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma  mark 如果自动登录不上则 需要打开登录界面手动登录
-(void)openLoginVC
{
    __weak typeof(self) wSelf = self;
    RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
        if ( isLogin ) {
            wSelf.notStretch = YES;
            wSelf.tableView.currentPage = 0;
            [wSelf getDataWithIsHeaderReresh:YES andCurrentPage:0];
        }
    }];
    [self.navigationController pushViewController:nextVC animated:YES];
}


@end
