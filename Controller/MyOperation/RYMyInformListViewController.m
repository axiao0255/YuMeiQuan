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
                                                            [wSelf.tableView endRefreshing];
                                                            [wSelf analysisDataWithDict:responseDic isHeadRersh:isHeaderReresh];
                                                            
                                                        } failure:^(id errorString) {
                                                            NSLog(@"系统消息 ： errorString ：%@",errorString);
                                                            [wSelf.tableView endRefreshing];
                                                            if(self.listData.count == 0)
                                                            {
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
    
    NSArray *noticemessage = [info getArrayValueForKey:@"noticemessage" defaultValue:nil];
    if ( noticemessage.count ) {
        if ( isHead ) {
            [self.listData removeAllObjects];
        }
        [self.listData addObjectsFromArray:noticemessage];
    }
    [self.tableView reloadData];
    
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.listData.count ) {
        NSDictionary *dict = [self.listData objectAtIndex:indexPath.section];
        NSString *title = [dict getStringValueForKey:@"note" defaultValue:@""];
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
        return size.height + 16;
    }
    else{
        return 0;
    }
    
//    return 98;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_identifier = @"cell_identifier";
    RYMyInformListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
    if ( !cell ) {
        cell = [[RYMyInformListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
    }
    if ( self.listData.count ) {
         [cell setValueWithDict:[self.listData objectAtIndex:indexPath.section]];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
     return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


@end
