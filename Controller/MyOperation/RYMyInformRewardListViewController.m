//
//  RYMyInformRewardListViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyInformRewardListViewController.h"
#import "RYArticleViewController.h"
#import "MJRefreshTableView.h"
#import "RYLiteratureDetailsViewController.h"

@interface RYMyInformRewardListViewController () <UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate>

@property (nonatomic,  strong) MJRefreshTableView       *tableView;
@property (strong , nonatomic) NSMutableArray           *listData;
@property (nonatomic , assign) BOOL                     notStretch;

@end

@implementation RYMyInformRewardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"有奖活动";
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
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getSystemAndAwardNoticeListWithSessionId:[RYUserInfo sharedManager].session
                                                           type:@"spread"
                                                           page:currentPage
                                                        success:^(id responseDic) {
                                                            NSLog(@"有奖活动 ： responseDic ：%@",responseDic);
                                                            [wSelf  tableViewRefreshEndWithIsHead:isHeaderReresh];
                                                            [wSelf analysisDataWithDict:responseDic isHeadRersh:isHeaderReresh];
            
        } failure:^(id errorString) {
             NSLog(@"有奖活动 ： errorString ：%@",errorString);
            [wSelf  tableViewRefreshEndWithIsHead:isHeaderReresh];
            if(wSelf.listData.count == 0)
            {
                [wSelf showErrorView:wSelf.tableView];
                [wSelf.tableView reloadData];
            }
        }];
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
                if ( isSucceed ) { // 自动登录成功 刷新数据，
                    wSelf.notStretch = YES;
                    wSelf.tableView.currentPage = 0;
                    wSelf.tableView.totlePage = 1;
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
        [self showErrorView:self.tableView];
        return;
    }
    [self removeErroeView];
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    self.tableView.totlePage = [info getIntValueForKey:@"total" defaultValue:1];
    
    if ( isHead ) {
        [self.listData removeAllObjects];
    }
    
    NSArray *noticemessage = [info getArrayValueForKey:@"noticemessage" defaultValue:nil];
    if ( noticemessage.count ) {
        [self.listData addObjectsFromArray:noticemessage];
    }
    if ( self.listData.count == 0 ) {
        [self showErrorView:self.tableView];
    }
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.listData.count ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        NSString *title = [dict getStringValueForKey:@"note" defaultValue:@""];
//        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGRect rect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
        return rect.size.height + 16;
    }
    else{
        return 0;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reward_cell = @"reward_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reward_cell];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reward_cell];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.left = 15;
        label.width = SCREEN_WIDTH - 30;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
        label.numberOfLines = 0;
        label.tag = 1010;
        [cell.contentView addSubview:label];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1010];
    if ( self.listData.count ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        NSString *title = [dict getStringValueForKey:@"note" defaultValue:@""];
//        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGRect rect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];

        label.height = rect.size.height + 16;
        
        label.text = title;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
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
          // 重新获取数据  由于本ViewController中有注册通知，登录成功后通知能重新刷新数据，所有在此不做任何操作
            wSelf.notStretch = YES;
            wSelf.tableView.currentPage = 0;
            wSelf.tableView.totlePage = 1;
            [wSelf getDataWithIsHeaderReresh:YES andCurrentPage:0];
        }
    }];
    [self.navigationController pushViewController:nextVC animated:YES];
}




@end
