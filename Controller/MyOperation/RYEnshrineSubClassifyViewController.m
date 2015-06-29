//
//  RYEnshrineSubClassifyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYEnshrineSubClassifyViewController.h"
#import "RYEnshrineTableViewCell.h"
#import "MJRefreshTableView.h"

#import "RYArticleViewController.h"
#import "RYLiteratureDetailsViewController.h"

@interface RYEnshrineSubClassifyViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate>
{
    NSMutableArray            *dataArray;
}

@property (nonatomic,strong) NSDictionary             *dataDict;
@property (nonatomic,strong) MJRefreshTableView       *tableView;

@end

@implementation RYEnshrineSubClassifyViewController

- (id)initWithDataDict:(NSDictionary *)dict;
{
    self = [super init];
    if ( self ) {

        self.dataDict = dict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - MJRefershTableViewDelegate

- (void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getMyCollectListWithSessionId:[RYUserInfo sharedManager].session
                                                fcid:[self.dataDict objectForKey:@"id"]
                                                page:currentPage
                                            keywords:nil
                                             success:^(id responseDic) {
                                                 NSLog(@"标签 呵呵 ： %@",responseDic);
                                                 [wSelf.tableView endRefreshing];
                                                 [wSelf analysisDataWithDict:responseDic isHeadRefresh:isHeaderReresh];
                                                 
                                             } failure:^(id errorString) {
                                                 NSLog(@"errorString : %@",errorString);
                                                 [wSelf.tableView endRefreshing];
                                             }];
    }

    
}

-(void)analysisDataWithDict:(NSDictionary *)responseDic isHeadRefresh:(BOOL)isHead
{
    if ( responseDic == nil || [responseDic isKindOfClass:[NSNull class]] ) {
        [ShowBox showError:@"数据错误，请稍候重试"];
        return;
    }
    
    NSDictionary *meta = [responseDic getDicValueForKey:@"meta" defaultValue:nil];
    if ( !meta ) {
        [ShowBox showError:@"数据错误，请稍候重试"];
        return;
    }
    
    BOOL success = [meta getBoolValueForKey:@"success" defaultValue:NO];
    if ( !success ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据错误，请稍候重试"]];
        return;
    }
    
    NSDictionary *info = [responseDic getDicValueForKey:@"info" defaultValue:nil];
    if ( info == nil ) {
        [ShowBox showError:[meta getStringValueForKey:@"msg" defaultValue:@"数据错误，请稍候重试"]];
        return;
    }
    
    self.tableView.totlePage = [info getIntValueForKey:@"total" defaultValue:1];
    
    if ( isHead ) {
        [dataArray removeAllObjects];
    }
    
    // 取列表
    NSArray *favoritemessage = [info getArrayValueForKey:@"favoritemessage" defaultValue:nil];
    if ( favoritemessage.count ) {
        [dataArray addObjectsFromArray:favoritemessage];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    RYEnshrineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[RYEnshrineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( dataArray.count ) {
        [cell setValueWithDict:[dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    NSString *fid = [dic getStringValueForKey:@"fid" defaultValue:@""];
    if ( [fid isEqualToString:@"137"] ) { // fid 为137 的时候  是文献
        RYLiteratureDetailsViewController *vc = [[RYLiteratureDetailsViewController alloc] initWithTid:[dic getStringValueForKey:@"tid" defaultValue:@""]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        RYArticleViewController *vc = [[RYArticleViewController alloc] initWithTid:[dic getStringValueForKey:@"tid" defaultValue:@""]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
