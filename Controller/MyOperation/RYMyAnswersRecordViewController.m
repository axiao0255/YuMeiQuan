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

//@property (nonatomic,assign) NSInteger                currentPage;       // 加载第几页数据
//@property (nonatomic,assign) NSInteger                totlePage;         // 总共多少页


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
                                                 [wSelf.tableView endRefreshing];
                                                 [wSelf analysisDataWithDict:responseDic isHeadRefresh:isHeaderReresh];
                                                 
                                             } failure:^(id errorString) {
                                                 NSLog(@"问答记录 errorString : %@",errorString);
                                                 [wSelf.tableView endRefreshing];
                                                 
                                                if ( self.listData.count == 0 ) {
                                                     [ShowBox showError:@"数据出错"];
                                                 }
                                             }];
    }

    
}

//- (void)getNetData
//{
//    if ( [ShowBox checkCurrentNetwork] ) {
//        __weak typeof(self) wSelf = self;
//        [NetRequestAPI getMyAnswersListWithSessionId:[RYUserInfo sharedManager].session
//                                                page:self.currentPage
//                                             success:^(id responseDic) {
//                                                 NSLog(@"问答记录 responseDic : %@",responseDic);
//                                                 [wSelf.tableView endRefreshing];
//                                                 [wSelf analysisDataWithDict:responseDic];
//            
//        } failure:^(id errorString) {
//            NSLog(@"问答记录 errorString : %@",errorString);
//            [wSelf.tableView endRefreshing];
//            
//            // 获取数据失败，页数不应该增加，应该回到 上一页
//            if ( wSelf.currentPage != 0 ) {
//                wSelf.currentPage --;
//            }
//            if ( self.listData.count == 0 ) {
//                [ShowBox showError:@"数据出错"];
//            }
//        }];
//    }
//}

- (void)analysisDataWithDict:(NSDictionary *)responseDic isHeadRefresh:(BOOL) ishead
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
    
    NSArray *questionlogmessage = [info getArrayValueForKey:@"questionlogmessage" defaultValue:nil];
    if ( questionlogmessage.count ) {
        if ( ishead ) {
            [self.listData removeAllObjects];
        }
        [self.listData addObjectsFromArray:questionlogmessage];
    }
    [self.tableView reloadData];

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
////    [self.tableView reloadData];
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

@end
