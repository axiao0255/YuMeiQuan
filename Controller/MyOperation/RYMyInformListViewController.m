//
//  RYMyInformListViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/5.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyInformListViewController.h"
#import "RYMyInformListTableViewCell.h"
#import "MJRefreshTableView.h"
#import "RYArticleViewController.h"
#import "RYLiteratureDetailsViewController.h"

@interface RYMyInformListViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate>
{
    InformType       informType;
//    UITableView      *theTableView;
//    
//    NSArray          *dadaArray;
}

@property (nonatomic,  strong) MJRefreshTableView       *tableView;
@property (strong , nonatomic) NSMutableArray           *listData;
@property (nonatomic,  assign) BOOL                     notStretch;

@end

@implementation RYMyInformListViewController

- (id)initWithInfomType:(InformType)type
{
    self = [super init];
    if ( self ) {
        informType = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统消息";
    
//    dadaArray = [self setdata];
//    [self initSubviews];
    
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
                                                           type:@"system"
                                                           page:currentPage
                                                        success:^(id responseDic) {
                                                            NSLog(@"系统消息 ： responseDic ：%@",responseDic);
                                                            [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
                                                            [wSelf analysisDataWithDict:responseDic isHeadRersh:isHeaderReresh];
                                                            
                                                        } failure:^(id errorString) {
                                                            NSLog(@"系统消息 ： errorString ：%@",errorString);
                                                            [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
                                                            if(wSelf.listData.count == 0)
                                                            {
                                                                [wSelf showErrorView:wSelf.tableView];
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
    else{
        [self removeErroeView];
    }
    [self.tableView reloadData];
    
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.listData.count ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        NSString *title = [dict getStringValueForKey:@"title" defaultValue:@""];
        // 设置标题
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_identifier = @"cell_identifier";
    RYMyInformListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
    if ( !cell ) {
        cell = [[RYMyInformListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
    }
    if ( self.listData.count ) {
         [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [self.listData objectAtIndex:indexPath.section];
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

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//     return 8;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}


#pragma  mark 如果自动登录不上则 需要打开登录界面手动登录
-(void)openLoginVC
{
    __weak typeof(self) wSelf = self;
    RYLoginViewController *nextVC = [[RYLoginViewController alloc] initWithFinishBlock:^(BOOL isLogin, NSError *error) {
        if ( isLogin ) {
            wSelf.notStretch = YES;
            wSelf.tableView.currentPage = 0;
            wSelf.tableView.totlePage = 1;
            [wSelf getDataWithIsHeaderReresh:YES andCurrentPage:0];
        }
    }];
    [self.navigationController pushViewController:nextVC animated:YES];
}



@end
