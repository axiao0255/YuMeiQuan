//
//  RYMyShareViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/4.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyShareViewController.h"
#import "RYMyShareTableViewCell.h"
#import "MJRefreshTableView.h"
#import "RYArticleViewController.h"
#import "RYLiteratureDetailsViewController.h"

@interface RYMyShareViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate>

@property (nonatomic,strong) MJRefreshTableView       *tableView;
@property (nonatomic,strong) NSMutableArray           *dataArray;
@property (nonatomic,assign) BOOL                     notStretch;

@end

@implementation RYMyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的分享";
    
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

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getMyAwardShareListWithSessionId:[RYUserInfo sharedManager].session
                                                   page:currentPage
                                                success:^(id responseDic) {
                                                    NSLog(@"有奖分享 ： responseDic ：%@",responseDic);
                                                    [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
                                                    [wSelf analysisDataWithDict:responseDic isHeadRersh:isHeaderReresh];

            
        } failure:^(id errorString) {
            NSLog(@"有奖分享 ： errorString ：%@",errorString);
            [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
            if ( wSelf.dataArray.count == 0 ) {
                [wSelf showErrorView:wSelf.tableView];
            }
        }];
    }
    else{
        [self tableViewRefreshEndWithIsHead:isHeaderReresh];
        if ( self.dataArray.count == 0 ) {
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

- (void)analysisDataWithDict:(NSDictionary *)responseDic isHeadRersh:(BOOL)isHead
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
            if ( self.dataArray.count == 0 ) {
                [self showErrorView:self.tableView];
            }
            return;
        }

    }
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( info == nil ) {
        [self showErrorView:self.tableView];
        return;
    }
    
    [self removeErroeView];
    self.tableView.totlePage = [info getIntValueForKey:@"total" defaultValue:1];
    
    NSArray *spreadlogmessage = [info getArrayValueForKey:@"spreadlogmessage" defaultValue:nil];
    if ( isHead ) {
        [self.dataArray removeAllObjects];
    }
    if ( spreadlogmessage.count ) {
        [self.dataArray addObjectsFromArray:spreadlogmessage];
    }
    
    if ( self.dataArray.count == 0 ) {
        [self showErrorView:self.tableView];
    }
    
    [self.tableView reloadData];

}

#pragma mark - UITableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *share_cell = @"share_cell";
    RYMyShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:share_cell];
    if ( !cell ) {
        cell = [[RYMyShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:share_cell];
    }
    if ( self.dataArray.count ) {
        [cell setValueWithDict:[self.dataArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    NSString *fid = [dict getStringValueForKey:@"fid" defaultValue:@""];
    NSString *tid = [dict getStringValueForKey:@"tid" defaultValue:@""];
    
    if ( [fid isEqualToString:@"137"] ) {
        RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:tid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
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
            NSLog(@"登录完成");
            wSelf.notStretch = YES;
            wSelf.tableView.currentPage = 0;
            [wSelf getDataWithIsHeaderReresh:YES andCurrentPage:0];
        }
    }];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
