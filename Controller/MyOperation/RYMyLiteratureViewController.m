//
//  RYMyLiteratureViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/5/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyLiteratureViewController.h"
#import "RYMyLiteratureTableViewCell.h"
#import "RYLiteratureQueryViewController.h"
#import "MJRefreshTableView.h"


@interface RYMyLiteratureViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MJRefershTableViewDelegate,UIAlertViewDelegate>

@property (strong , nonatomic) MJRefreshTableView    *tableView;
@property (strong , nonatomic) UISearchBar           *searchBar;
@property (strong , nonatomic) UILabel               *hintLabel;     // 每次消耗多少积分 提示

@property (strong , nonatomic) NSMutableArray        *dataArray;


@end

@implementation RYMyLiteratureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文献查询";
    self.dataArray = [NSMutableArray array];
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


- (void) setup
{
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:[self tableViewHeadView]];
    [self.tableView headerBeginRefreshing];
}

- (void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        [NetRequestAPI getMyLiteratureListWithSessionId:[RYUserInfo sharedManager].session
                                                   page:currentPage
                                                success:^(id responseDic) {
                                                    NSLog(@"文献查询 responseDic : %@",responseDic);
                                                    [wSelf.tableView endRefreshing];
                                                    [wSelf analysisDataWithDict:responseDic isHeadRefresh:isHeaderReresh];
                                                    
                                                } failure:^(id errorString) {
                                                    NSLog(@"文献查询 errorString : %@",errorString);
                                                    [wSelf.tableView endRefreshing];
                                                    if ( wSelf.dataArray.count ) {
                                                        [ShowBox showError:@"数据出错"];
                                                    }
                                                }];
    }

    
}

- (void)analysisDataWithDict:(NSDictionary *)responseDic isHeadRefresh:(BOOL)isHead
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
    
    
    if ( isHead ) {
        [self.dataArray removeAllObjects];
    }
    
    NSArray *mydoimessage = [info getArrayValueForKey:@"mydoimessage" defaultValue:nil];
    if ( mydoimessage.count ) {
        [self.dataArray addObjectsFromArray:mydoimessage];
    }
    
    self.hintLabel.text = [info getStringValueForKey:@"msg" defaultValue:@""];
    [self.tableView reloadData];

}

- (UITableView *)tableView
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


- (UIView *)tableViewHeadView
{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    view.backgroundColor = [Utils getRGBColor:0xf2 g:0xf2 b:0xf2 a:1.0];
    
    UIView *searchBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    searchBG.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    [view addSubview:searchBG];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 4, SCREEN_WIDTH - 20, 28)];
    searchBar.layer.cornerRadius = 5.0f;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"请输入需要查询的DOI";
    searchBar.delegate = self;
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:14];
    searchBar.backgroundImage = [UIImage new];
    self.searchBar = searchBar;
    [searchBG addSubview:searchBar];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, searchBG.bottom + 8, SCREEN_WIDTH - 30, 12)];
    hintLabel.font = [UIFont systemFontOfSize:12];
    hintLabel.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
//    hintLabel.text = @"每次查询需要使用100积分";
    self.hintLabel = hintLabel;
    [view addSubview:hintLabel];
    
    UIButton *submitBtn = [Utils getCustomLongButton:@"申请查询"];
    submitBtn.frame = CGRectMake(15, hintLabel.bottom + 8, SCREEN_WIDTH - 30, 40);
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, submitBtn.bottom + 8, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [Utils getRGBColor:0xbd g:0xbd b:0xbd a:1.0];
    [view addSubview:line];
    
    UILabel *history = [[UILabel alloc] initWithFrame:CGRectMake(15, line.bottom + 8, SCREEN_WIDTH - 30, 12)];
    history.textColor = [Utils getRGBColor:0x99 g:0x99 b:0x99 a:1.0];
    history.text = @"查询列表";
    history.font = [UIFont systemFontOfSize:12];
    [view addSubview:history];
    
    return view;
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"申请查询");
    [self.searchBar resignFirstResponder];
    NSString *searchDoi = self.searchBar.text;
    searchDoi = [searchDoi stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( [ShowBox isEmptyString:searchDoi] ) {
        [ShowBox showError:@"doi不能为空"];
        return;
    }
    if ( [ShowBox checkCurrentNetwork] ) {
        [SVProgressHUD showWithStatus:@"查询中..." maskType:SVProgressHUDMaskTypeBlack];
        [NetRequestAPI postSeekLiteratureWithSessionId:[RYUserInfo sharedManager].session
                                                   doi:searchDoi
                                               success:^(id responseDic) {
                                                   NSLog(@"文献查询 responseDic :%@",responseDic);
                                                   [SVProgressHUD dismiss];
                                                   [self inspectSeekDoiDataWithDict:responseDic];
            
        } failure:^(id errorString) {
             NSLog(@"文献查询 errorString :%@",errorString);
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)inspectSeekDoiDataWithDict:(NSDictionary *)responseDic
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
    if ( info ) {
        RYLiteratureQueryViewController *vc = [[RYLiteratureQueryViewController alloc] initWithLiteratureDict:info];
        [self.navigationController pushViewController:vc animated:YES];
        [self.dataArray addObject:info];
        [self.tableView reloadData];
    }
}

#pragma mark -UISearchBar 代理方法
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.text = @"";
    UITextField *searchBarTextField = nil;
    if([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        for (UIView *subView in searchBar.subviews){
            for (UIView *ndLeveSubView in subView.subviews){
                if ([ndLeveSubView isKindOfClass:[UITextField class]]){
                    searchBarTextField = (UITextField *)ndLeveSubView;
                    break;
                }
            }
        }
    }else{
        for (UIView *subView in searchBar.subviews){
            if ([subView isKindOfClass:[UITextField class]]){
                searchBarTextField = (UITextField *)subView;
                break;
            }
        }
    }
    searchBarTextField.textColor = [Utils getRGBColor:0x33 g:0x33 b:0x33 a:1.0];
    searchBarTextField.enablesReturnKeyAutomatically = NO;
    searchBarTextField.returnKeyType = UIReturnKeyDone;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *query_cell = @"query_cell";
    RYMyLiteratureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:query_cell];
    if ( !cell ) {
        cell = [[RYMyLiteratureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:query_cell];
    }
    if ( self.dataArray.count ) {
        [cell setValueWithDict:[self.dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RYLiteratureQueryViewController *vc = [[RYLiteratureQueryViewController alloc] initWithLiteratureDict:[self.dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 140;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [self tableViewHeadView];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 140;
//}

@end
