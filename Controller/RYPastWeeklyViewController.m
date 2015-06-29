//
//  RYPastWeeklyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYPastWeeklyViewController.h"
#import "RYPastWeeklyTableViewCell.h"
#import "MJRefreshTableView.h"

@interface RYPastWeeklyViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate>

@property (nonatomic , strong) MJRefreshTableView     *tableView;
@property (nonatomic , strong) NSMutableArray         *listData;
//@property (nonatomic , assign) NSInteger              currentPage;       // 加载第几页数据
//@property (nonatomic , assign) NSInteger              totlePage;         // 总共多少页


@end

@implementation RYPastWeeklyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"往期周报";
    [self setup];
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

- (NSArray *)listData
{
    if ( _listData == nil ) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}


- (void)setup
{
//    self.currentPage = 0;
//    self.totlePage = 1;
    [self.view addSubview:self.tableView];
    [self.tableView headerBeginRefreshing];
}

#pragma mark - MJRefershTableViewDelegate
- (void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getPastweeklylistWithSessionId:[RYUserInfo sharedManager].session
                                                 page:currentPage
                                              success:^(id responseDic) {
                                                  NSLog(@"往期周报 responseDic : %@",responseDic);
                                                  [wSelf.tableView endRefreshing];
                                                  [wSelf analysisDataWithDict:responseDic isHeadRefresh:isHeaderReresh];
                                                  
                                              } failure:^(id errorString) {
                                                  NSLog(@"往期周报 errorString : %@",errorString);
                                                  [wSelf.tableView endRefreshing];
                                              }];
    }

    
}

//- (void)getNetData
//{
//    if ( [ShowBox checkCurrentNetwork] ) {
//        __weak typeof(self) wSelf = self;
//        [NetRequestAPI getPastweeklylistWithSessionId:[RYUserInfo sharedManager].session
//                                                 page:self.currentPage
//                                              success:^(id responseDic) {
//                                                  NSLog(@"往期周报 responseDic : %@",responseDic);
//                                                [wSelf.tableView endRefreshing];
//                                                [wSelf analysisDataWithDict:responseDic];
//            
//        } failure:^(id errorString) {
//             NSLog(@"往期周报 errorString : %@",errorString);
//            [wSelf.tableView endRefreshing];
//        }];
//    }
//}

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
    
    // 取列表
    NSArray *weeklylistmessage = [info getArrayValueForKey:@"weeklylistmessage" defaultValue:nil];
    if ( weeklylistmessage.count ) {
        
        if ( isHead ) {
            [self.listData removeAllObjects];
        }
        
        [self.listData addObjectsFromArray:weeklylistmessage];
        [self.tableView reloadData];
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



//
//- (void)footerRereshingData
//{
//    NSLog(@"脚刷新");
//    self.currentPage ++;
//    if ( self.currentPage >= self.totlePage ) {
//        [self.tableView footerEndRefreshing];
//        return;
//    }
//    [self getNetData];
//}
//- (void)headerRereshingData
//{
//    NSLog(@"头刷新");
//    self.currentPage = 0;
//    self.totlePage = 1;
//    [self.listData removeAllObjects];
//    [self getNetData];
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pastWeekly_cell = @"pastWeekly_cell";
    RYPastWeeklyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pastWeekly_cell];
    if ( !cell ) {
        cell = [[RYPastWeeklyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pastWeekly_cell];
    }
    if ( self.listData.count ) {
        [cell setValueWithDict:[self.listData objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( [self.delegate respondsToSelector:@selector(selectWeeklyWithWeeklyDict:)] ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.row];
        [self.delegate selectWeeklyWithWeeklyDict:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
