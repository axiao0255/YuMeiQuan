//
//  RYMyEnshrineViewController.m
//  YuMeiQuan
//
//  Created by Jason on 15/4/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "RYMyEnshrineViewController.h"
#import "RYEnshrineTableViewCell.h"
#import "RYEnshrineClassifyViewController.h"
#import "MJRefreshTableView.h"
#import "RYArticleViewController.h"
#import "RYLiteratureDetailsViewController.h"
#import "RYTallyTokenViewController.h"


@interface RYMyEnshrineViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MJRefershTableViewDelegate>
{
    NSMutableArray             *dataArray;
}

@property (nonatomic,strong) MJRefreshTableView       *tableView;
@property (nonatomic,strong) NSString                 *keywords;         // 搜索时的关键字
@property (nonatomic,strong) UISearchBar              *searchBar;

@end

@implementation RYMyEnshrineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.keywords = nil;
    dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:[self tabelViewheadView]];
    [self.tableView headerBeginRefreshing];
    [self setNavigationBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tallyChangeUpdate:) name:@"tallyChangeUpdate" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNavigationBar
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"ic_Tally_category.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(goToClassify) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)tallyChangeUpdate:(NSNotification *)notic
{
    self.keywords = nil;
    self.tableView.totlePage = 1;
    self.tableView.currentPage = 0;
    [self getDataWithIsHeaderReresh:YES andCurrentPage:self.tableView.currentPage];
}

#pragma mark - MJRefershTableViewDelegate
- (void)getDataWithIsHeaderReresh:(BOOL)isHeaderReresh andCurrentPage:(NSInteger)currentPage
{
    if ( [ShowBox checkCurrentNetwork] ) {
        __weak typeof(self) wSelf = self;
        self.keywords = self.searchBar.text;
        [NetRequestAPI getMyCollectListWithSessionId:[RYUserInfo sharedManager].session
                                                fcid:nil
                                                page:currentPage
                                            keywords:self.keywords
                                             success:^(id responseDic) {
                                                 [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
                                                 NSLog(@"收藏 responseDic： %@",responseDic);
                                                 [wSelf analysisDataWithDict:responseDic isHeadRefresh:isHeaderReresh];
                                             } failure:^(id errorString) {
                                                 [wSelf tableViewRefreshEndWithIsHead:isHeaderReresh];
                                                 NSLog(@"收藏 errorString： %@",errorString);
                                                 
                                             }];
    }
}

// 列表获取数据之后， 回到原来的位置  ，如果不是上下拉刷新，则不需要调用 endRefreshing方法，会引起显示错误
- (void)tableViewRefreshEndWithIsHead:(BOOL)isHead
{
    //    if ( !self.notStretch ) {
    if ( isHead ) {
        [self.tableView headerFinishRefreshing];
    }
    else{
        [self.tableView footerFinishRereshing];
    }
    //    }
    //    else{
    //        self.notStretch = NO;
    //    }
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
    if ( dataArray.count == 0 ) {
        [ShowBox showError:@"未找到相关信息"];
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

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    RYEnshrineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[RYEnshrineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.editBtn.tag = indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (UIView *)tabelViewheadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headView.backgroundColor = [Utils getRGBColor:0x99 g:0xe1 b:0xff a:1.0];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH , 28)];
    searchBar.layer.cornerRadius = 5.0f;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"搜索收藏";
    searchBar.delegate = self;
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:14];
    searchBar.backgroundImage = [UIImage new];
    [headView addSubview:searchBar];
    
//    UIImage *selectImg = [UIImage imageNamed:@"icon_select.png"];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - selectImg.size.width, 0, selectImg.size.width, 35)];
//    btn.backgroundColor = [UIColor clearColor];
//    [btn setBackgroundImage:selectImg forState:UIControlStateNormal];
//    [btn setAdjustsImageWhenHighlighted:NO];
//    [btn addTarget:self action:@selector(goToClassify) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:btn];
    
    self.searchBar = searchBar;
    return headView;
}

#pragma mark - 进入分类界面
- (void)goToClassify
{
    NSLog(@"分类");
    RYEnshrineClassifyViewController *vc = [[RYEnshrineClassifyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    searchBarTextField.returnKeyType = UIReturnKeySearch;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ( searchBar.text.length ) {
        self.keywords = searchBar.text;
        self.tableView.totlePage = 1;
        self.tableView.currentPage = 0;
        [self getDataWithIsHeaderReresh:YES andCurrentPage:self.tableView.currentPage];
    }
    [searchBar resignFirstResponder];
}


#pragma mark 编辑标签
-(void)editBtnClick:(id)sender
{
    NSLog(@"编辑标签");
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dict = [dataArray objectAtIndex:btn.tag];
    NSString *tid = [dict getStringValueForKey:@"tid" defaultValue:@""];
    if ( ![ShowBox isEmptyString:tid] ) {
        RYTallyTokenViewController *vc = [[RYTallyTokenViewController alloc] initWithTid:tid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
