//
//  RYInviteMakeMoneyViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/6/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYInviteMakeMoneyViewController.h"
#import "RYArticleViewController.h"
#import "MJRefreshTableView.h"
#import "RYLiteratureDetailsViewController.h"

@interface RYInviteMakeMoneyViewController () <UITableViewDelegate,UITableViewDataSource,MJRefershTableViewDelegate>

@property (nonatomic , assign) InviteType   myInviteType;

@property (nonatomic,  strong) MJRefreshTableView       *tableView;
@property (strong , nonatomic) NSMutableArray           *listData;

@end

@implementation RYInviteMakeMoneyViewController

- (id)initWithInviteType:(InviteType)type
{
    self = [super init];
    if ( self ) {
        self.myInviteType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ( self.myInviteType == transmit) {
        self.title = @"转发赚积分";
    }
    else{
        self.title = @"调研赚积分";
    }
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
        if ( self.myInviteType == transmit ) {
            [NetRequestAPI getspreadlistWithSessionId:[RYUserInfo sharedManager].session
                                                 page:currentPage
                                              success:^(id responseDic) {
                                                  NSLog(@"转发赚积分 responseDic : %@",responseDic);
                                                  [wSelf.tableView endRefreshing];
                                                  [wSelf analysisDataWithDict:responseDic isHeadRersh:isHeaderReresh];
                
            } failure:^(id errorString) {
                [wSelf.tableView endRefreshing];
                 NSLog(@"转发赚积分 errorString : %@",errorString);
                if(self.listData.count == 0)
                {
                    [ShowBox showError:@"数据出错"];
                }

            }];
        }
        else{
            
            [NetRequestAPI getquestionlistWithSessionId:[RYUserInfo sharedManager].session
                                                   page:currentPage
                                                success:^(id responseDic) {
                                                    NSLog(@"调研赚积分 responseDic : %@",responseDic);
                                                    [wSelf.tableView endRefreshing];
                                                    [wSelf analysisDataWithDict:responseDic isHeadRersh:isHeaderReresh];
                               
            } failure:^(id errorString) {
                [wSelf.tableView endRefreshing];
                NSLog(@"调研赚积分 errorString : %@",errorString);
                if(self.listData.count == 0)
                {
                    [ShowBox showError:@"数据出错"];
                }
            }];
        }
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
    
    NSArray *noticemessage = [info getArrayValueForKey:@"message" defaultValue:nil];
    if ( noticemessage.count ) {
        if ( isHead ) {
            [self.listData removeAllObjects];
        }
        [self.listData addObjectsFromArray:noticemessage];
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
        NSString *title = [dict getStringValueForKey:@"subject" defaultValue:@""];
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
        return size.height + 16;
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
        NSString *title = [dict getStringValueForKey:@"subject" defaultValue:@""];
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
        label.height = size.height + 16;
        
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



@end
