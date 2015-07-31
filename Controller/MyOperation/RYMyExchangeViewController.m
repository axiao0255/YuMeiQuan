//
//  RYMyExchangeViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/7/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyExchangeViewController.h"
#import "RYMyExchangeTableViewCell.h"
#import "RYExchangeDetailsViewController.h"
#import "RYExchangeHistoryViewController.h"
#import "MJRefreshTableView.h"

@interface RYMyExchangeViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate>

@property (nonatomic , strong)  MJRefreshTableView     *tableView;
@property (nonatomic , strong)  NSMutableArray         *listData;
@property (nonatomic , assign)  BOOL                   notStretch;

@end

@implementation RYMyExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分兑换";
    
//    NSMutableArray *arr = [NSMutableArray array];
//    for ( NSInteger i = 0 ; i < 10; i ++ ) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setValue:@"http://img1.cache.netease.com/catchpic/3/35/35AFDF1C4CFF12DDB31C9811E4F1441A.jpg" forKey:@"pic"];
//        [dict setValue:@"精美礼品，吊坠挂件" forKey:@"name"];
//        [dict setValue:@"足球主题曲响彻操场，足球舞蹈展示着运动活力。在精彩的节目演出后，重庆市教委副巡视员帅逊、万盛经开区党工委副书记肖猛" forKey:@"subject"];
//        [dict setValue:@"20" forKey:@"maxNumber"];
//        [dict setValue:@"100" forKey:@"jifen"];
//        [arr addObject:dict];
//    }
    
//    self.listData = arr;
    [self.view addSubview:self.tableView];
    [self.tableView headerBeginRefreshing];
    [self setNavigationItem];
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

- (void)setNavigationItem
{
     UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 24)];
    [rightButton setImage:[UIImage imageNamed:@"ic_exchange_history.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = leftItem;

}

-(void)rightButtonClick:(id)sender
{
    RYExchangeHistoryViewController *vc = [[RYExchangeHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)listData
{
    if ( _listData == nil ) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

-(MJRefreshTableView *)tableView
{
    if ( _tableView == nil ){
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
        [NetRequestAPI getExchangeListWithSessionId:[RYUserInfo sharedManager].session
                                               page:currentPage
                                            success:^(id responseDic) {
                                                NSLog(@"兑换列表 responseDic : %@",responseDic);
                                                [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
                                                [wSelf analysisDataWithDict:responseDic isHead:isHeaderReresh];
            
        } failure:^(id errorString) {
            NSLog(@"兑换列表 errorString : %@",errorString);
            [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
            if ( wSelf.listData.count == 0 ) {
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
    NSDictionary *usermassage = [info getDicValueForKey:@"usermassage" defaultValue:nil];
    if ( usermassage ) {
        [[RYUserInfo sharedManager] refreshUserInfoDataWithDict:usermassage];
    }
    self.tableView.totlePage = [info getIntValueForKey:@"total" defaultValue:1];
    NSArray *exchangemessage = [info getArrayValueForKey:@"exchangemessage" defaultValue:nil];
    if ( isHead ) {
        [self.listData removeAllObjects];
    }
    if ( exchangemessage.count  ) {
        [self.listData addObjectsFromArray:exchangemessage];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        if ( self.listData.count == 0 ) {
             return 0;
        }
        else{
            return 1;
        }
    }
    else{
        return self.listData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return 54;
    }
    else{
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        NSString *jifen_cell = @"jifen_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jifen_cell];
        if ( !cell ) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jifen_cell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 55, 54)];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
            titleLabel.text = @"积分余额";
            [cell.contentView addSubview:titleLabel];
            
            UILabel *jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+10, 0, 200, 54)];
            jifenLabel.font = [UIFont boldSystemFontOfSize:18];
            jifenLabel.textColor = [Utils getRGBColor:0xff g:0xb3 b:0x00 a:1.0];
            jifenLabel.tag = 110;
            [cell.contentView addSubview:jifenLabel];
        }
        UILabel  *jifenLabel = (UILabel *)[cell.contentView viewWithTag:110];
        jifenLabel.text = [RYUserInfo sharedManager].credits;
        return cell;
    }
    else{
        NSString *exchange_cell = @"exchange_cell";
        RYMyExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:exchange_cell];
        if ( !cell ) {
            cell = [[RYMyExchangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:exchange_cell];
        }
        if ( self.listData.count ) {
            NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
            [cell setValueWithDict:dict];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == 1 ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        RYExchangeDetailsViewController *vc = [[RYExchangeDetailsViewController alloc] initWithExchangeDict:dict];
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
