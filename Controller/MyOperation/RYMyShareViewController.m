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

@end

@implementation RYMyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的分享";
//    dataArray = [[self setdata] mutableCopy];
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


//- (NSArray *)setdata
//{
//    NSMutableArray *arr = [NSMutableArray array];
//    for ( NSUInteger i = 0 ; i < 5; i ++ ) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        NSString *title = @"护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。护肤品中的生长因子安全吗。";
//        [dic setValue:title forKey:@"title"];
//        [dic setValue:@"2015-04-08" forKey:@"time"];
//        if ( i%2 == 0) {
//            [dic setValue:@"50" forKey:@"jifen"];
//        }
//        else{
//            [dic setValue:@"100" forKey:@"jifen"];
//        }
//        [arr addObject:dic];
//    }
//    return arr;
//}

//-(void)initSubviews
//{
//    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
//    theTableView.backgroundColor = [UIColor clearColor];
//    theTableView.delegate = self;
//    theTableView.dataSource = self;
//    [Utils setExtraCellLineHidden:theTableView];
//    [self.view addSubview:theTableView];
//}

-(void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getMyAwardShareListWithSessionId:[RYUserInfo sharedManager].session
                                                   page:currentPage
                                                success:^(id responseDic) {
                                                    NSLog(@"企业主页 ： responseDic ：%@",responseDic);
                                                    [wSelf.tableView endRefreshing];
                                                    [wSelf analysisDataWithDict:responseDic isHeadRersh:isHeaderReresh];

            
        } failure:^(id errorString) {
            NSLog(@"企业主页 ： errorString ：%@",errorString);
            [wSelf.tableView endRefreshing];
            if ( wSelf.dataArray.count == 0 ) {
                [ShowBox showError:@"数据出错"];
            }
        }];
    }
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic isHeadRersh:(BOOL)isHead
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"数据出错，请稍候重试"];
        return;
    }
    
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( meta == nil ) {
        [ShowBox showError:@"数据出错，请稍候重试"];
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据出错，请稍候重试"]];
        return;
    }
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( info == nil ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据出错，请稍候重试"]];
        return;
    }
    
    self.tableView.totlePage = [info getIntValueForKey:@"total" defaultValue:1];
    
    NSArray *spreadlogmessage = [info getArrayValueForKey:@"spreadlogmessage" defaultValue:nil];
    
    if ( spreadlogmessage.count ) {
        if ( isHead ) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:spreadlogmessage];
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


@end
